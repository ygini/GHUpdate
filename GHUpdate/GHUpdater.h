//
//  GHUpdater.h
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHUpdater : NSObject

+ (void)checkAndUpdate;
+ (void)checkAndUpdateFromRepos:(NSString*)repos by:(NSString*)owner withCurrentVersion:(NSString*)currentVerion;

@end
