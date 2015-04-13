//
//  RepoViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-31.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "RepoViewController.h"

#import "Repo.h"

#import "UIImageView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

@interface RepoViewController ()
@property (readwrite, nonatomic, strong) Repo *repo;
@property (weak, nonatomic) IBOutlet UIImageView *repoAvatar;
@property (weak, nonatomic) IBOutlet UILabel *repoName;
@property (weak, nonatomic) IBOutlet UILabel *repoLanguage;
@property (weak, nonatomic) IBOutlet UILabel *stars;
@property (weak, nonatomic) IBOutlet UILabel *forks;
@property (copy, nonatomic) void (^deleteRowBlock)(void);
@end

@implementation RepoViewController

- (void)setDetail:(Repo *)detail {
    _repo = detail;
}

- (void)onDeletion:(void (^)(void))block {
    self.deleteRowBlock = block;
}

#pragma mark Repo Actions

- (void)unstarRepo {
    if (false) {
        NSURLSessionDataTask *task = [self.repo unstarRepoWithBlock:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"unstarred");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    } else {
        // Assume the repo has been unstarred
        [self.navigationController popViewControllerAnimated:YES];
        self.deleteRowBlock();
    }
}

#pragma mark UIViewControls

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repoName.text = self.repo.name;
    self.repoLanguage.text = self.repo.language;
    self.stars.text = [self.repo.stars stringValue];
    self.forks.text = [self.repo.forks stringValue];
    [self.repoAvatar setImageWithURL:[NSURL URLWithString:self.repo.avatar]];
    
}

- (IBAction)unstarRepoAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Do you want to unstar?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // Cancelled action
            break;
        case 1:
            [self unstarRepo];
            break;
        default:
            // Unknown choice
            NSLog(@"How did we get here");
            break;
    }
}

@end
