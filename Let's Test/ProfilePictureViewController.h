//
//  ProfilePictureViewController.h
//  Lets Login and Signup
//
//  Created by Alexander Buck on 4/2/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePictureViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

- (IBAction)cameraUpload:(id)sender;

- (IBAction)libraryUpload:(id)sender;

- (IBAction)uploadImage:(id)sender;

@end
