//
//  MapViewController.h
//  Let's Test
//
//  Created by Alexander Buck on 2/20/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong,nonatomic) PFObject *object;

@property (retain, nonatomic) NSMutableArray *directions;

@end
