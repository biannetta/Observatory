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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.username.text = [defaults stringForKey:@"username"];
    self.password.text = [defaults stringForKey:@"password"];
}

- (IBAction)saveUserSettings:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    if (username.length > 0 && password.length > 0) {
        [defaults setValue:username forKey:@"username"];
        [defaults setValue:password forKey:@"password"];
        
        NSURLSessionDataTask *task = [User authenticateUserWithBlock:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"%@", response);
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Info"
                                                        message:@"Username/Password are required fields"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)deleteUserSettings:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [AFGithubClient clearAuthentication];
    
    self.username.text = @"";
    self.password.text = @"";
}

@end
