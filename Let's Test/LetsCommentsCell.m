//
//  LetCommentsCell.m
//  DynamicComments
//
//  Created by Isaac  Casanova on 3/30/14.
//
//

#import "LetsCommentsCell.h"

@implementation LetsCommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    //UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    UIColor* commentColor = [UIColor colorWithRed:45.0/255 green: 0.0/255 blue:30.0/255 alpha:1.0f];
    
    UIColor* mainColorLight = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    //UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    
    self.userName.textColor = mainColor;
    self.userName.font = [UIFont fontWithName:boldFontName size:14.0f];
    
    self.time.textColor = mainColorLight;
    self.time.font = [UIFont fontWithName:boldItalicFontName size:12.0f];
    
    self.comment.textColor = commentColor;
    self.comment.font = [UIFont fontWithName:fontName size:14.0f];
    
    self.thumbNailImage.clipsToBounds = YES;
    self.thumbNailImage.layer.cornerRadius = 25.0f;
    self.thumbNailImage.layer.borderWidth = 2.0f;
    self.thumbNailImage.layer.borderColor = mainColorLight.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end