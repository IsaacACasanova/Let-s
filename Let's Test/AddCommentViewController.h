//
//  AddCommentViewController.h
//  DynamicComments
//
//  Created by Isaac  Casanova on 2/20/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddCommentViewController : UIViewController<UITextViewDelegate>
{
    UITextView *textField;
    IBOutlet UIView *commentView;
}

@property (nonatomic, strong) IBOutlet UITextView *textField;
@property (strong,nonatomic) PFObject *object;

-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;

@end