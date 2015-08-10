//
// Created by Alexander Evsyuchenya on 8/10/15.
// Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <RestKit/CoreData/RKManagedObjectStore.h>
#import <RestKit/CoreData/RKInMemoryManagedObjectCache.h>
#import <RestKit/Support/RKPathUtilities.h>
#import "OSObjectManager.h"


@implementation OSObjectManager

+ (instancetype)managerWithBaseURL:(NSURL *)baseURL databaseName:(NSString *)dataBaseName
{
    RKObjectManager *const manager = [super managerWithBaseURL:baseURL];
    manager.HTTPClient.parameterEncoding = AFJSONParameterEncoding;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    manager.managedObjectStore = managedObjectStore;
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:dataBaseName];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    [managedObjectStore createManagedObjectContexts];
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    return manager;
}

@end