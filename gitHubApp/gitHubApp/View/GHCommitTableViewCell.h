//
//  GHCommitTableViewCell.h
//  gitHubApp
//
//  Created by Nagraj on 8/21/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GHCommitTableViewCell : UITableViewCell

// Holds the reference of author
@property (weak, nonatomic) IBOutlet UILabel * author;

// Holds the reference of commit hash
@property (weak, nonatomic) IBOutlet UILabel * hashIdentifier;

// Holds the reference of commit message
@property (weak, nonatomic) IBOutlet UILabel * message;

@end

NS_ASSUME_NONNULL_END
