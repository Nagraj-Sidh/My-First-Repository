//
//  GHRepository.h
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GHRepository : NSObject

/// Specifies id of the repository
@property (nonatomic, strong) NSString * identifier;

/// Specifies name of the repository
@property (nonatomic, strong) NSString * name;

/// Init Method
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
