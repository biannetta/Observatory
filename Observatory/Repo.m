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
    self.language = [attributes valueForKey:@"language"] == (id)[NSNull null] ? @"Markdown" : [attributes valueForKey:@"language"];
    self.avatar   = [[attributes valueForKey:@"owner"] valueForKey:@"avatar_url"];

    return self;
}

#pragma mark -

+ (NSURLSessionDataTask *)starredReposWithBlock:(void (^)(NSArray *repos, NSError *error))block {
    AFGithubClient *githubClient = [AFGithubClient sharedClient];
    NSDictionary *parameters = nil;
    
    if (githubClient.linkURLS) {
        NSNumber *nextPage;
        NSNumber *lastPage;
        
        for (int i=0; i < [githubClient.linkURLS count]; i ++) {
            NSArray *link = [githubClient.linkURLS[i] componentsSeparatedByString:@";"];
            NSLog(@"%@", link);
            if ([link[1] rangeOfString:@"next"].location != NSNotFound) {
                nextPage = (NSNumber *)[link[0] substringWithRange:NSMakeRange([link[0] rangeOfString:@"page="].location + 5, 1)];
                parameters = @{@"page":nextPage};
            }
            
            if ([link[1] rangeOfString:@"last"].location != NSNotFound) {
                lastPage = (NSNumber *)[link[0] substringWithRange:NSMakeRange([link[0] rangeOfString:@"page="].location + 5, 1)];
            }
        }
        if (lastPage == nextPage) {
            return nil;
        }
    }
        
    return [githubClient GET:@"users/biannetta/starred" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *reposFromResponse = responseObject;
        
        // Review HTTP Headers
        if ([task.response respondsToSelector:@selector(allHeaderFields)]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            githubClient.linkURLS = [[[r allHeaderFields] valueForKey:@"Link"] componentsSeparatedByString:@","];
        }
        
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
