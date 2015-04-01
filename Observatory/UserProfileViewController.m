//
//  UserProfileViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-31.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "UserProfileViewController.h"

#import "User.h"

#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (nonatomic, strong) User *userProfile;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@end

@implementation UserProfileViewController

- (void)loadData {
    [User userInfomrationWithBlock:^(User *profile, NSError *error) {
        if (!error) {
            self.userProfile = profile;
            self.name.text = profile.name;
            self.username.text = profile.username;
            [self.avatar setImageWithURL:[NSURL URLWithString:profile.avatar]];
            self.followers.text = [profile.followers stringValue];
            self.following.text = [profile.following stringValue];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"User Profile", nil);
    [self loadData];
}

@end
