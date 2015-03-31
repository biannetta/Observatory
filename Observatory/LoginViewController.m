//
//  LoginViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-27.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "LoginViewController.h"

#import "User.h"

#import "GithubCredentials.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *githubLogo;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.githubLogo setImage:[UIImage imageNamed:@"github_logo"]];
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"username"].length != 0) {
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        NSLog(@"logged in");
    } else {
        NSLog(@"not logged in");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    if (username.length > 0 && password.length > 0) {
        [defaults setValue:username forKey:@"username"];
        [defaults setValue:password forKey:@"password"];
        
        [[GithubCredentials alloc] initWithCredentials:@{@"username":username, @"password":password}];
        [User authenticateUserWithBlock:^(NSDictionary *response, NSError *error) {
            NSLog(@"%@", error);
            if (!error) {
                [self performSegueWithIdentifier:@"loginSuccess" sender:self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad Info"
                                                                message:@"Username/Password is incorrect"
                                                               delegate:self
                                                      cancelButtonTitle:@"Okay"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Info"
                                                        message:@"Username/Password are required fields"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
