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
#import "AttendingController.h"
#import "ProfileController3.h"
#import "CreateEvent.h"


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
    
    
    PFUser *user = [PFUser currentUser];
    if([self.creator.objectId isEqualToString: user.objectId]){
        NSLog(@"WHATTTTTTT");
        _LetsButton.hidden = YES;
        _PassButton.hidden = YES;
    }
    else{
        _Edit.hidden = YES;
        _DeleteButton.hidden = YES;
    }
    
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Attending"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:self.object];
    if(findifIntable.getFirstObject!=NULL){
        _LetsButton.enabled = NO;
    }
    
    PFQuery *findifIntable2 = [PFQuery queryWithClassName:@"Pass"];
    [findifIntable2 whereKey:@"Attendee" equalTo:user];
    [findifIntable2 whereKey:@"Event" equalTo:self.object];
    if(findifIntable2.getFirstObject!=NULL){
        _PassButton.enabled = NO;
    }
    
    //Mini map stuff
    locationManager = [[CLLocationManager alloc] init];
    miniMap.delegate = self;
    locationManager.delegate = self;
    
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
    
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 40.0f;
    self.profilePicture.layer.borderWidth = 2.0f;
    self.profilePicture.layer.borderColor = mainColorLight.CGColor;
    
    // More mini map stuff
    [self getEventLocation];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Comments"]){
        
        LetsCommentsTableViewController *commentsViewController = [segue destinationViewController];
        commentsViewController.object = self.object;
    }
    if([[segue identifier] isEqualToString:@"Map"]){
        MapViewController *mapControll = [segue destinationViewController];
        //mapControll.profileMapImage.image =  self.profilePicture.image;
        
        mapControll.profileMapImage = self.profilePicture;
        
        mapControll.object = self.object;
        
    }
    if([[segue identifier] isEqualToString:@"Attending"]){
        AttendingController *attend = [segue destinationViewController];
        attend.event = self.object;
    }
    if([[segue identifier] isEqualToString:@"ProButton"]){
        ProfileController3 *vc = [segue destinationViewController];
        NSString *username = [self.creator objectForKey:@"username"];
        [vc grabOtherUserInfo:username];
        
    }
    if([[segue identifier] isEqualToString:@"Edit"]){
        CreateEvent *vc =  [segue destinationViewController];
        vc.event = self.object;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getEventLocation {
    
    // Create a Parse query
    PFQuery *query = [PFQuery queryWithClassName:@"EventList"];
    [query whereKey:@"objectId" equalTo:self.object.objectId];
    
    // Run the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            PFObject *object = objects[0];
            [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *want, NSError *err) {
                NSLog(@"WANT: %@", want[@"Address"]);
                
                NSString *eventName = want[@"EventName"];
                PFGeoPoint *eventAddress = want[@"Coordinates"];
                
                pincoordinate.latitude  = eventAddress.latitude;
                pincoordinate.longitude = eventAddress.longitude;
                
                // Set the region to display and have it zoom in
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pincoordinate, 800, 800);
                [self.miniMap setRegion:[self.miniMap regionThatFits:region] animated: YES];
                
                // Add annotation
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = pincoordinate;
                point.title      = eventName;
                point.subtitle   = want[@"Address"];
                
                [self.miniMap addAnnotation:point];
            }];
        }
    }];
}

- (MKPinAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    
    CustomAnnotationView *customAnnotationView = (CustomAnnotationView *) [self.miniMap dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!customAnnotationView) {
        customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        customAnnotationView.canShowCallout = YES;
    }
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jack.jpg"]];
    //    imageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
    //
    //    customAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    customAnnotationView.leftCalloutAccessoryView = imageView;
    
    return customAnnotationView;
    
}

- (IBAction)LetsPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Pass"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:self.object];
    if(findifIntable.getFirstObject!=NULL){
        [findifIntable.getFirstObject deleteInBackground];
    }
    PFObject *attend = [PFObject objectWithClassName:@"Attending"];
    attend[@"Attendee"]=[PFUser currentUser];
    attend[@"Event"]= self.object;
    [attend save];
    self.LetsButton.Enabled = NO;
    /* self.LetsButton.imageView.image = */
    self.PassButton.enabled = YES;
}

- (IBAction)PassPressed:(id)sender {
    PFUser *user = [PFUser currentUser];
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Attending"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:self.object];
    if(findifIntable.getFirstObject!=NULL){
        [findifIntable.getFirstObject deleteInBackground];
    }
    PFObject *pass = [PFObject objectWithClassName:@"Pass"];
    pass[@"Attendee"]=[PFUser currentUser];
    pass[@"Event"]= self.object;
    [pass save];
    
    self.LetsButton.Enabled = YES;
    self.PassButton.enabled =NO;
}


- (IBAction)DeletePressed:(id)sender {
    NSLog(@"%@",self.object);
    
    PFQuery *attend = [PFQuery queryWithClassName:@"Attending"];
    [attend whereKey:@"Event" equalTo:self.object.objectId];
    [attend getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            [object deleteInBackground];
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    PFQuery *pass = [PFQuery queryWithClassName:@"Pass"];
    [pass whereKey:@"Event" equalTo:self.object.objectId];
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
    [comments whereKey:@"EventID" equalTo:self.object.objectId];
    [comments getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            [object deleteInBackground];
            NSLog(@"Successfully retrieved the object.");
        }
    }];
    
    [self.object deleteInBackground];
}

@end
