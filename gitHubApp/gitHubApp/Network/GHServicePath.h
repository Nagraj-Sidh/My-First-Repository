//
//  GHServicePath.h
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, GHBackendService) {
    GHBackendServiceNone = 0,
    GHBackendServiceFetchCommits,
    GHBackendServiceFetchRepositories,
};

/// Returns the absolute path of service passed as input param
NSString * __nullable GHAbsoluteServicePath(GHBackendService service);


