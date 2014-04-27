//
//  FriendsListCell.m
//  Let's Test
//
//  Created by Jack Gallagher on 4/15/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "FriendsListCell.h"

@implementation FriendsListCell

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
    //UIColor* mainColor = [UIColor colorWithRed:0.0/255 green:87.0/255 blue:255.0/255 alpha:1.0f];
    //UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    //UIColor* mainColorLight = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    //UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    //NSString* fontName = @"Avenir-Book";
    //NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    self.NameLabel.textColor =  mainColor;
    self.NameLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
