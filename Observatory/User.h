//
//  User.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-25.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSNumber *followers;
@property (nonatomic, strong) NSNumber *following;

- (instancetype)initWithAttributes: (NSDictionary *)attributes;

+ (NSURLSessionDataTask *)userInfomrationWithBlock:(void (^)(User *profile, NSError *error))block;
+ (NSURLSessionDataTask *)authenticateUserWithBlock:(void (^)(NSDictionary *response, NSError *error))block;

@end
