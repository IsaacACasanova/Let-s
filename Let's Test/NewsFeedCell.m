//
//  NewsFeedCell.m
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)awakeFromNib{
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    UIColor* mainColorLight = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:0.4f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    self.EventLabel.textColor =  mainColor;
    self.EventLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.dateLabel.textColor = neutralColor;
    self.dateLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    
    self.DecriptionLabel.textColor = neutralColor;
    self.DecriptionLabel.font = [UIFont fontWithName:fontName size:14.0f];
    
    self.timeStamp.textColor = mainColorLight;
    self.timeStamp.font =  [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    //self.commentLabel.textColor = mainColorLight;
    //self.commentLabel.font =  [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    self.ProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.ProfileImage.clipsToBounds = YES;
    self.ProfileImage.layer.cornerRadius = 25.0f;
    self.ProfileImage.layer.borderWidth = 2.0f;
    self.ProfileImage.layer.borderColor = mainColorLight.CGColor;
    
    //self.updateLabel.textColor =  neutralColor;
   // self.updateLabel.font =  [UIFont fontWithName:fontName size:12.0f];
    
    
    //self.likeCountLabel.textColor = mainColorLight;
    //self.likeCountLabel.font =  [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    /*self.ProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.ProfileImage.clipsToBounds = YES;
    self.ProfileImage.layer.cornerRadius = 2.0f;*/
    
    /*self.picImageContainer.backgroundColor = [UIColor whiteColor];
    self.picImageContainer.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.6f].CGColor;
    self.picImageContainer.layer.borderWidth = 1.0f;
    self.picImageContainer.layer.cornerRadius = 2.0f;
    
    
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 20.0f;
    self.profileImageView.layer.borderWidth = 2.0f;
    self.profileImageView.layer.borderColor = mainColorLight.CGColor;
    
     */
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)LetsPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Pass"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:self.event];
    if(findifIntable.getFirstObject!=NULL){
        [findifIntable.getFirstObject deleteInBackground];
    }
    PFObject *attend = [PFObject objectWithClassName:@"Attending"];
    attend[@"Attendee"]=[PFUser currentUser];
    attend[@"Event"]= self.event;
    [attend save];
    self.LetsButton.Enabled = NO;
    self.PassButton.enabled = YES;
}

- (IBAction)PassPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Attending"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:self.event];
    if(findifIntable.getFirstObject!=NULL){
        [findifIntable.getFirstObject deleteInBackground];
    }
    PFObject *pass = [PFObject objectWithClassName:@"Pass"];
    pass[@"Attendee"]=[PFUser currentUser];
    pass[@"Event"]= self.event;
    [pass save];
    
    self.LetsButton.Enabled = YES;
    self.PassButton.enabled =NO;
}

- (IBAction)EditPressed:(id)sender {
}

- (IBAction)DeletePressed:(id)sender {
    PFQuery *attend = [PFQuery queryWithClassName:@"Attending"];
    [attend whereKey:@"Event" equalTo:self.event];
    [attend getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            [object deleteInBackground];
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    PFQuery *pass = [PFQuery queryWithClassName:@"Attending"];
    [pass whereKey:@"Event" equalTo:self.event];
    [pass getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            [object deleteInBackground];
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    PFQuery *comments = [PFQuery queryWithClassName:@"LetsComments"];
    [comments whereKey:@"EventID" equalTo:self.event.objectId];
    [comments getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            [object deleteInBackground];
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    [self.event deleteInBackground];
}




@end
