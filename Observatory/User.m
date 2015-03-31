//
//  User.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-25.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "User.h"
#import "AFGithubClient.h"
#import "GithubCredentials.h"

static NSString * const GithubUserURL = @"user";

@implementation User

#pragma mark NSCoding

+ (NSURLSessionDataTask *)authenticateUserWithBlock:(void (^)(NSDictionary *response, NSError *error))block {
    [[[AFGithubClient sharedClient] requestSerializer] setValue:[GithubCredentials sharedConfiguration] forHTTPHeaderField:@"Authorization"];
    return [[AFGithubClient sharedClient] GET:GithubUserURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
}

@end
