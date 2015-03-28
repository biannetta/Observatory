//
//  GithubCredentials.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-27.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubCredentials : NSURLSessionConfiguration

- (instancetype)initWithCredentials:(NSDictionary *)credentials;
- (NSString *)githubAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
