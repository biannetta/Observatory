//
//  User.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-25.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "User.h"
#import "AFGithubClient.h"

static NSString * const GithubUserURL = @"user";

@implementation User

#pragma mark NSCoding

+ (NSURLSessionDataTask *)authenticateUserWithBlock:(void (^)(NSDictionary *response, NSError *error))block {    
    return [[AFGithubClient sharedClient] GET:GithubUserURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // Review HTTP Headers
        if ([task.response respondsToSelector:@selector(allHeaderFields)]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"%@", r);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
}

@end
