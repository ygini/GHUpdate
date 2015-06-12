//
//  GHAPI.h
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHAPI : NSObject

+(instancetype)apiForRepos:(NSString*)repos by:(NSString*)owner;
-(void)latestRelease:(void(^)(NSDictionary *infos, NSError *error))completion;

@end
