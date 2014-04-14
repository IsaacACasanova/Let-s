//
//  AddCommentViewController.h
//  DynamicComments
//
//  Created by Isaac  Casanova on 2/20/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddCommentViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *textField;
    IBOutlet UIView *commentView;
}

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (strong,nonatomic) PFObject *object;

-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;

@end