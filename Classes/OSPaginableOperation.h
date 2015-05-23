//
// Created by Alexandr Evsyuchenya on 2/9/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSRequestOperation.h"


@protocol OSPaginableOperation <NSObject>
@required
@property(nonatomic, assign) NSUInteger page;
@property(nonatomic, assign) NSUInteger perPage;
@end