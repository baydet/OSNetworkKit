//
// Created by Alexander Evsyuchenya on 8/10/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import "OSRKRequestOperation.h"


typedef NS_ENUM(NSInteger, OSOperationState){
    OSInitital,
    OSExecuting,
    OSFinished,
};

@interface OSRKRequestOperation ()
@property(nonatomic, assign) OSOperationState operationState;
@end


@implementation OSRKRequestOperation

+ (NSSet *) keyPathsForValuesAffectingIsExecuting {
    return [NSSet setWithObject:@"operationState"];
}

+ (NSSet *) keyPathsForValuesAffectingIsFinished {
    return [NSSet setWithObject:@"operationState"];
}

+ (NSString *)URLPattern
{
    return @"";
}

- (void)callFinishBlockWithData:(id const)data error:(NSError *)error
{
    self.operationState = OSFinished;
    if (self.finishBlock)
    {
        self.finishBlock(data, error);
    }
}

- (instancetype)init
{
    return [self initWithRequestMethod:RKRequestMethodGET];
}

- (instancetype)initWithRequestMethod:(RKRequestMethod)requestMethod
{
    self = [super init];
    if (self)
    {
        _requestMethod = requestMethod;
    }

    return self;
}

+ (void)initialize
{
    RKObjectManager *const manager = [RKObjectManager sharedManager];
    RKRequestDescriptor *const requestDescriptor = [[self class] requestDescriptor];
    NSArray *const responseDescriptors = [[self class] responseDescriptors];
    RKRoute *const route = [[self class] route];

    static dispatch_once_t token = nil;
    RKMapping *const errorMapping = [self errorMapping];
    if (errorMapping)
    {
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
        [manager addResponseDescriptor:responseDescriptor];
    }

    if (requestDescriptor)
        [manager addRequestDescriptor:requestDescriptor];
    if (responseDescriptors)
        [manager addResponseDescriptorsFromArray:responseDescriptors];
    if (route)
        [manager.router.routeSet addRoute:route];
#ifdef RKCoreDataIncluded
    NSFetchRequest *(^const fetchRequestBlock)(NSURL *) = [self fetchRequestBlock];
    if (fetchRequestBlock)
        [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
            RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:[URL relativePath]];
            BOOL match = [pathMatcher matchesPath:[self URLPattern] tokenizeQueryStrings:NO parsedArguments:nil];
            if (match)
            {
                return fetchRequestBlock(URL);
            }
            return nil;
        }];
#endif

}

+ (RKMapping *)errorMapping
{
    return nil;
}

- (BOOL)isFinished
{
    return self.operationState == OSFinished;
}

- (BOOL)isExecuting
{
    return self.operationState == OSExecuting;
}

+ (RKMapping *)mapping
{
    return nil;
}

+ (RKRoute *)route
{
    return nil;
}

+ (NSArray *)responseDescriptors
{
    return nil;
}

+ (RKRequestDescriptor *)requestDescriptor
{
    return nil;
}

+ (NSFetchRequest *(^)(NSURL *))fetchRequestBlock
{
    return nil;
}


- (void (^)(RKObjectRequestOperation *, NSError *))errorBlock
{
    __weak typeof(self) wSelf = self;
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [wSelf callFinishBlockWithData:nil error:error];
    };
}

- (NSDictionary *)parameters
{
    return @{};
}

- (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))successBlock
{
    __weak typeof(self) wSelf = self;
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [wSelf callFinishBlockWithData:mappingResult.array error:nil];
    };
}

- (void)start
{
    self.operationState = OSExecuting;
    RKObjectRequestOperation *const o = [self operation];
    [[RKObjectManager sharedManager].operationQueue addOperation:o];
}

- (RKObjectRequestOperation *const)operation
{
    NSString *path = self.object == nil ? [[self class] URLPattern] : nil;
    RKObjectRequestOperation *const o = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:self.object method:_requestMethod path:path parameters:self.parameters];
    [o setCompletionBlockWithSuccess:self.successBlock failure:self.errorBlock];
    return o;
}

- (id)copyWithZone:(NSZone *)zone
{
    OSRKRequestOperation *copy = (OSRKRequestOperation *) [super copyWithZone:zone];

    if (copy != nil)
    {
        copy->_requestMethod = _requestMethod;
    }

    return copy;
}


@end