//
// Created by Alexander Evsyuchenya on 8/10/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/Network/RKObjectManager.h>


@interface OSObjectManager : RKObjectManager

+ (instancetype)managerWithBaseURL:(NSURL *)baseURL;
+ (instancetype)managerWithBaseURL:(NSURL *)baseURL databaseName:(NSString *)dataBaseName;

@end