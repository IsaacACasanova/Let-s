//
//  NewsFeed.h
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewsFeed : PFQueryTableViewController


@property (nonatomic, strong) NSArray *profilePics;
@property (nonatomic, strong) NSArray *eventTitle;
@property (nonatomic, strong) NSArray *eventDescription;
@property (nonatomic,strong) NSArray *eventDate;
//@property (nonatomic,strong) NSArray *timeStamp;


@property NSString *userinfo;
@property(nonatomic, strong) PFObject *person,*event;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *Proback;
@property int state,alloff,prioff;

@property (strong, nonatomic) IBOutlet UIButton *all;
@property (strong, nonatomic) IBOutlet UIButton *pub;
@property (strong, nonatomic) IBOutlet UIButton *pri;





@end
