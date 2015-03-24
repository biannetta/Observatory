//
//  Repos.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repo : NSObject

@property (nonatomic, assign) NSUInteger repoID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *avatar;

- (instancetype)initWithAttributes: (NSDictionary *)attributes;

+ (NSURLSessionDataTask *)starredReposWithBlock:(void (^)(NSArray *repos, NSError *error))block;

@end
