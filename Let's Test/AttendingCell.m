//
//  AttendingCell.m
//  Let's Test
//
//  Created by Yamiel Zea on 4/26/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "AttendingCell.h"

@implementation AttendingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    UIColor* mainColorLight = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:0.4f];


    NSString* boldFontName = @"Avenir-Black";
    
    self.NameLabel.textColor =  mainColor;
    self.NameLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.ProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.ProfileImage.clipsToBounds = YES;
    self.ProfileImage.layer.cornerRadius = 25.0f;
    self.ProfileImage.layer.borderWidth = 2.0f;
    self.ProfileImage.layer.borderColor = mainColorLight.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
