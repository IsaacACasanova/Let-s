#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "ProfilePictureViewController.h"
#import "LetsCommentsCell.h"
#import "LetsCommentsTableViewController.h"
#import "AddCommentViewController.h"
#import <Parse/Parse.h>

@interface LetsCommentsTableViewController ()

@end

@implementation LetsCommentsTableViewController

@synthesize data;
@synthesize thumbnails;
@synthesize userName;
@synthesize time;
@synthesize dataTableView;

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"LetsComments";
        
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
    PFQuery *query = [PFQuery queryWithClassName:@"LetsComments"];
    [query whereKey:@"EventID" equalTo:self.object.objectId];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize arrays!
    
    data = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    userName = [[NSMutableArray alloc] init];
    time = [[NSMutableArray alloc] init];
    
    // Check for saved array
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"savedArray"] != nil) {
        self.data = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedArray"]];
    }
    
    // Register for appWillGoToBackground notifications
    
    [[NSNotificationCenter defaultCenter]   addObserver:self
                                               selector:@selector(appWillGoToBackground:)
                                                   name:UIApplicationWillResignActiveNotification
                                                 object:[UIApplication sharedApplication]];
    
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
    static NSString *CellIdentifier = @"LetsCommentsCell";
    LetsCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[LetsCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    // Adding to the TableView!
    
    cell.userName.text = [object objectForKey:@"username"];
    cell.comment.lineBreakMode = NSLineBreakByWordWrapping;
    cell.comment.text = [object objectForKey:@"comment"];
    cell.time.text = [object objectForKey:@"time"];
    
    PFUser *currentUser = [PFUser currentUser];
    PFFile *userImageFile = [currentUser objectForKey:@"image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.thumbNailImage.image = image;
        }
        else {
            cell.thumbNailImage.image = [UIImage imageNamed:@"placeholder.jpg"];
       }
    }];

    return cell;
    
}


// Method that automatically deselects

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [object deleteInBackground];
    }
}

// Called after 'Send' is tapped on the AddCommentViewController
-(IBAction)unwindToTableViewController:(UIStoryboardSegue *)sender
{
    PFUser *currentUser = [PFUser currentUser];
    AddCommentViewController *addCommentViewController = (AddCommentViewController *)sender.sourceViewController;
    
    NSString *text = addCommentViewController.textField.text;
    
    // If the textField isn't blank
    if(![text length] == 0 && ![[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        
        // Then Add it to the top of the data source
        [userName insertObject:[currentUser username] atIndex:0];
        
        [data insertObject:text atIndex:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *timePosted = [formatter stringFromDate:[NSDate date]];
        [time insertObject:timePosted atIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //Last, Insert it into the tableview
        [self.dataTableView beginUpdates];
        [self.dataTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        [self.dataTableView endUpdates];
        [self.dataTableView reloadData];
        
        // Then Send it to Parse...
        PFObject *newComment = [PFObject objectWithClassName:@"LetsComments"];
        newComment[@"EventID"] = self.object.objectId;
        newComment[@"username"] = [currentUser username];
        newComment[@"comment"] = text;
        newComment[@"time"] = timePosted;
        [newComment save];
        
        // Reload the PFQueryTableViewController with the added comment.
        [self loadObjects:1 clear:YES];
        
    }
    
}

// Save the Array when the App goes to the background.

-(void)appWillGoToBackground:(NSNotification *)note
{
    NSLog(@"App is in background");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.data forKey:@"savedArray"];
    [defaults synchronize];
    
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
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
