//
//  GHUpdater.m
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import "GHUpdater.h"

#import "GHLatestRelease.h"

#import <Cocoa/Cocoa.h>

@implementation GHUpdater


+ (void)checkAndUpdate {
    [self checkAndUpdateWithBundleInfo:[[NSBundle mainBundle] infoDictionary]];
}

+ (void)checkAndUpdateWithBundleInfo:(NSDictionary*)bundleInfos {
    
    NSString *repos = [bundleInfos objectForKey:@"GHUpdateRepos"];
    NSString *owner = [bundleInfos objectForKey:@"GHUpdateOwner"];
    NSString *currentVerion = [bundleInfos objectForKey:@"CFBundleShortVersionString"];
    
    [[GHLatestRelease sharedInstance] updateInfosFromRepos:repos
                                                        by:owner
                                                completion:^(GHLatestRelease *release, NSError *error) {
                                                    NSString *targetVersion = release.version;
                                                    if ([[targetVersion substringToIndex:1] isEqualToString:@"v"]) {
                                                        targetVersion = [targetVersion stringByReplacingCharactersInRange:(NSRange){0,1} withString:@""];
                                                    }
                                                    
                                                    if ([self compareVersion:currentVerion with:targetVersion] == NSOrderedAscending) {
                                                        
                                                        NSAlert * updateMessage = [NSAlert new];
                                                        
                                                        updateMessage.alertStyle = NSInformationalAlertStyle;
                                                        updateMessage.messageText = [NSString stringWithFormat:@"Update %@ available (current %@)", targetVersion, currentVerion];
                                                        updateMessage.informativeText = release.desc;
                                                        
                                                        [updateMessage addButtonWithTitle:@"Download"];
                                                        [updateMessage addButtonWithTitle:@"Later"];
                                                                                   
                                                        [updateMessage beginSheetModalForWindow:[NSApp mainWindow]
                                                                              completionHandler:^(NSModalResponse returnCode) {
                                                                                  if (returnCode == NSAlertFirstButtonReturn) {
                                                                                      [[NSWorkspace sharedWorkspace] openURL:release.releaseURL];
                                                                                  }
                                                                              }];
                                                    }
                                                    
                                                    
                                                }];
}


+ (NSComparisonResult)compareVersion:(NSString*)localVersion with:(NSString*)remoteVersion {
    
    NSMutableArray *localComponents = [[localVersion componentsSeparatedByString:@"."] mutableCopy];
    NSMutableArray *remoteComponents = [[remoteVersion componentsSeparatedByString:@"."] mutableCopy];
    
    NSUInteger numberOfLocalComponents = [localComponents count];
    NSUInteger numberOfRemoteComponents = [remoteComponents count];
    
    if (numberOfLocalComponents > numberOfRemoteComponents) {
        NSUInteger componentsToAdd = numberOfLocalComponents - numberOfRemoteComponents;
        for (int i = 0; i < componentsToAdd; i++) {
            [remoteComponents addObject:@"0"];
            numberOfRemoteComponents++;
        }
    } else if (numberOfLocalComponents < numberOfRemoteComponents) {
        NSUInteger componentsToAdd = numberOfRemoteComponents - numberOfLocalComponents;
        for (int i = 0; i < componentsToAdd; i++) {
            [localComponents addObject:@"0"];
            numberOfLocalComponents++;
        }
    }
    
    for (int i = 0; i < numberOfLocalComponents; i++) {
        NSString *localDigit = [localComponents objectAtIndex:i];
        NSString *remoteDigit = [remoteComponents objectAtIndex:i];
        
        NSComparisonResult digitOrder = [localDigit compare:remoteDigit];
        
        if (digitOrder != NSOrderedSame) {
            return digitOrder;
        }
    }
    
    return NSOrderedSame;
}

@end
