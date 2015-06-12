//
//  GHLatestRelease.h
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHLatestRelease : NSObject

+ (instancetype)sharedInstance;
- (void)updateInfos:(void(^)(NSError *error))completionHandler;

@end
