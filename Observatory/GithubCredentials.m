//
//  GithubCredentials.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-27.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "GithubCredentials.h"

@implementation GithubCredentials

+ (NSString *)createLoginCredentials:(NSDictionary *)credentials {
    return [self githubBasicAuthenticationWithUsername:[credentials valueForKey:@"username"] andPassword:[credentials valueForKey:@"password"]];
}

+ (NSString *)githubBasicAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSData *data = [[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"Basic %@", [data base64EncodedStringWithOptions:0]];
}

+ (NSString *)getBasicAuthentication {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"basic_auth"];
}

@end
