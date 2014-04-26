//
//  NewsFeedCell.h
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *EventLabel;
@property (strong, nonatomic) IBOutlet UILabel *DecriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
//@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeStamp;

@end
