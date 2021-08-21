//
//  GHServiceManager.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHServiceManager.h"
#import "GHRepository.h"
#import "GHServicePath.h"
#import "GHCommit.h"

@implementation GHServiceManager

#pragma mark  Fetch repositories

- (void)fetchRepositoryWithCompletionBlock:(void(^)(NSArray * results, NSError * error))completionBlock {
    NSString * urlString = [NSString stringWithFormat:@"%@", GHAbsoluteServicePath(GHBackendServiceFetchRepositories)];
    
    NSURL * dataURL = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:dataURL];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id jsonData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            NSArray <GHRepository *>* results = nil;
            __block NSError * errorObject = nil;

            if (error) {
                errorObject = error;
            }
            else {
                if ([jsonData isKindOfClass:[NSArray class]]) {
                    results = [self repositoryFromJson:jsonData];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock (results, error);
                }
            });
        });
    }];
    
    [dataTask resume];
}

#pragma mark  Retrieve commits

- (void)retrieveCommitsForRepository:(NSString *)repositoryName page:(NSNumber *)page perPage:(NSNumber *)perPage withCompletionBlock:(void(^)(NSArray * results, NSError * error))completionBlock {
    NSString * urlString = [NSString stringWithFormat:GHAbsoluteServicePath(GHBackendServiceFetchCommits),repositoryName, page, perPage];

    NSURL * dataURL = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:dataURL];
    NSURLSession * urlSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id jsonData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            
            NSArray <GHCommit *>* commits = nil;
            __block NSError * errorObject = nil;

            if (error) {
                errorObject = error;
            }
            else {
                if ([jsonData isKindOfClass:[NSArray class]]) {
                    commits = [self commitsFromJson:jsonData];
                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock (commits, error);
                }
            });
        });
    }];
    
    [dataTask resume];
}

#pragma mark  Model methods

- (NSArray <GHRepository *>*)repositoryFromJson:(NSArray *)jsonData {
    NSMutableArray * repositoryList = [NSMutableArray array];
    
    for (NSDictionary * eachRepository in jsonData) {
        GHRepository * repository = [[GHRepository alloc] initWithDictionary:eachRepository];
        [repositoryList addObject:repository];
    }
    
    return [repositoryList copy];
}

- (NSArray <GHCommit *>*)commitsFromJson:(NSArray *)jsonData {
    NSMutableArray * commitList = [NSMutableArray array];
    
        for (NSDictionary * eachCommit in jsonData) {
            GHCommit * commit = [[GHCommit alloc] initWithDictionary:eachCommit];
            [commitList addObject:commit];
        }
    
    return [commitList copy];
}

@end
