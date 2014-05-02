//
//  FoundFriends.m
//  Let's Test
//
//  Created by Yamiel Zea on 5/2/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "FoundFriends.h"
#import "FriendsListCell.h"
#import "ProfileController3.h"

@interface FoundFriends ()

@end

@implementation FoundFriends

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
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    if(self.on==0){
        [query whereKey:@"objectId" equalTo:@""];
    }else if(self.on==1){
        [query whereKey:@"username"  matchesRegex:self.user modifiers:@"i"];
    }else{
        [query whereKey:@"name"  matchesRegex:self.user modifiers:@"i"];
    }
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
     NSString *CellIdentifier = @"FriendsListCell";
     FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(self.on>0)
    cell.NameLabel.text = [object objectForKey:@"name"];
    cell.UsernameLabel.text = [object objectForKey:@"username"];
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            //Set the user's profile picture
            cell.ProfileImage.image = [UIImage imageWithData:imageData];
        }}];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchPressed:(id)sender {
    NSString *blah = [self.searchbar.text lowercaseString];
    
    if([blah isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Empty" message:@"There is no entry in this field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        NSMutableArray *fillarray = [[NSMutableArray alloc]init];
        NSMutableArray *fillarray2 = [[NSMutableArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        NSArray *array = query.findObjects;
        
        for (PFObject *object in array) {
            NSString *username = [[object objectForKey:@"username"] lowercaseString];
            NSString *name = [[object objectForKey:@"name"] lowercaseString];
            if([blah isEqualToString:username]){
                [fillarray addObject:object];
            }
            if([blah isEqualToString:name]){
                [fillarray2 addObject:object];
            }
        }
        
        
        if(fillarray.count==0&&fillarray2.count==0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Search" message:@"There is no user with that name or username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
        if(fillarray.count>0&&fillarray2.count==0){
            NSLog(@"CHECK");
            self.user = blah;
            self.on = 1;
            [self viewDidLoad];
        }
        
        if(fillarray.count==0&&fillarray2.count>0){
            self.user = blah;
            self.on = 2;
        }
        
        if(fillarray.count>0&&fillarray2.count>0){
            self.user = blah;
            self.on = 1;
        }
        
        
        
        
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"found"]){
        
        //ProfileController3 *ProfileController = [segue destinationViewController];
        ProfileController3 *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSLog(@"PROFILE: %@",object);
        NSString *username = object[@"username"];
        NSLog(@"Showing friend: %@",username);
        [vc grabOtherUserInfo:username];
        
    }
}

@end
