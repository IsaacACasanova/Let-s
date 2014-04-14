//
//  EventViewController.m
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "EventViewController.h"
#import "LetsCommentsTableViewController.h"
#import "MapViewController.h"

@interface EventViewController ()


@end

@implementation EventViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _profilePicture.image = [UIImage imageNamed:_DetailModal[0]];
    _eventTitle.text = _DetailModal[1];
    _eventDate.text = _DetailModal[2];
    _eventDescription.text = _DetailModal[3];
    _timeStamp.text = _DetailModal[4];
    
    
    UIColor* mainColor = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    UIColor* mainColorLight = [UIColor colorWithRed:28.0/255 green:158.0/255 blue:121.0/255 alpha:0.4f];
    //UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    self.eventTitle.textColor =  mainColor;
    self.eventTitle.font =  [UIFont fontWithName:boldFontName size:18.0f];
    
    self.eventDate.textColor = neutralColor;
    self.eventDate.font =  [UIFont fontWithName:boldFontName size:18.0f];
    
    self.eventDescription.textColor = neutralColor;
    self.eventDescription.font = [UIFont fontWithName:fontName size:18.0f];
    
    self.timeStamp.textColor = mainColorLight;
    self.timeStamp.font =  [UIFont fontWithName:boldItalicFontName size:10.0f];
    
   // self.commentLabel.textColor = mainColorLight;
   // self.commentLabel.font =  [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 40.0f;
    self.profilePicture.layer.borderWidth = 2.0f;
    self.profilePicture.layer.borderColor = mainColorLight.CGColor;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Comments"]){
        
        LetsCommentsTableViewController *commentsViewController = [segue destinationViewController];
        

        commentsViewController.object = self.object;
    }
     if([[segue identifier] isEqualToString:@"Map"]){
         MapViewController *mapControll = [segue destinationViewController];
         
         mapControll.object = self.object;
         
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindToTableViewController:(UIStoryboardSegue *)sender
{
    LetsCommentsTableViewController *letsCommentsTableViewController = (LetsCommentsTableViewController *)sender.sourceViewController;
}


@end
