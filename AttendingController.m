//
//  AttendingController.m
//  Let's Test
//
//  Created by Yamiel Zea on 4/26/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "AttendingController.h"
#import "AttendingCell.h"
#import "ProfileController3.h"

@interface AttendingController ()

@end

@implementation AttendingController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Attending"];
    if(self.event !=NULL){
        [query whereKey:@"Event" equalTo:self.event];
    }
    
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"AttendingCell";
    PFObject *user = [object objectForKey:@"Attendee"];
    PFQuery *userinfogetter = [PFQuery queryWithClassName:@"_User"];
    [userinfogetter whereKey:@"objectId" equalTo:user.objectId];
    PFObject *userinfo = userinfogetter.getFirstObject;
    PFFile *blah = [userinfo objectForKey:@"image"];
    NSData *imageData = [blah getData];

    
    AttendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle
    //                                   reuseIdentifier:CellIdentifier];
    //    }
    
    
    // Configure the cell to show todo item with a priority at the bottom
    // cell.textLabel.text = [object objectForKey:@"Address"];
      cell.NameLabel.text = [userinfo objectForKey:@"name"];
      cell.UsernameLabel.text = [userinfo objectForKey:@"username"];
      cell.ProfileImage.image = [UIImage imageWithData:imageData];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"Attendee"]){
        
         ProfileController3 *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        PFObject *user = [object objectForKey:@"Attendee"];
        PFQuery *userinfogetter = [PFQuery queryWithClassName:@"_User"];
        [userinfogetter whereKey:@"objectId" equalTo:user.objectId];
        PFObject *userinfo = userinfogetter.getFirstObject;
        NSLog(@"%@",object);

        [vc grabOtherUserInfo:[userinfo objectForKey:@"username"]];

        
    }
 }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
