//
//  GHServicePath.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHServicePath.h"

NSString * GHAbsoluteServicePath(GHBackendService service) {
    
    switch (service) {
        case GHBackendServiceFetchCommits: {
            return nil;
        }
        case GHBackendServiceFetchRepositories: {
            return [NSString stringWithFormat:@"https://api.github.com/users/Nagraj-Sidh/repos"];
        }
        case GHBackendServiceNone:
            return nil;
    }
}
