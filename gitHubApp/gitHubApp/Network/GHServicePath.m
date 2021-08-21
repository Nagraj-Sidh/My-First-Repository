//
//  GHServicePath.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHServicePath.h"

@implementation GHServicePath

NSString * GHAbsoluteServicePath(GHBackendService service) {
    
    switch (service) {
        case GHBackendServiceFetchCommits: {
            return [NSString stringWithFormat:@"https://api.github.com/repos/Nagraj-Sidh/%@/commits?page=%s&per_page=%s", @"%@","%@","%@"];
        }
        case GHBackendServiceFetchRepositories: {
            return [NSString stringWithFormat:@"https://api.github.com/users/Nagraj-Sidh/repos"];
        }
        case GHBackendServiceNone:
            return nil;
    }
}

@end
