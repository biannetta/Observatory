//
//  ReposTableViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "ReposTableViewController.h"

#import "Repo.h"

#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ReposTableViewController ()
@property (readwrite, nonatomic, strong) NSArray *repos;
@end

@implementation ReposTableViewController

- (void)reload:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSURLSessionDataTask *task = [Repo starredReposWithBlock:^(NSArray *repos, NSError *error) {
        if (!error) {
            self.repos = repos;
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

- (void)loadMoreData {
    NSURLSessionDataTask *task = [Repo starredReposWithBlock:^(NSArray *repos, NSError *error) {
        if (!error) {
            NSMutableArray *newRepos = [NSMutableArray arrayWithArray:self.repos];
            for (int i = 0; i < [repos count]; i ++) {
                [newRepos addObject:repos[i]];
            }
            self.repos = newRepos;
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Starred Repos", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"repoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Repo *repo = [self.repos objectAtIndex:(NSUInteger)indexPath.row];
    
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.language;
    [cell.imageView setImageWithURL:[NSURL URLWithString:repo.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if (indexPath.row == [self.repos count] - 1) {
        NSLog(@"Load more data");
        [self loadMoreData];
    }
    
    return cell;
}
@end
