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
#import "CustomAnnotationView.h"

@interface EventViewController ()


@end

@implementation EventViewController
@synthesize locationManager;
@synthesize miniMap;

MKRoute *currentRoute;
MKPolyline *routeOverlay;
CLLocationCoordinate2D pincoordinate;


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
    
    _profilePicture.image = _DetailModal[0];
    _eventTitle.text = _DetailModal[1];
    _eventDate.text = _DetailModal[2];
    _eventDescription.text = _DetailModal[3];
    _timeStamp.text = _DetailModal[4];
    
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    UIColor* mainColorLight = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:0.4f];
    
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
    
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 40.0f;
    self.profilePicture.layer.borderWidth = 2.0f;
    self.profilePicture.layer.borderColor = mainColorLight.CGColor;
    
    // Mini map stuff
    locationManager = [[CLLocationManager alloc] init];
    miniMap.delegate = self;
    locationManager.delegate = self;
    
    [self getEventLocation];
    
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

@end
