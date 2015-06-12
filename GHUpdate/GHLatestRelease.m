//
//  GHLatestRelease.m
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import "GHLatestRelease.h"
#import "GHAPI.h"

@interface GHLatestRelease ()

@property NSString *desc;
@property NSString *version;
@property NSURL *mainAssetURL;
@property NSURL *releaseURL;

@end

@implementation GHLatestRelease

+ (instancetype)sharedInstance {
    static GHLatestRelease *sharedInstanceGHLatestRelease;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanceGHLatestRelease = [self new];
    });
    
    return sharedInstanceGHLatestRelease;
}

- (void)updateInfos:(void(^)(GHLatestRelease *release, NSError *error))completionHandler {
    NSDictionary *appInfos = [[NSBundle mainBundle] infoDictionary];
    
    NSString *repos = [appInfos objectForKey:@"GHUpdateRepos"];
    NSString *owner = [appInfos objectForKey:@"GHUpdateOwner"];
    
    [self updateInfosFromRepos:repos by:owner completion:completionHandler];
}

- (void)updateInfosFromRepos:(NSString*)repos by:(NSString*)owner completion:(void(^)(GHLatestRelease *release, NSError *error))completionHandler {
    
    if ([repos length] && [owner length]) {
        GHAPI *api = [GHAPI apiForRepos:repos
                                     by:owner];
        
        [api latestRelease:^(NSDictionary *infos, NSError *error) {
            if (infos) {
                self.desc = [infos objectForKey:@"body"];
                self.version = [infos objectForKey:@"tag_name"];
                self.mainAssetURL = [NSURL URLWithString:[[[infos objectForKey:@"assets"] firstObject] objectForKey:@"browser_download_url"]];
                self.releaseURL = [NSURL URLWithString:[infos objectForKey:@"html_url"]];
                
                completionHandler(self, nil);
            } else {
                completionHandler(self, error);
            }
        }];
        
    } else {
        completionHandler(self, [NSError errorWithDomain:@"com.inig-services.ghupdate"
                                              code:1
                                          userInfo:@{NSLocalizedDescriptionKey: @"GHUpdateOwner or GHUpdateRepos key(s) mssing in app infos"}]);
    }
}

@end
