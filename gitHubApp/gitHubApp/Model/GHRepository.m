//
//  GHRepository.m
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import "GHRepository.h"

@implementation GHRepository

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.identifier = [dictionary objectForKey:@"id"];
    }
    
    return self;
}

@end
