//
//  gitHubAppTests.m
//  gitHubAppTests
//
//  Created by Nagraj on 8/21/21.
//

#import <XCTest/XCTest.h>
#import "GHRepository.h"
#import "GHCommit.h"

@interface gitHubAppTests : XCTestCase

@end

@implementation gitHubAppTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (id)JSONForResourceFile:(NSString *)resourceName {
    NSString * fileName = [[NSBundle mainBundle] pathForResource:resourceName
                                                         ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:fileName];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

// Test case to ensure the GHRepository model object is getting initialized and properties are updated correctly with json dictionary
- (void)testGHRepositoryModeInitialization {
    id jsonObject = [self JSONForResourceFile:@"testRepository"];
    NSArray * repositoryList = jsonObject;
    
    XCTAssertTrue(repositoryList.count == 1, "Incorrect repository list count");

    for (NSDictionary * eachRepository in repositoryList) {
        NSString * name = [eachRepository objectForKey:@"name"];
        NSString * identifier = [eachRepository objectForKey:@"id"];

        GHRepository * repository = [[GHRepository alloc] initWithDictionary:eachRepository];
        XCTAssertEqualObjects(repository.name, name, @"Failure: The repository name is not matching, Expected: The repository name is matching");
        XCTAssertEqualObjects(repository.identifier, identifier, @"Failure: The repository id is not matching, Expected: The repository id is matching");
    }
}

// Test case to ensure the GHCommit model object is getting initialized and properties are updated correctly with json dictionary
- (void)testGHCommitModeInitialization {
    id jsonObject = [self JSONForResourceFile:@"testCommits"];
    NSArray * commitList = jsonObject;
    
    XCTAssertTrue(commitList.count == 3, "Incorrect commit list count");

    for (NSDictionary * eachCommitDictionary in commitList) {
        NSString * commitHash = [eachCommitDictionary objectForKey:@"sha"];
        NSString * commitMessage = [[eachCommitDictionary objectForKey:@"commit"] objectForKey:@"message"];
        NSString * commitAuthor = [[[eachCommitDictionary objectForKey:@"commit"] objectForKey:@"author"] objectForKey:@"name"];
        GHCommit * commit = [[GHCommit alloc] initWithDictionary:eachCommitDictionary];
        XCTAssertEqualObjects(commit.hashIdentifier, commitHash, @"Failure: The commit hash is not matching, Expected: The commit hash is matching");
        XCTAssertEqualObjects(commit.author, commitAuthor, @"Failure: The commit author is not matching, Expected: The commit author is matching");
        XCTAssertEqualObjects(commit.message, commitMessage, @"Failure: The commit message is not matching, Expected: The commit message is matching");
    }
}

@end
