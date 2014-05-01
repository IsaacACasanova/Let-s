//
//  MapViewController.m
//  Let's Test
//
//  Created by Alexander Buck on 2/20/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotationView.h"
#include <stdlib.h>

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize locationManager;
@synthesize mapView;
@synthesize profileMapImage;

MKRoute *currentRoute;
MKPolyline *routeOverlay;
NSString *daddr;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    
    mapView.delegate = self;
    locationManager.delegate = self;
    
    [self getEventLocation];
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
            NSLog(@"%@", objects[0]);
            
            PFObject *object = objects[0];
            [query getObjectInBackgroundWithId:object.objectId block:^(PFObject *want, NSError *err) {
                NSLog(@"WANT: %@", want[@"Address"]);
                
                daddr = want[@"Address"];
                
                NSString *eventName = want[@"EventName"];
                PFGeoPoint *eventAddress = want[@"Coordinates"];
                
                CLLocationCoordinate2D pincoordinate;
                
                pincoordinate.latitude  = eventAddress.latitude;
                pincoordinate.longitude = eventAddress.longitude;
                
                // Set the region to display and have it zoom in
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(pincoordinate, 800, 800);
                [self.mapView setRegion:[self.mapView regionThatFits:region] animated: NO];
                
                // Add annotation
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = pincoordinate;
                point.title      = eventName;
                point.subtitle   = want[@"Address"];
                
                [self.mapView addAnnotation:point];
                [self.mapView selectAnnotation:point animated:YES];
            }];
        }
    }];
}

- (MKPinAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    NSString *annotationIdentifier = @"CustomViewAnnotation";
    
    CustomAnnotationView *customAnnotationView = (CustomAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!customAnnotationView) {
        customAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        customAnnotationView.canShowCallout = YES;
    }
    
    
    CGRect nframe = self.profileMapImage.frame;
    nframe.size.width = (self.profileMapImage.frame.size.width)/2.5;
    nframe.size.height = (self.profileMapImage.frame.size.height/2.5);
    self.profileMapImage.frame = nframe;
    
    self.profileMapImage.layer.cornerRadius = 17;
    
   // self.profileMapImage.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    customAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    customAnnotationView.rightCalloutAccessoryView.tintColor = mainColor;
    customAnnotationView.leftCalloutAccessoryView = self.profileMapImage;
    
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
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(37.7916, -122.4276);
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
    
    
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/?daddr=%@", daddr];
    NSString *escaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
    
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    if(routeOverlay) {
        [self.mapView removeOverlay:routeOverlay];
    }
    
    // Update the ivar
    routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:routeOverlay];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (IBAction)changeMapType:(id)sender {
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeHybrid;
    else
        mapView.mapType = MKMapTypeStandard;
}
@end
