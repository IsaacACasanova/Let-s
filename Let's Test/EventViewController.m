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
    NSLog(@"me: %@ you: %@ them:%@",self.creator,user,self.object);
    if([self.creator.objectId isEqualToString: user.objectId]){
        NSLog(@"WHATTTTTTT");
        _Edit.hidden=NO;
        _LetsButton.hidden = YES;
        _PassButton.hidden = YES;
    }
    else{
        _Edit.hidden = YES;
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
            // NSLog(@"%@", objects[0]);
            
            PFObject *object = objects[0];
            [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *want, NSError *err) {
                NSLog(@"WANT: %@", want[@"Address"]);
                
                //destAddress = want[@"Address"];
                
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
                //[self.miniMap selectAnnotation:point animated:YES];
            }];
        }
    }];
}

- (MKPinAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    
    CustomAnnotationView *customAnnotationView = (CustomAnnotationView *) [self.miniMap dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!customAnnotationView) {
        customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier /*annotationViewImage:[UIImage imageNamed:@"maifi.png"]*/];
        
        customAnnotationView.canShowCallout = YES;
    }
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jack.jpg"]];
    //    imageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
    //
    //    customAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    customAnnotationView.leftCalloutAccessoryView = imageView;
    
    return customAnnotationView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    
    directionsRequest.requestsAlternateRoutes = YES;
    
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
    CLLocationCoordinate2D destinationCoords = pincoordinate;//CLLocationCoordinate2DMake(37.7916, -122.4276);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:currentRoute];
    }];
    
    
    //    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%@&daddr=%@", sourceAddress,destAddress];
    //    NSString *escaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    if(routeOverlay) {
        [self.miniMap removeOverlay:routeOverlay];
    }
    
    // Update the ivar
    routeOverlay = route.polyline;
    
    // Add it to the map
    [self.miniMap addOverlay:routeOverlay];
    
    //    NSInteger i = 0;
    //    for (MKRouteStep *step in route.steps)
    //    {
    //        [directions insertObject:step.instructions atIndex:i];
    //        NSLog(@"%@", directions);
    //        i++;
    //    }
    //    [self performSegueWithIdentifier:@"Directions" sender:self];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
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

- (IBAction)EditPressed:(id)sender {
}

- (IBAction)DeletePressed:(id)sender {
}

- (IBAction)DeletePressed:(id)sender {
}

@end
