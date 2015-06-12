//
//  GHAPI.m
//  GHUpdate
//
//  Created by Yoann Gini on 12/06/2015.
//  Copyright (c) 2015 iNig-Services. All rights reserved.
//

#import "GHAPI.h"

@interface GHAPI ()

@property NSString *repos;
@property NSString *owner;

@end

static NSString *BaseURLString = @"https://api.github.com/";

@implementation GHAPI

+(instancetype)apiForRepos:(NSString*)repos by:(NSString*)owner {
    GHAPI *api = [GHAPI new];
    api.owner = owner;
    api.repos = repos;
    return api;
}

-(void)latestRelease:(void(^)(NSDictionary *infos, NSError *error))completion {
    [self GETRelativeJSON:[NSString stringWithFormat:@"%@/repos/%@/%@/releases/latest", BaseURLString, self.owner, self.repos]
    withCompletionHandler:^(id jsonObject, NSError *error) {
        if (jsonObject) {
            completion(jsonObject, nil);
        } else {
            completion(nil, error);
        }
    }];
}

#pragma mark - Network Requests

-(void)GETRelativeJSON:(NSString*)relativeURLString withCompletionHandler:(void(^)(id jsonObject, NSError *error))completion{
    NSURL *finalURL = [NSURL URLWithString:relativeURLString relativeToURL:[NSURL URLWithString:BaseURLString]];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:finalURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSError *err;
                                   id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:&err];
                                   
                                   if (jsonObject) {
                                       completion(jsonObject, nil);
                                   } else {
                                       completion(nil, err);
                                   }
                               } else {
                                   completion(nil, connectionError);
                               }
                           }];
}

@end
