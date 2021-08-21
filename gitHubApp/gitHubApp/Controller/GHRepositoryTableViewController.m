//
//  GHRepositoryTableViewController.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHRepositoryTableViewController.h"
#import "GHCommitListTableViewController.h"
#import "GHRepository.h"
#import "GHServiceManager.h"

#define kDefaultNumberOfSections 0
#define kDefaultNumberOfRows     1

@interface GHRepositoryTableViewController ()

// Holds list of all repositories
@property (nonatomic, strong) NSArray <GHRepository *> * repositories;

// Holds the reference of service manager
@property (nonatomic, strong) GHServiceManager * serviceManager;

// Returns activityViewIndicator instance
@property (nonatomic, strong) UIActivityIndicatorView * activityViewIndicator;

// Holds the boolen value to determine if fetching of repository list is in progress
@property (nonatomic, assign) BOOL fetchingRepositories;

@end

@implementation GHRepositoryTableViewController

#pragma mark - Designated Initializer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serviceManager = [[GHServiceManager alloc] init];
    [self setUpNavigationBar];
    [self setUpActivityIndicator];
    [self fetchRepositoryList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = kDefaultNumberOfSections;
    
    if ([self.repositories count] > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numberOfSections = self.repositories.count;
        self.tableView.backgroundView = nil;
    }
    else {
        
        if (!self.fetchingRepositories) {
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
    return kDefaultNumberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GHRepository * eachRepository = [self.repositories objectAtIndex:section];
    return eachRepository.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"reuseCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Recent commits";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GHRepository * eachRepository = [self.repositories objectAtIndex:indexPath.section];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GHCommitListTableViewController * commitListTableViewController = (GHCommitListTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"commitListControllerSegue"];
    commitListTableViewController.repositoryName = eachRepository.name;
    [self.navigationController pushViewController:commitListTableViewController animated:YES];
}

#pragma mark - Custom methods

- (void)setUpNavigationBar {
    self.navigationItem.title = @"Repositories";
}

- (void)setUpActivityIndicator {
    self.activityViewIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityViewIndicator.center = self.view.center;
    self.activityViewIndicator.hidesWhenStopped = YES;
    [self.tableView addSubview:self.activityViewIndicator];
}

- (void)fetchRepositoryList {
    [self.activityViewIndicator startAnimating];
    self.fetchingRepositories = YES;
    __weak GHRepositoryTableViewController * weakSelf = self;
    
    [self.serviceManager fetchRepositoryWithCompletionBlock:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        __strong GHRepositoryTableViewController * strongSelf = weakSelf;
        [strongSelf.activityViewIndicator stopAnimating];
        strongSelf.fetchingRepositories = NO;
        
        if (error) {
            [strongSelf displayError:error];
        }
        else {
            if ([results count] > 0) {
                strongSelf.repositories = results;
            }
        }
        
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Alert

- (void)displayError:(NSError *)error {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                    message:error.localizedDescription
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
