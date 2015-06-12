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
    NSDictionary *appInfos = [[NSBundle mainBundle] infoDictionary];
    
    NSString *repos = [appInfos objectForKey:@"GHUpdateRepos"];
    NSString *owner = [appInfos objectForKey:@"GHUpdateOwner"];
    NSString *version = [appInfos objectForKey:@"CFBundleShortVersionString"];
    
    [self checkAndUpdateFromRepos:repos by:owner withCurrentVersion:version];
}

+ (void)checkAndUpdateFromRepos:(NSString*)repos by:(NSString*)owner withCurrentVersion:(NSString*)currentVerion {
    [[GHLatestRelease sharedInstance] updateInfosFromRepos:repos
                                                        by:owner
                                                completion:^(GHLatestRelease *release, NSError *error) {
                                                    NSString *targetVersion = release.version;
                                                    if ([[targetVersion substringToIndex:1] isEqualToString:@"v"]) {
                                                        targetVersion = [targetVersion stringByReplacingCharactersInRange:(NSRange){0,1} withString:@""];
                                                    }
                                                    
                                                    if (![currentVerion isEqualToString:targetVersion]) {
                                                        
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
@end
