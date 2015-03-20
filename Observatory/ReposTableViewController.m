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
    
    return cell;
}
@end
