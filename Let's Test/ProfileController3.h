//
//  ProfileController3.h
//  ADVFlatUI
//
//  Created by Tope on 31/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileController3 : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView* profileImageView;

@property (nonatomic, weak) IBOutlet UIImageView* profileBgImageView;

@property (nonatomic, weak) IBOutlet UIView* overlayView;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView1;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView2;

@property (nonatomic, weak) IBOutlet UIImageView* friendImageView3;

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingLabel;

@property (nonatomic, weak) IBOutlet UILabel* updateLabel;

@property (nonatomic, weak) IBOutlet UILabel* followerCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* followingCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* eventCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *attendingCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* bioLabel;

@property (nonatomic, weak) IBOutlet UILabel* friendLabel;

@property (nonatomic, weak) IBOutlet UIButton* friendButton;

@property (nonatomic, weak) IBOutlet UIButton* editButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *followButton;

@property (nonatomic, weak) IBOutlet UIView* bioContainer;

@property (nonatomic, weak) IBOutlet UIView* friendContainer;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) NSArray *postArray;

@property (nonatomic,strong) NSString *whosInfo;



@property (nonatomic, strong) UIImage *image;
- (IBAction)logout:(id)sender;

-(IBAction)grabUserInfo:(id)sender;
-(IBAction)grabOtherUserInfo:(id)sender;

@end
