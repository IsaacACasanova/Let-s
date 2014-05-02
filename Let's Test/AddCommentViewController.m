//
//  AddCommentViewController.m
//  DynamicComments
//
//  Created by Isaac  Casanova on 2/20/14.
//
//

#import "AddCommentViewController.h"

#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController
@synthesize textField;
@synthesize maxCommentLength;


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
    
    self.imageView.layer.cornerRadius = 5.0f;
	textField.delegate = self;
    textField.editable = YES;
    textField.text = @"Type Something...";
    [textField becomeFirstResponder];
    commentLength.text = [NSString stringWithFormat:@"%lu",textField.text.length - 17];

    //[self registerforKeyboardNotifications];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}


-(void)textViewDidChange:(UITextView *)textView
{
        NSString *subString = [NSString stringWithString:textField.text];
        if(subString.length <= 140 && subString.length > 61)
        {
            commentLength.text = [NSString stringWithFormat:@"%lu",subString.length];
            commentLength.textColor = [UIColor redColor];
        }
        else if(subString.length > 30 && subString.length <= 61){
            commentLength.text = [NSString stringWithFormat:@"%lu",subString.length];
            commentLength.textColor = [UIColor orangeColor];
        }
        else if(subString.length == 0 || subString.length <= 30){
            commentLength.text = [NSString stringWithFormat:@"%lu",subString.length];
            commentLength.textColor = [UIColor blackColor];
        }
        else{
            commentLength.text = [NSString stringWithFormat:@"%lu", subString.length];
            commentLength.textColor = [UIColor redColor];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Event Name cannot be longer than 140 characters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(textView.tag==1){
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Comment textfield

-(IBAction) textFieldDoneEditing: (id) sender
{
    [sender resignFirstResponder];
    [textField resignFirstResponder];
}

-(IBAction)backgroundTap:(id) sender
{
    [self.textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textEntry
{
    NSLog(@"the text content%@", textField.text);
    [textEntry resignFirstResponder];
    
    if (textField.text.length>0){
    }
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type Something..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Type Something...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
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