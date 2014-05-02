//
//  InitialViewController.m
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>
#import "OLImageView.h"
#import "OLImage.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

@synthesize gif;

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
    
       self.navigationController.navigationBar.hidden = YES;
    
    
    OLImageView *view = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"letsgif.gif"]];
    
    
    [gif addSubview:view];
    
    
    
    [super viewDidLoad];
    
    
    
    
   
    
    // Do any additional setup after loading the view.
}


-(void) viewDidAppear:(BOOL)animated{
    
    PFUser *user = [PFUser currentUser];
    if(user.username != nil){
        [self performSegueWithIdentifier:@"alreadysignedin" sender:self];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
