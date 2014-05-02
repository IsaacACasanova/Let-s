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
    IBOutlet UILabel *commentLength;
    IBOutlet UIView *commentView;
}

@property (nonatomic, strong) IBOutlet UITextView *textField;
@property (strong,nonatomic) PFObject *object;
@property (strong, nonatomic) UIImageView *imageView;
@property int maxCommentLength;

-(void) registerforKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification *)aNotification;
-(void) keyboardWillHide:(NSNotification *)aNotification;

@end