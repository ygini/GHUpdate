//
//  GHLatestRelease.h
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHLatestRelease : NSObject

@property (readonly) NSString *desc;
@property (readonly) NSString *version;
@property (readonly) NSURL *mainAssetURL;
@property (readonly) NSURL *releaseURL;

+ (instancetype)sharedInstance;
- (void)updateInfos:(void(^)(GHLatestRelease *release, NSError *error))completionHandler;
- (void)updateInfosFromRepos:(NSString*)repos by:(NSString*)owner completion:(void(^)(GHLatestRelease *release, NSError *error))completionHandler;

@end
