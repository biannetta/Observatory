//
//  RepoViewController.h
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-31.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Repo.h"

@interface RepoViewController : UIViewController <UIAlertViewDelegate>

- (void)setDetail:(Repo *)detail;
- (void)onDeletion:(void (^)(void))block;

@end
