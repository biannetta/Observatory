//
//  Repos.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "Repo.h"

#import "AFGithubClient.h"

@implementation Repo

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.repoID   = (NSUInteger)[[attributes valueForKey:@"id"] integerValue];
    self.name     = [attributes valueForKey:@"name"];
    self.language = [attributes valueForKey:@"language"];
    
    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)starredReposWithBlock:(void (^)(NSArray *repos, NSError *error))block {
    return [[AFGithubClient sharedClient] GET:@"users/biannetta/starred" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *reposFromResponse = responseObject;
        NSMutableArray *mutableRepos = [NSMutableArray arrayWithCapacity:[reposFromResponse count]];
        for (NSDictionary *attributes in reposFromResponse) {
            Repo *repo = [[Repo alloc]initWithAttributes:attributes];
            [mutableRepos addObject:repo];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableRepos], nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
