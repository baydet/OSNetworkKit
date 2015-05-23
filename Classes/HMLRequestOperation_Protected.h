//
// Created by Alexandr Evsyuchenya on 2/6/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "HMLRequestOperation.h"


@interface HMLRequestOperation (Protected)

@property(readonly) NSDictionary *parameters;
@property(readonly) void (^successBlock)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult);

//methods for subclassing

+ (NSString *)URLPattern;

+ (RKMapping *)mapping;

+ (RKMapping *)errorMapping;

+ (RKRoute *)route;

+ (NSArray *)responseDescriptors;

+ (RKRequestDescriptor *)requestDescriptor;

+ (NSFetchRequest *(^)(NSURL *))fetchRequestBlock;

- (void (^)(RKObjectRequestOperation *, NSError *))errorBlock;

- (void)callFinishBlockWithData:(id const)data error:(NSError *)error;

- (RKObjectRequestOperation *const)operation;
@end