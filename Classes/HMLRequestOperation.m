//
// Created by Alexandr Evsyuchenya on 2/6/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <RestKit/ObjectMapping/RKHTTPUtilities.h>
#import "HMLRequestOperation.h"
#import "HMLRequestOperation_Protected.h"

@interface HMLRequestOperation ()
@property(nonatomic) BOOL finishedFlag;
@property(nonatomic) BOOL executingFlag;
@end

@implementation HMLRequestOperation
{
    BOOL _finishedFlag;
    BOOL _executingFlag;
}


+ (NSString *)URLPattern
{
    return @"";
}

- (void)callFinishBlockWithData:(id const)data error:(NSError *)error
{
    self.finishedFlag = YES;
    self.executingFlag = NO;
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
    dispatch_once(&token, ^{
        RKMapping *const errorMapping = [self errorMapping];
        if (errorMapping)
        {
            RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
            [manager addResponseDescriptor:responseDescriptor];
        }
    });

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
    return _finishedFlag;
}

- (BOOL)isExecuting
{
    return _executingFlag;
}

- (void)setFinishedFlag:(BOOL)finishedFlag
{
    [self willChangeValueForKey:@"isFinished"];
    _finishedFlag = finishedFlag;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecutingFlag:(BOOL)executingFlag
{
    [self willChangeValueForKey:@"isExecuting"];
    _executingFlag = executingFlag;
    [self didChangeValueForKey:@"isExecuting"];
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
    return ^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [self callFinishBlockWithData:nil error:error];
    };
}

- (NSDictionary *)parameters
{
    return @{};
}

- (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))successBlock
{
    return ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self callFinishBlockWithData:mappingResult.array error:nil];
    };
}

- (void)start
{
    _finishedFlag = NO;
    _executingFlag = YES;
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
    HMLRequestOperation *copy = (HMLRequestOperation *) [[[self class] allocWithZone:zone] init];

    if (copy != nil)
    {
        copy->_requestMethod = _requestMethod;
        copy.finishBlock = self.finishBlock;
        copy.object = self.object;
    }

    return copy;
}

@end