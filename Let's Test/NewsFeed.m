//
//  NewsFeed.m
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "NewsFeed.h"
#import "NewsFeedCell.h"
#import "EventViewController.h"
#import "ProfileController3.h"

@interface NewsFeed ()

@end

@implementation NewsFeed

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
    PFQuery *query = [PFQuery queryWithClassName:@"EventList"];
    NSLog(@"WHEREFROM %@",self.userinfo);
    if (self.userinfo!=NULL) {
        _Proback.title = @"Back";
        NSLog(@"CHEKC");
        PFQuery *person = [PFQuery queryWithClassName:@"_User"];
        [person whereKey:@"username" equalTo:_userinfo];
        NSObject *o = person.getFirstObject;
        NSLog(@"check: %@",o);
        [query whereKey:@"CreatedBy" equalTo:person.getFirstObject];
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
    
    static NSString *CellIdentifier = @"NewsFeedCell";
    PFObject *obd = [object objectForKey:@"CreatedBy"];
    NSLog(@"%@",obd);
    NSLog(@"%@",obd.objectId);
    PFQuery *q = [PFQuery queryWithClassName:@"_User"];
    [q whereKey:@"objectId" equalTo:obd.objectId];
    PFObject *o = q.getFirstObject;
    PFFile *blah = [o objectForKey:@"image"];
    NSData *imageData = [blah getData];
    
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle
    //                                   reuseIdentifier:CellIdentifier];
    //    }
    
    
    // Configure the cell to show todo item with a priority at the bottom
    // cell.textLabel.text = [object objectForKey:@"Address"];
    cell.EventLabel.text = [object objectForKey:@"EventName"];
    cell.DecriptionLabel.text = [object objectForKey:@"Details"];
    cell.ProfileImage.image = [UIImage imageWithData:imageData];
    //cell.commentLabel.text = @"comment";
    cell.timeStamp.text = @"2 min ago";
    cell.dateLabel.text = [object objectForKey:@"DateTime"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowEvent"]){
        
        EventViewController *eventViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        PFObject *obd = [object objectForKey:@"CreatedBy"];
        PFQuery *q = [PFQuery queryWithClassName:@"_User"];
        [q whereKey:@"objectId" equalTo:obd.objectId];
        PFObject *o = q.getFirstObject;
        PFFile *blah = [o objectForKey:@"image"];
        NSData *imageData = [blah getData];
        
        eventViewController.DetailModal = @[[UIImage imageWithData:imageData],[object objectForKey:@"EventName"],[object objectForKey:@"DateTime"],[object objectForKey:@"Details"], @"2 min ago"];
        eventViewController.object = object;
        eventViewController.creator = o;
        
    }
    else if([[segue identifier] isEqualToString:@"SelfProfileSegue"]){
        
        ProfileController3 *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        PFUser *current = [PFUser currentUser];
        NSString *username = current.username;
        [vc grabOtherUserInfo:username];
        
        
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_Proback setTarget:self];
    [_Proback setAction:@selector(probackmeth:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)probackmeth:(UIStoryboardSegue *)sender{
    if(self.userinfo==NULL){
        [self performSegueWithIdentifier:@"SelfProfileSegue" sender:sender];
    }else{
        //go back to profile
        [self performSegueWithIdentifier:@"Return" sender:sender];
    }
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
