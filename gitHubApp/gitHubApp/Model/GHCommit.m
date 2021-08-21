//
//  GHCommit.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHCommit.h"

@implementation GHCommit

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        // Hash
        self.hashIdentifier = [dictionary objectForKey:@"sha"];
        
        // Commit message
        NSDictionary * commitDictionary  = [dictionary objectForKey:@"commit"];
        self.message = [commitDictionary objectForKey:@"message"];

        // Author name
        NSDictionary * author = [commitDictionary objectForKey:@"author"];
        self.author = [author objectForKey:@"name"];
    }
    
    return self;
}

@end
