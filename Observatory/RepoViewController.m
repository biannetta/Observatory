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
@end

@implementation RepoViewController

- (void)setDetail:(Repo *)detail {
    _repo = detail;
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

- (IBAction)unstarRepo:(id)sender {
    NSURLSessionDataTask *task = [self.repo unstarRepo];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

@end
