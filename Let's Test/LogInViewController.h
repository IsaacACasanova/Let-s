//
//  LogInViewController.h
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LogInViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signInAction:(id)sender;
- (IBAction)forgotPassword:(id)sender;

-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;

@end
