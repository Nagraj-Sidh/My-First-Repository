//
//  GHCommit.h
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GHCommit : NSObject

// Specifies author of the commit
@property (nonatomic, strong) NSString * author;

// Specifies hash of the commit
@property (nonatomic, strong) NSString * hashIdentifier;

// Specifies commit message
@property (nonatomic, strong) NSString * message;

// Init Method
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
