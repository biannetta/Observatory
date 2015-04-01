//
//  SettingTableViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-25.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "SettingTableViewController.h"

#import "User.h"
#import "AFGithubClient.h"

#import "UIAlertView+AFNetworking.h"

@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation SettingTableViewController

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)deleteUserSettings:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [AFGithubClient clearAuthentication];
}

@end
