//
//  AFGithubClient.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFGithubClient : AFHTTPSessionManager

@property (nonatomic, strong) NSArray *linkURLS;

+ (instancetype)sharedClient;
+ (NSString *)githubAuthenticationWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
