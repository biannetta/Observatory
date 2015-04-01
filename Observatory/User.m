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

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.userID    = (NSUInteger)[[attributes valueForKey:@"id"] integerValue];
    self.username  = [attributes valueForKey:@"login"];
    self.name      = [attributes valueForKey:@"name"];
    self.email     = [attributes valueForKey:@"email"];
    self.location  = [attributes valueForKey:@"location"];
    self.avatar    = [attributes valueForKey:@"avatar_url"];
    self.bio       = [attributes valueForKey:@"bio"];
    self.followers = [attributes valueForKey:@"followers"];
    self.following = [attributes valueForKey:@"following"];
    
    return self;
}

+ (NSURLSessionDataTask *)userInfomrationWithBlock:(void (^)(User *profile, NSError *error))block {
    [[[AFGithubClient sharedClient] requestSerializer] setValue:[GithubCredentials getBasicAuthentication] forHTTPHeaderField:@"Authorization"];
    return [[AFGithubClient sharedClient] GET:GithubUserURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block([[User alloc] initWithAttributes:responseObject], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)authenticateUserWithBlock:(void (^)(NSDictionary *response, NSError *error))block {
    [[[AFGithubClient sharedClient] requestSerializer] setValue:[GithubCredentials getBasicAuthentication] forHTTPHeaderField:@"Authorization"];
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
