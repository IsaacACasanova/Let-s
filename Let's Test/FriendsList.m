//
//  FriendsList.m
//  Let's Test
//
//  Created by Jack Gallagher on 4/15/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "FriendsList.h"
#import "FriendsListCell.h"
#import "ProfileController3.h"
#import <Parse/Parse.h>

@interface FriendsList ()


@end

@implementation FriendsList
@synthesize filteredTableData;
@synthesize allTableData;
@synthesize isFiltered;
@synthesize follower;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Follow";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        
    }
    return self;
}


- (PFQuery *)queryForTable {
    
    
//    PFUser *current = [PFUser currentUser];
//    NSString *username = current[@"username"];
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    PFQuery *query2 = [PFUser query];
    [query2 whereKey:@"username" equalTo:self.username];
    PFQuery *userQuery = [PFUser query];
    if(follower==1){
    [query whereKey:@"Follower" matchesKey:@"username" inQuery:query2];
    [userQuery whereKey:@"username" matchesKey:@"Following" inQuery:query];
    }
    else if(follower==2){
        [query whereKey:@"Following" matchesKey:@"username" inQuery:query2];
        [userQuery whereKey:@"username" matchesKey:@"Follower" inQuery:query];
    }
    
    
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return userQuery;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"FriendsListCell";
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if(cell == nil){
        cell = [[FriendsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.NameLabel.text = [object objectForKey:@"name"];
    cell.UsernameLabel.text = [object objectForKey:@"username"];
    //cell.ProfileImage.image = [UIImage imageNamed:@"profile-1.jpg"];
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            //Set the user's profile picture
            cell.ProfileImage.image = [UIImage imageWithData:imageData];
        }}];
    
    
    
    
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    NSString *searchingForThisUsername = searchBar.text;
    NSLog(@"%@", searchingForThisUsername);
    
    
    // DO what ever you want
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowAFriend"]){
        
        //ProfileController3 *ProfileController = [segue destinationViewController];
        ProfileController3 *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSString *username = object[@"username"];
        NSLog(@"%@",username);
        
        
//        PFObject *obd = [object objectForKey:@"Following"];
//        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//        NSLog(@"%@",obd);
//        [query whereKey:@"objectId" equalTo:obd.objectId];
//        PFObject *userobj = query.getFirstObject;
//        NSString *username = [userobj objectForKey:@"username"];
//        NSLog(@"%@",username);
        //[ProfileController grabOtherUserInfo:username];
        [vc grabOtherUserInfo:username];
       
    }
    if([[segue identifier] isEqualToString:@"FindAFriend"]){
        NSString *username = self.usernamesearchbar.text;
        ProfileController3 *vc = [segue destinationViewController];
        [vc grabOtherUserInfo:username];
    }

}


@end
