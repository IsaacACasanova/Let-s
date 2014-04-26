//
//  DirectionsViewController.m
//  Let's Test
//
//  Created by Matt on 4/25/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "DirectionsViewController.h"

@interface DirectionsViewController ()

@end

@implementation DirectionsViewController
@synthesize dirTextView;
@synthesize directions;

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
    //directions = [NSMutableArray arrayWithObjects:nil];
    
    dirTextView.text = [directions firstObject];
    NSLog(@"%@", [directions firstObject]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
