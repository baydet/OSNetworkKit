//
// Created by Alexander Evsyuchenya on 8/10/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSRequestOperation.h"
#import "OSRestKitOperationProtocol.h"


@interface OSRKRequestOperation : OSRequestOperation <OSRestKitOperationProtocol>
{
    RKRequestMethod _requestMethod;
}
- (instancetype)initWithRequestMethod:(RKRequestMethod)requestMethod NS_DESIGNATED_INITIALIZER;

@end