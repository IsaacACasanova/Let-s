//
//  SignUpViewController.h
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
 IBOutlet UITextField *usernameField;
 IBOutlet UITextField *emailField;
 IBOutlet UITextField *passwordField;
 IBOutlet UITextField *reEnterPasswordField;
 IBOutlet UITextField *nameField;

}

/* Sign up / keyboard methods */

- (IBAction)signUpAction:(id)sender;
-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;

/* Profile picture methods */

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
- (IBAction)cameraUpload:(id)sender;
- (IBAction)libraryUpload:(id)sender;
- (IBAction)uploadImage:(id)sender;




@end
