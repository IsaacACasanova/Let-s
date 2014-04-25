//
//  SignUpViewController.h
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
{
    
 IBOutlet UITextField *usernameField;
 IBOutlet UITextField *emailField;
 IBOutlet UITextField *passwordField;
 IBOutlet UITextField *reEnterPasswordField;
 IBOutlet UITextField *nameField;

}

- (IBAction)signUpAction:(id)sender;
-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;




@end
