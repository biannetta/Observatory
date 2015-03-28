//
//  GithubCredentials.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-27.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "GithubCredentials.h"

@implementation GithubCredentials

- (instancetype)initWithCredentials:(NSDictionary *)credentials {
    static GithubCredentials * _config = nil;
    
    _config = (GithubCredentials *)[NSURLSessionConfiguration defaultSessionConfiguration];
    [_config setHTTPAdditionalHeaders:@{@"Authorization" : [self githubAuthenticationWithUsername:[credentials valueForKey:@"username"] andPassword:[credentials valueForKey:@"password"]]}];
    
    return _config;
}

- (NSString *)githubAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSData *data = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:0]];
}

@end
