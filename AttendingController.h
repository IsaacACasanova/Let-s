//
//  AttendingController.h
//  Let's Test
//
//  Created by Yamiel Zea on 4/26/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AttendingController : PFQueryTableViewController

@property (nonatomic,strong) PFObject *event;
@end
