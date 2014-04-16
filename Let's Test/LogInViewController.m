//
//  LogInViewController.m
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#define TEXTFIELD_HEIGHT 20.0f

@interface LogInViewController ()

@end

@implementation LogInViewController


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
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    _usernameField.delegate = self;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.delegate = self;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerforKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)signInAction:(id)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
        if(!error){
            NSLog(@"Login user!");
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (IBAction)forgotPassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Password Recovery"
                          message:@"Enter your email to recieve your password."
                          delegate:self cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Send", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    
}

-(void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [PFUser requestPasswordResetForEmailInBackground:[[alertView textFieldAtIndex:0]text]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Comment textfield

-(IBAction) textFieldDoneEditing: (id) sender
{
    [sender resignFirstResponder];
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

-(IBAction)backgroundTap:(id) sender
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textEntry
{
    [textEntry resignFirstResponder];
    return YES;
}

-(void) registerforKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown:(NSNotification *)aNotification
{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height+TEXTFIELD_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height-TEXTFIELD_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}

@end
