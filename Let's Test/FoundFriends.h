//
//  FoundFriends.h
//  Let's Test
//
//  Created by Yamiel Zea on 5/2/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <Parse/Parse.h>

@interface FoundFriends : PFQueryTableViewController

@property NSString *user;
@property int on;
@property (strong, nonatomic) IBOutlet UITextField *searchbar;

- (IBAction)searchPressed:(id)sender;
@end
