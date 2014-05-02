//
//  EventViewController.h
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface EventViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
//@property (strong, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;

@property (strong, nonatomic) IBOutlet UILabel *timeStamp;
@property (strong, nonatomic) IBOutlet UILabel *eventDate;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) PFObject *object;
@property (strong, nonatomic) PFObject *creator;
@property (weak, nonatomic) IBOutlet MKMapView *miniMap;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIButton *Edit;
@property (strong, nonatomic) IBOutlet UIButton *LetsButton;
@property (strong, nonatomic) IBOutlet UIButton *PassButton;
@property (strong, nonatomic) IBOutlet UIButton *DeleteButton;
@property (strong,nonatomic) NSArray *DetailModal;


- (IBAction)LetsPressed:(id)sender;
- (IBAction)PassPressed:(id)sender;

- (IBAction)DeletePressed:(id)sender;


@end

