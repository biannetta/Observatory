//
//  GithubCredentials.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-27.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubCredentials : NSObject

+ (NSString *)createLoginCredentials:(NSDictionary *)credentials;
+ (NSString *)githubBasicAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password;
+ (NSString *)getBasicAuthentication;

@end
