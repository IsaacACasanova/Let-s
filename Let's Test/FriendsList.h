//
//  FriendsList.h
//  Let's Test
//
//  Created by Jack Gallagher on 4/15/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsList : PFQueryTableViewController
//@property (strong, nonatomic) PFObject *object;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property int follower;
@property int showBars;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property bool *isFiltered;
@property (nonatomic,strong) NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *usernamesearchbar;
@property (weak, nonatomic) IBOutlet UIView *SearchView;

@end
