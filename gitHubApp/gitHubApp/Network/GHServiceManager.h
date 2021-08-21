//
//  GHServiceManager.h
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GHServiceManager : NSObject

// Fetch all the repositories
- (void)fetchRepositoryWithCompletionBlock:(void(^)(NSArray * results, NSError * error))completionBlock;

// Fetch most recent commits(25) in a repsitory
- (void)fetchCommitsForRepository:(NSString *)repositoryName page:(NSNumber *)page perPage:(NSNumber *)perPage withCompletionBlock:(void(^)(NSArray * results, NSError * error))completionBlock;

@end

NS_ASSUME_NONNULL_END
