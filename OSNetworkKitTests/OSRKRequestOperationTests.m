//
//  OSNetworkKitTests.m
//  OSNetworkKitTests
//
//  Created by Alexandr Evsyuchenya on 5/23/15.
//  Copyright (c) 2015 Orangesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OSObjectManager.h"
#import "OSRKRequestOperation.h"

@interface OSTestOperation : OSRKRequestOperation
@end

@implementation OSTestOperation

+ (RKMapping *)mapping
{
    return [RKMapping new];
}

+ (NSArray *)responseDescriptors
{
    return @[[RKResponseDescriptor responseDescriptorWithMapping:[self mapping] method:RKRequestMethodGET pathPattern:[self URLPattern] keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

+ (RKMapping *)errorMapping
{
    return [RKMapping new];
}


@end

@interface OSRKRequestOperationTests : XCTestCase
@property(nonatomic, strong) OSObjectManager *manager;
@property(nonatomic) NSUInteger responseDescriptorsCount;
@property(nonatomic) NSUInteger requestDescriptorsCount;
@property(nonatomic) NSUInteger routesCount;
@property(nonatomic) NSUInteger fetchRequestBlocksCount;
@end

@implementation OSRKRequestOperationTests

- (void)setUp {
    [super setUp];
    self.manager = [OSObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://www.example.com/api"] databaseName:@"testDatabase.sqlite"];
    self.responseDescriptorsCount = self.manager.responseDescriptors.count;
    self.requestDescriptorsCount = self.manager.responseDescriptors.count;
    self.routesCount = self.manager.responseDescriptors.count;
    self.fetchRequestBlocksCount = self.manager.responseDescriptors.count;
    [OSTestOperation new];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testProtocol {
    const NSUInteger expectedResponseDescriptorsCount = self.responseDescriptorsCount + [OSTestOperation responseDescriptors].count + ([OSTestOperation errorMapping] ? 1 : 0);
    XCTAssert(expectedResponseDescriptorsCount == self.manager.responseDescriptors.count, @"unexpected number of response descriptors. Expected %lu, Actual %lu", expectedResponseDescriptorsCount, self.manager.responseDescriptors.count);
    const NSUInteger expectedRequestDescriptorsCount = self.requestDescriptorsCount + ([OSTestOperation requestDescriptor] ? 1 : 0);
    XCTAssert(expectedRequestDescriptorsCount == self.manager.requestDescriptors.count, @"unexpected number of request descriptors. Expected %lu, Actual %lu", expectedRequestDescriptorsCount, self.manager.requestDescriptors.count);
}


@end
