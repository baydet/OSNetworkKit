//
// Created by Alexandr Evsyuchenya on 2/6/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/ObjectMapping/RKHTTPUtilities.h>
#import "RestKit.h"


@interface HMLRequestOperation : NSOperation <NSCopying>
{
    RKRequestMethod _requestMethod;
}
- (instancetype)initWithRequestMethod:(RKRequestMethod)requestMethod NS_DESIGNATED_INITIALIZER;

//callback methods
@property(nonatomic, copy) void (^finishBlock)(id responseObject, NSError *error);
@property(nonatomic, strong) id object;

@end