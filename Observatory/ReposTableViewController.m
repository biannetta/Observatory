//
//  ReposTableViewController.m
//  Observatory
//
//  Created by Benjamin Iannetta on 2015-03-19.
//  Copyright (c) 2015 biannetta. All rights reserved.
//

#import "ReposTableViewController.h"
#import "RepoViewController.h"

#import "Repo.h"

#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define REQUEST_PER_PAGE 50

@interface ReposTableViewController ()
@property (readwrite, nonatomic, strong) NSMutableArray *repos;
@property (readwrite, nonatomic, strong) NSNumber *pageRequest;
@property (readwrite, nonatomic, strong) NSNumber *latestRequestSize;
@end

@implementation ReposTableViewController

- (void)reload:(id)sender {
    self.pageRequest = @1;
    
    NSDictionary *parameters = @{@"page" : self.pageRequest, @"per_page" : @REQUEST_PER_PAGE};
    
    NSURLSessionDataTask *task = [Repo starredReposWithParameters:parameters andBlock:^(NSArray *repos, NSError *error) {
        if (!error) {
            self.latestRequestSize = [[NSNumber alloc] initWithUnsignedLong:[repos count]];
            self.repos = [[NSMutableArray alloc] initWithArray:repos];
            int value = [self.pageRequest intValue];
            self.pageRequest = [[NSNumber alloc] initWithInt:value+1];
            [self.tableView reloadData];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

- (void)loadMoreData {
    // If the lastest request was less than the request size, no more data to retrieve
    if ([self.latestRequestSize intValue] < REQUEST_PER_PAGE) {
        NSLog(@"No More Data");
        return;
    }
    
    NSDictionary *parameters = @{@"page" : self.pageRequest, @"per_page" : @REQUEST_PER_PAGE};
    
    NSURLSessionDataTask *task = [Repo starredReposWithParameters:parameters andBlock:^(NSArray *repos, NSError *error) {
        if (!error && [repos count] != 0) {
            NSMutableArray *newRepos = [NSMutableArray arrayWithArray:self.repos];
            for (int i = 0; i < [repos count]; i ++) {
                [newRepos addObject:repos[i]];
            }
            self.repos = newRepos;
            self.latestRequestSize = [[NSNumber alloc] initWithUnsignedLong:[repos count]];
            int value = [self.pageRequest intValue];
            self.pageRequest = [[NSNumber alloc] initWithInt:value+1];
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

#pragma mark - UITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Starred Repos", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Repo *repo = self.repos[path.row];
    
    if ([[segue identifier] isEqualToString:@"repo_detail"]) {
        RepoViewController *vc = [segue destinationViewController];
        [vc setDetail:repo];
        [vc onDeletion:^{
            [self.repos removeObjectAtIndex:path.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView reloadData];
        }];
    }
}

// TODO: maybe reimplement inrow deletion
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.repos removeObjectAtIndex:(NSUInteger)indexPath.row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView reloadData];
//}

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
