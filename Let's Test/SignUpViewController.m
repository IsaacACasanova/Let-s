//
//  SignUpViewController.m
//  Lets Login and Signup
//
//  Created by Alexander Buck on 3/25/14.
//  Copyright (c) 2014 Alex Buck. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import <stdlib.h>
#import "MBProgressHUD.h"
#define TEXTFIELD_HEIGHT 0.0f

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    /* Setting up textfields for keyboard notifications */
    
    usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    reEnterPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    usernameField.delegate = self;
    emailField.delegate = self;
    passwordField.delegate = self;
    reEnterPasswordField.delegate = self;
    nameField.delegate = self;
    
    /* Styling the profile Picture imageView */
    
    UIColor* mainColor = [UIColor colorWithRed:68.0/255 green:106.0/255 blue:201.0/255 alpha:1.0f];
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.layer.cornerRadius = 25.0f;
    self.profilePicture.layer.borderWidth = 2.0f;
    self.profilePicture.layer.borderColor = mainColor.CGColor;
    
    [super viewDidLoad];
    [self registerforKeyboardNotifications];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUpAction:(id)sender {
    [usernameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [reEnterPasswordField resignFirstResponder];
    [self checkFieldsComplete];
    [self uploadImage:self];
    

}

-(void) checkFieldsComplete {
    if([usernameField.text isEqualToString:@""] || [emailField.text isEqualToString: @""] || [passwordField.text isEqualToString:@""]  || [reEnterPasswordField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message: @"You need to complete all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        [self checkPasswordsMatch];
        
    }
    
}

-(void) checkPasswordsMatch {
    if(![passwordField.text isEqualToString:reEnterPasswordField.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message: @"Passwords dont match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        [self registerNewUser];
    }
    
    
}

-(void) registerNewUser {
    PFUser *newUser = [PFUser user];
    newUser.username = usernameField.text;
    newUser.email = emailField.text;
    newUser.password = passwordField.text;
    newUser[@"name"] = nameField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSLog(@"Registration success!");
            //[self performSegueWithIdentifier:@"signup" sender:self];
        }
        else{
            NSLog(@"There was an error in registration");
        }
        
    }];
    
    
}


/* Upload photo methods */

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
    hud = nil;
}

- (IBAction)cameraUpload:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)libraryUpload:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)uploadImage:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    //NSString *username = [user username];
    //NSString *userImage = [username stringByAppendingString:@".jpg"];
    NSData *imageData = UIImageJPEGRepresentation(self.profilePicture.image,0.5);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    [user setObject:imageFile forKey:@"image"];
    [user saveInBackground];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    // Upload image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [hud hide:YES];
        
        if(!error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved your image!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self performSegueWithIdentifier:@"signup" sender:self];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.profilePicture.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/* End of uploading photo methods */

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Comment textfield

-(IBAction) textFieldDoneEditing: (id) sender
{
    [sender resignFirstResponder];
    [usernameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [reEnterPasswordField resignFirstResponder];
    [nameField resignFirstResponder];
}

-(IBAction)backgroundTap:(id) sender
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [passwordField resignFirstResponder];
    [reEnterPasswordField resignFirstResponder];
    [nameField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    if (usernameField.text.length>0){
    }
    return NO;
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
