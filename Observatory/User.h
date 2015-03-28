//
//  User.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-25.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (NSURLSessionDataTask *)authenticateUserWithBlock:(void (^)(NSDictionary *response, NSError *error))block;

@end
