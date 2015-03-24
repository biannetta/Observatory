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
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [config setHTTPAdditionalHeaders:@{@"Authorization" : [self githubAuthenticationWithUsername:@"biannetta" andPassword:@"459hnh794"]}];
        
        _sharedClient = [[AFGithubClient alloc] initWithBaseURL:[NSURL URLWithString:AFGithubAPIBaseURL] sessionConfiguration:config];
        _sharedClient.linkURLS = nil;
    });
    
    return _sharedClient;
}

+ (NSString *)githubAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSData *data = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:0]];
}

@end
