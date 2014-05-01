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





- (void)grabOtherUserInfo:(NSString *)username{
    //test if current user follows displayed user
    PFUser *current = [PFUser currentUser];
    NSString *currentUsername = current.username;
    //test if profile is current user to hide follow button
    if([username isEqualToString: currentUsername]){
        self.followButton.enabled=NO;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        [iAmFollowingQuery whereKey:@"Follower" equalTo:currentUsername];
        [iAmFollowingQuery whereKey:@"Following" equalTo:username];
        PFObject *x = iAmFollowingQuery.getFirstObject;
        if(x==NULL){
            self.followButton.title =@"Follow";
            self.followButton.enabled=YES;
        }else{
            self.followButton.title =@"Unfollow";
            self.followButton.enabled=YES;
        }
    }
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" containsString:username];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        //Get the user
        PFUser *theUser = [query findObjects].firstObject;
        //Set the user's name field
        self.nameLabel.text = theUser[@"name"];
        //Set the user's username field
        self.usernameLabel.text = theUser[@"username"];
        
        PFQuery *followers = [PFQuery queryWithClassName:@"Follow"];
        [followers whereKey:@"Following" equalTo:username];
        NSInteger numfollowers = followers.countObjects;
        self.followerCountLabel.text = [NSString stringWithFormat: @"%d", (int)numfollowers];
        
        PFQuery *followering = [PFQuery queryWithClassName:@"Follow"];
        [followering whereKey:@"Follower" equalTo:username];
        NSInteger numfollowering = followering.countObjects;
        self.followingCountLabel.text = [NSString stringWithFormat: @"%d", (int)numfollowering];
        
        PFQuery *events= [PFQuery queryWithClassName:@"EventList"];
        PFQuery *user = [PFQuery queryWithClassName:@"_User"];
        [user whereKey:@"username" equalTo:username];
        PFObject *userinfo = user.getFirstObject;
        NSLog(@"%@",userinfo);
        [events whereKey:@"CreatedBy" equalTo:userinfo];
        NSInteger numevents = events.countObjects;
        self.eventCountLabel.text = [NSString stringWithFormat: @"%d", (int)numevents];
        
        
        PFQuery *attendance= [PFQuery queryWithClassName:@"Attending"];
        [attendance whereKey:@"Attendee" equalTo:userinfo];
        NSInteger numattend = attendance.countObjects;
        self.attendingCountLabel.text = [NSString stringWithFormat: @"%d", (int)numattend];
        //Prepare the user's profile picture
        PFFile *imageFile = theUser[@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                //Set the user's profile picture
                self.profileImageView.image = [UIImage imageWithData:imageData];
            }}];
        
        
    }];
    
    
    

    //Returns people I follow
    PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
    [iAmFollowingQuery whereKey:@"Follower" equalTo:currentUsername];
    
    PFQuery *themQuery = [PFUser query];
    [themQuery whereKey:@"username" equalTo:username];
    
    
    PFQuery *amIFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
    [amIFollowingQuery whereKey:@"Following" matchesKey:@"username" inQuery:themQuery];
    
    

    
    _username = username;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    UIColor* imageBorderColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:0.4f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldItalicFontName = @"Avenir-BlackOblique";
    NSString* boldFontName = @"Avenir-Black";
    
    
    self.nameLabel.textColor =  mainColor;
    //self.nameLabel.font =  [UIFont fontWithName:boldItalicFontName size:18.0f];
    
    
    self.usernameLabel.textColor =  mainColor;
    
    self.friendButton.titleLabel.font = [UIFont fontWithName:boldItalicFontName size:18.0f];
    self.friendButton.titleLabel.textColor = mainColor;
    
    //self.usernameLabel.font =  [UIFont fontWithName:fontName size:14.0f];
    //self.usernameLabel.text = @"username";
    
    
    UIFont* countLabelFont = [UIFont fontWithName:boldItalicFontName size:20.0f];
    UIColor* countColor = mainColor;
    
    self.followerCountLabel.textColor =  countColor;
    //self.followerCountLabel.font =  countLabelFont;
    
    self.followingCountLabel.textColor =  countColor;
    //self.followingCountLabel.font =  countLabelFont;
    
    
    self.eventCountLabel.textColor =  countColor;
    //self.eventCountLabel.font =  countLabelFont;
    
    self.attendingCountLabel.textColor =  countColor;
    //self.attendingCountLabel.font =  countLabelFont;
    
    
    
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




- (IBAction)followAction:(id)sender {
    PFUser *current = [PFUser currentUser];
    NSString *followerUsername = current[@"username"];
    PFObject *newFollow = [PFObject objectWithClassName:@"Follow"];
    NSString *followingUsername = self.usernameLabel.text;
    NSLog(@"Looking at:%@",followerUsername);
    if([self.followButton.title isEqual:@"Follow"]){
        
        
        [newFollow setObject:followerUsername forKey:@"Follower"];
        [newFollow setObject:followingUsername forKey:@"Following"];
        [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the viewController upon success
            }
        }];
        self.followButton.title = @"Unfollow";
    }else{
        PFUser *current = [PFUser currentUser];
        NSString *followerUsername = current[@"username"];
        PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        [iAmFollowingQuery whereKey:@"Follower" equalTo:followerUsername];
        [iAmFollowingQuery whereKey:@"Following" equalTo:self.username];
        PFObject *x = iAmFollowingQuery.getFirstObject;
        if(x!=NULL){
            [x deleteInBackground];
        }
        self.followButton.title = @"Follow";
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
        NewsFeed *newsfeed = [segue destinationViewController];
        newsfeed.userinfo = _username;
        
    }else if([[segue identifier] isEqualToString:@"Attend"]){
        PFQuery *user = [PFQuery queryWithClassName:@"_User"];
        [user whereKey:@"username" equalTo:self.username];
        PFObject *person = user.getFirstObject;
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
