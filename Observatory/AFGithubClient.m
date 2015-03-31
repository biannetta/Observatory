//
//  AFGithubClient.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "AFGithubClient.h"

static NSString * const AFGithubAPIBaseURL = @"https://api.github.com/";

@implementation AFGithubClient

+ (instancetype)sharedClient {
    static AFGithubClient * _sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFGithubClient alloc] initWithBaseURL:[NSURL URLWithString:AFGithubAPIBaseURL]];
    });
    
    return _sharedClient;
}

+ (void)clearAuthentication {
    [[[self sharedClient] requestSerializer] setValue:nil forHTTPHeaderField:@"Authorization"];
}

@end
