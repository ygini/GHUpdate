//
//  GHLatestRelease.m
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import "GHLatestRelease.h"
#import "GHAPI.h"

@implementation GHLatestRelease

+ (instancetype)sharedInstance {
    static GHLatestRelease *sharedInstanceGHLatestRelease;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanceGHLatestRelease = [self new];
    });
    
    return sharedInstanceGHLatestRelease;
}
- (void)updateInfos:(void(^)(NSError *error))completionHandler {
    NSDictionary *appInfos = [[NSBundle mainBundle] infoDictionary];
    
    NSString *repos = [appInfos objectForKey:@"GHUpdateRepos"];
    NSString *owner = [appInfos objectForKey:@"GHUpdateOwner"];
    
    if ([repos length] && [owner length]) {
        GHAPI *api = [GHAPI apiForRepos:repos
                                     by:owner];
        
        [api latestRelease:^(NSDictionary *infos, NSError *error) {
            if (infos) {
                NSLog(@"%@", infos);
                
                completionHandler(nil);
            } else {
                completionHandler(error);
            }
        }];
        
    } else {
        completionHandler([NSError errorWithDomain:@"com.inig-services.ghupdate"
                                              code:1
                                          userInfo:@{NSLocalizedDescriptionKey: @"GHUpdateOwner or GHUpdateRepos key(s) mssing in app infos"}]);
    }
}

@end
