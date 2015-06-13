//
//  GHUpdateTests.m
//  GHUpdateTests
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "GHUpdater.h"

#import "GHLatestRelease.h"

@interface GHUpdater (PrivatePrototype)
+ (NSComparisonResult)compareVersion:(NSString*)localVersion with:(NSString*)remoteVersion;
@end

@interface GHUpdateTests : XCTestCase

@end

@implementation GHUpdateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVersionComparaison {
    // Regular version number
    XCTAssertEqual([GHUpdater compareVersion:@"1.0" with:@"2.0"], NSOrderedAscending, @"1.0 shoul be < to 2.0");
    XCTAssertEqual([GHUpdater compareVersion:@"1.0" with:@"1.0.1"], NSOrderedAscending, @"1.0 shoul be < to 1.0.1");
    
    XCTAssertEqual([GHUpdater compareVersion:@"3.0" with:@"2.0"], NSOrderedDescending, @"3.0 shoul be > to 2.0");
    XCTAssertEqual([GHUpdater compareVersion:@"1.0.2" with:@"1.0.1"], NSOrderedDescending, @"1.0.2 shoul be > to 1.0.1");
    
    XCTAssertEqual([GHUpdater compareVersion:@"3.0" with:@"3.0.0"], NSOrderedSame, @"3.0 shoul be = to 3.0.0");
    XCTAssertEqual([GHUpdater compareVersion:@"1.0.1" with:@"1.0.1"], NSOrderedSame, @"1.0.1 shoul be = to 1.0.1");
    
    
    // Advanced version number
    XCTAssertEqual([GHUpdater compareVersion:@"1.0a" with:@"2.0"], NSOrderedAscending, @"1.0a shoul be < to 2.0");
    XCTAssertEqual([GHUpdater compareVersion:@"1.0a" with:@"1.0b"], NSOrderedAscending, @"1.0a shoul be < to 1.0b");
    XCTAssertEqual([GHUpdater compareVersion:@"1.0" with:@"1.0a"], NSOrderedAscending, @"1.0 shoul be < to 1.0a");
    
    XCTAssertEqual([GHUpdater compareVersion:@"2.0a" with:@"2.0"], NSOrderedDescending, @"3.0a shoul be > to 2.0");
    XCTAssertEqual([GHUpdater compareVersion:@"2.0b" with:@"2.0a"], NSOrderedDescending, @"1.0.1a shoul be > to 1.0.1");
    XCTAssertEqual([GHUpdater compareVersion:@"2.0a" with:@"1.0a"], NSOrderedDescending, @"1.0.1a shoul be > to 1.0.1");
    
    XCTAssertEqual([GHUpdater compareVersion:@"3.0a" with:@"3.0a"], NSOrderedSame, @"3.0 shoul be = to 3.0.0");
    
    
    // Beta version number
    XCTAssertEqual([GHUpdater compareVersion:@"2.0-beta1" with:@"2.0-beta2"], NSOrderedAscending, @"2.0-beta1 shoul be < 2.0-beta2");
    
    XCTAssertEqual([GHUpdater compareVersion:@"2.0-beta3" with:@"2.0-beta2"], NSOrderedDescending, @"2.0-beta3 shoul be > 2.0-beta2");
    
    XCTAssertEqual([GHUpdater compareVersion:@"2.0-beta2" with:@"2.0-beta2"], NSOrderedSame, @"2.0-beta2 shoul be = 2.0-beta2");
}

- (void)testAPIResult {
    [[GHLatestRelease sharedInstance] updateInfosFromRepos:@"GHUpdater"
                                                        by:@"ygini"
                                                completion:^(GHLatestRelease *release, NSError *error) {
                                                    NSString *targetVersion = release.version;
                                                    
                                                    XCTAssertEqual(targetVersion, @"1.0", @"Latest production release should be 1.0 (this test require Internet access)");
                                                    
                                                }];
}

@end
