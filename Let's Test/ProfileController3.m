//
//  ProfileController3.m
//  ADVFlatUI
//
//  Created by Tope on 31/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ProfileController3.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "FriendsList.h"
#import "NewsFeed.h"
#import "AttendingController.h"



@interface ProfileController3 ()
@property NSString *username;
@end

@implementation ProfileController3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)grabUserInfo:(PFUser *)userop{
    
    
    //if(userop.username == [[PFUser currentUser]username]){
    //    self.editButton.hidden=NO;
    //}
    //else{
    //    self.editButton.hidden=YES;
    //}
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" containsString:userop.username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        //Get the user
        PFUser *theUser = [query findObjects].firstObject;
        //Set the user's name field
        self.nameLabel.text = theUser[@"name"];
        //Set the user's username field
        self.usernameLabel.text = theUser[@"username"];
        //Prepare the user's profile picture
        PFFile *imageFile = theUser[@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                //Set the user's profile picture
                self.profileImageView.image = [UIImage imageWithData:imageData];
                _image = [UIImage imageWithData:imageData];
            }}];
        
        
    }];
    
}


- (void)grabOtherUserInfo:(NSString *)username{
    
    
    //if(username == [[PFUser currentUser]username]){
    //    self.editButton.hidden=NO;
    //}
    //else{
    //    self.editButton.hidden=YES;
    //}
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" containsString:username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        //Get the user
        PFUser *theUser = [query findObjects].firstObject;
        //Set the user's name field
        self.nameLabel.text = theUser[@"name"];
        //Set the user's username field
        self.usernameLabel.text = theUser[@"username"];
        //Prepare the user's profile picture
        PFFile *imageFile = theUser[@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                //Set the user's profile picture
                self.profileImageView.image = [UIImage imageWithData:imageData];
            }}];
        
        
    }];
    
    
    
    //test if current user follows displayed user
    PFUser *current = [PFUser currentUser];
    NSString *currentUsername = current.username;
    //test if profile is current user to hide follow button
    if(username == currentUsername){
        self.followButton.enabled=NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
    //Returns people I follow
    PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
    [iAmFollowingQuery whereKey:@"Follower" equalTo:currentUsername];
    
    PFQuery *themQuery = [PFUser query];
    [themQuery whereKey:@"username" equalTo:username];
    
    
    PFQuery *amIFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
    [amIFollowingQuery whereKey:@"Following" matchesKey:@"username" inQuery:themQuery];
    
    
    if(amIFollowingQuery.countObjects>0){
        self.followButton.title = @"Unfollow";
    }
    
    _username = username;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *followers = [PFQuery queryWithClassName:@"Follow"];
    [followers whereKey:@"Following" equalTo:self.username];
    NSInteger numfollowers = followers.countObjects;
    self.followerCountLabel.text = [NSString stringWithFormat: @"%d", (int)numfollowers];
    
    PFQuery *followering = [PFQuery queryWithClassName:@"Follow"];
    [followering whereKey:@"Follower" equalTo:self.username];
    NSInteger numfollowering = followering.countObjects;
    self.followingCountLabel.text = [NSString stringWithFormat: @"%d", (int)numfollowering];
    
    PFQuery *events= [PFQuery queryWithClassName:@"EventList"];
    PFQuery *user = [PFQuery queryWithClassName:@"_User"];
    [user whereKey:@"username" equalTo:self.username];
    PFObject *userinfo = user.getFirstObject;
    NSLog(@"%@",userinfo);
    [events whereKey:@"CreatedBy" equalTo:userinfo];
    NSInteger numevents = events.countObjects;
    self.eventCountLabel.text = [NSString stringWithFormat: @"%d", (int)numevents];
    
    
    PFQuery *attendance= [PFQuery queryWithClassName:@"Attending"];
    [attendance whereKey:@"Attendee" equalTo:userinfo];
    NSInteger numattend = attendance.countObjects;
    self.attendingCountLabel.text = [NSString stringWithFormat: @"%d", (int)numattend];
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:0.4f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    
    self.nameLabel.textColor =  mainColor;
    self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    
    self.usernameLabel.textColor =  mainColor;
    
    self.friendButton.titleLabel.font = [UIFont fontWithName:boldItalicFontName size:18.0f];
    self.friendButton.titleLabel.textColor = mainColor;
    
    self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.usernameLabel.text = @"username";
    
    
    UIFont* countLabelFont = [UIFont fontWithName:boldItalicFontName size:20.0f];
    UIColor* countColor = mainColor;
    
    self.followerCountLabel.textColor =  countColor;
    self.followerCountLabel.font =  countLabelFont;
    
    self.followingCountLabel.textColor =  countColor;
    self.followingCountLabel.font =  countLabelFont;
    
    
    self.eventCountLabel.textColor =  countColor;
    self.eventCountLabel.font =  countLabelFont;
    
    self.attendingCountLabel.textColor =  countColor;
    self.attendingCountLabel.font =  countLabelFont;
    
    UIFont* socialFont = [UIFont fontWithName:boldItalicFontName size:10.0f];
    
    self.followerLabel.textColor =  mainColor;
    self.followerLabel.font =  socialFont;
    self.followerLabel.text = @"EVENTS";
    
    self.followingLabel.textColor =  mainColor;
    self.followingLabel.font =  socialFont;
    self.followingLabel.text = @"ATTENDING";
    
    self.updateLabel.textColor =  mainColor;
    self.updateLabel.font =  socialFont;
    self.updateLabel.text = @"MAYBE";
    
    
    self.bioLabel.textColor =  mainColor;
    self.bioLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    self.bioLabel.text = @"I like making music and scubadiving. I enjoy long walks on the beach!";
    
    self.friendLabel.textColor =  mainColor;
    self.friendLabel.font =  [UIFont fontWithName:boldFontName size:18.0f];;
    self.friendLabel.text = @"Friends";
    
    //IMPORTNAT PICTURE STUFF
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.cornerRadius = 55.0f;
    self.profileImageView.layer.borderColor = imageBorderColor.CGColor;
    
    self.bioContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.bioContainer.layer.borderWidth = 4.0f;
    self.bioContainer.layer.cornerRadius = 5.0f;
    
    self.friendContainer.layer.borderColor = [UIColor whiteColor].CGColor;
    self.friendContainer.layer.borderWidth = 4.0f;
    self.friendContainer.clipsToBounds = YES;
    self.friendContainer.layer.cornerRadius = 5.0f;
    
    [self styleFriendProfileImage:self.friendImageView1 withImageNamed:@"profile-1.jpg" andColor:imageBorderColor];
    [self styleFriendProfileImage:self.friendImageView2 withImageNamed:@"profile-2.jpg" andColor:imageBorderColor];
    [self styleFriendProfileImage:self.friendImageView3 withImageNamed:@"profile-3.jpg" andColor:imageBorderColor];
    
    //    [self addDividerToView:self.scrollView atLocation:230];
    //    [self addDividerToView:self.scrollView atLocation:300];
    //    [self addDividerToView:self.scrollView atLocation:370];
    
    self.scrollView.contentSize = CGSizeMake(320, 590);
    self.scrollView.backgroundColor = [UIColor whiteColor];
}

-(void)styleFriendProfileImage:(UIImageView*)imageView withImageNamed:(NSString*)imageName andColor:(UIColor*)color{
    
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = color.CGColor;
    imageView.layer.cornerRadius = 35.0f;
}

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 if([[segue identifier] isEqualToString:@"ShowFriends"]){
 ProfileController3 *ProfileController = [segue destinationViewController];
 
 PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Follow"];
 [friendsQuery whereKey:@"Following" equalTo:[PFUser currentUser]];
 [friendsQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
 PFObject *firstFollow = [friendsQuery findObjects].firstObject;
 PFQuery *query = [PFUser query];
 
 [query whereKey:@"objectId" containsString:firstFollow[@"Following"]];
 [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
 PFUser *firstFriend = [query findObjects].firstObject;
 
 
 }];
 
 
 }];
 
 
 
 }
 }*/


- (IBAction)followAction:(id)sender {
    PFUser *current = [PFUser currentUser];
    NSString *followerUsername = current[@"username"];
    PFObject *newFollow = [PFObject objectWithClassName:@"Follow"];
    NSString *followingUsername = self.usernameLabel.text;
    if([self.followButton.title isEqual:@"Follow"]){
        
        
        [newFollow setObject:followerUsername forKey:@"Follower"];
        [newFollow setObject:followingUsername forKey:@"Following"];
        [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon success
            }
        }];}
    else{
        PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        [iAmFollowingQuery whereKey:@"Follower" equalTo:followerUsername];
        
        PFQuery *themQuery = [PFUser query];
        [themQuery whereKey:@"username" equalTo:followingUsername];
        
        
        PFQuery *amIFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        [amIFollowingQuery whereKey:@"Following" matchesKey:@"username" inQuery:themQuery];
        amIFollowingQuery.getFirstObject.deleteInBackground;
    }
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowFollowers"]){
        NSLog(@"show");
        FriendsList *FL = [segue destinationViewController];
        FL.follower=2;
        FL.username = self.username;
        FL.FollowerTitleNavItem.title=@"Followers";
        
    }
    else if([[segue identifier] isEqualToString:@"ShowFollowing"]){
        NSLog(@"showf");
        FriendsList *FL = [segue destinationViewController];
        FL.follower=1;
        FL.username = self.username;
        FL.FollowerTitleNavItem.title=@"Following";
        
        
    }else if([[segue identifier] isEqualToString:@"MyEvents"]){
        NSLog(@"ASSSSS");
        NewsFeed *newsfeed = [segue destinationViewController];
        newsfeed.userinfo = _username;
        NSLog(@"HEYYYYYYY: %@",_username);
        
    }else if([[segue identifier] isEqualToString:@"Attend"]){
        PFQuery *user = [PFQuery queryWithClassName:@"_User"];
        [user whereKey:@"username" equalTo:self.username];
        PFObject *person = user.getFirstObject;
        NSLog(@"YOOOOO %@",person);
        NewsFeed *newsfeed = [segue destinationViewController];
        newsfeed.person = person;
        
        
    }
}


-(void)addDividerToView:(UIView*)view atLocation:(CGFloat)location{
    
    UIView* divider = [[UIView alloc] initWithFrame:CGRectMake(20, location, 280, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    [view addSubview:divider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
}

- (IBAction)unwindToProfile:(UIStoryboardSegue *)unwindSegue
{
}

@end
