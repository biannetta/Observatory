//
//  Repos.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "Repo.h"

#import "AFGithubClient.h"
#import "GithubCredentials.h"

static NSString * const GithubStarredRepoURL = @"users/%@/starred";

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

#pragma mark - Fetch Repos

+ (NSURLSessionDataTask *)starredReposWithBlock:(void (^)(NSArray *repos, NSError *error))block {
    return [self starredReposWithParameters:nil andBlock:block];
}

+ (NSURLSessionDataTask *)starredReposWithParameters:(NSDictionary *)parameters andBlock:(void (^)(NSArray *, NSError *))block {
    AFGithubClient *githubClient = [AFGithubClient sharedClient];
    [[githubClient requestSerializer] setValue:[GithubCredentials sharedConfiguration] forHTTPHeaderField:@"Authorization"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *starredURL = [NSString stringWithFormat:GithubStarredRepoURL, [defaults stringForKey:@"username"]];
    
    return [githubClient GET:starredURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
        // Logging HTTP Headers
        if ([task.response respondsToSelector:@selector(allHeaderFields)]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"%@",[r allHeaderFields]);
        }
        
        if (block) {
            block([NSArray array], error);
        }
    }];

}

@end
