//
//  DirectionsViewController.h
//  Let's Test
//
//  Created by Matt on 4/25/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *dirTextView;
@property (retain, nonatomic) NSMutableArray *directions;

@end
