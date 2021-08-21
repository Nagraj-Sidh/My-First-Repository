//
//  GHCommitListTableViewController.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHCommitListTableViewController.h"
#import "GHCommit.h"
#import "GHServiceManager.h"
#import "GHCommitTableViewCell.h"

#define kDefaultNumberOfSections        0
#define kDefaultPerPageCount            25

@interface GHCommitListTableViewController ()

// Holds list of all the commits
@property (nonatomic, strong) NSArray <GHCommit *> * commits;

// Holds the reference of service manager
@property (nonatomic, strong) GHServiceManager * serviceManager;

// Returns activityViewIndicator instance
@property (nonatomic, strong) UIActivityIndicatorView * activityViewIndicator;

// Holds the boolen value to determine if fetching of commit list is in progress
@property (nonatomic, assign) BOOL fetchingCommitList;

@end

@implementation GHCommitListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serviceManager = [[GHServiceManager alloc] init];
    [self setUpNavigationBar];
    [self setUpActivityIndicator];
    [self fetchCommitList];
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = kDefaultNumberOfSections;
    
    if ([self.commits count] > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numberOfSections = self.commits.count;
        self.tableView.backgroundView = nil;
    }
    else {
        
        // Display no results if no commits are made to the repository
        if (!self.fetchingCommitList) {
            UILabel * noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
            noDataLabel.text = @"No results";
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            self.tableView.backgroundView = noDataLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"cell";
    GHCommitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[GHCommitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    GHCommit * eachCommit = [self.commits objectAtIndex:indexPath.section];
    cell.author.text = eachCommit.author;
    cell.hashIdentifier.text = eachCommit.hashIdentifier;
    cell.message.text = eachCommit.message;
    
    return cell;
}

#pragma mark -

- (void)setUpNavigationBar {
    self.navigationItem.title = @"Commits";
}

- (void)setUpActivityIndicator {
    self.activityViewIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityViewIndicator.center = self.view.center;
    self.activityViewIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:self.activityViewIndicator];
}

- (void)fetchCommitList {
    [self.activityViewIndicator startAnimating];
    self.fetchingCommitList = YES;
    __weak GHCommitListTableViewController * weakSelf = self;
    
    // Fetch the most recent commits to the repository
    [self.serviceManager fetchCommitsForRepository:self.repositoryName page:@1 perPage:@kDefaultPerPageCount withCompletionBlock:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        __strong GHCommitListTableViewController * strongSelf = weakSelf;
        [strongSelf.activityViewIndicator stopAnimating];
        strongSelf.fetchingCommitList = NO;
        
        if (error) {
            if ([results count] > 0) {
                strongSelf.commits = results;
            }
        }
        
        [strongSelf.tableView reloadData];
    }];
}

@end
