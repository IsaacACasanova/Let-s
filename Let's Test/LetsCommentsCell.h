//
//  LetCommentsCell.h
//  DynamicComments
//
//  Created by Isaac  Casanova on 3/30/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LetsCommentsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet PFImageView *thumbNailImage;

@end