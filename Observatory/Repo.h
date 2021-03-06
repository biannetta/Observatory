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
@property (nonatomic, strong) NSNumber *stars;
@property (nonatomic, strong) NSNumber *forks;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *repoURL;

- (instancetype)initWithAttributes: (NSDictionary *)attributes;
- (NSURLSessionDataTask *)unstarRepoWithBlock:(void (^)(NSDictionary *response, NSError *error))block;

+ (NSURLSessionDataTask *)starredReposWithBlock:(void (^)(NSArray *repos, NSError *error))block;
+ (NSURLSessionDataTask *)starredReposWithParameters:(NSDictionary *)parameters andBlock:(void (^)(NSArray *, NSError *))block;

@end
