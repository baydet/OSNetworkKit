//
// Created by Alexandr Evsyuchenya on 2/6/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <RestKit/ObjectMapping/RKHTTPUtilities.h>
#import "OSRequestOperation.h"
#import "OSRestKitOperationProtocol.h"


@implementation OSRequestOperation

- (id)copyWithZone:(NSZone *)zone
{
    OSRequestOperation *copy = (OSRequestOperation *) [[[self class] allocWithZone:zone] init];

    if (copy != nil)
    {
        copy.finishBlock = self.finishBlock;
        copy.object = self.object;
    }

    return copy;
}

@end
