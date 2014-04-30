//
//  CreateEvent.h
//  Let's Test
//
//  Created by Yamiel Zea on 3/29/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateEvent : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *eventtxt;
    IBOutlet UITextView *dettext;
    IBOutlet UITextField *nametxt;
    IBOutlet UITextField *streettxt;
    IBOutlet UITextField *citytxt;
    IBOutlet UITextField *statetxt;
    IBOutlet UITextField *ziptxt;
    IBOutlet UIPickerView *month;
    IBOutlet UIPickerView *day;
    IBOutlet UIPickerView *year;
    IBOutlet UIPickerView *hour;
    IBOutlet UIPickerView *min;
    IBOutlet UIPickerView *ampm;
    NSMutableArray *monthdata;
    NSMutableArray *daydata;
    NSMutableArray *yeardata;
    NSMutableArray *hourdata;
    NSMutableArray *mindata;
    NSMutableArray *ampmdata;
    
}

@property (strong, nonatomic) IBOutlet UIButton *CreateButton;

@property (strong, nonatomic) IBOutlet UISwitch *swicher;

@property (strong, nonatomic) IBOutlet UITextView *dettext;

@property (strong, nonatomic) IBOutlet UILabel *puborpri;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UIView *contentview;
@property (retain,nonatomic) UIPickerView *month;
@property (retain,nonatomic) UIPickerView *day;
@property (retain,nonatomic) UIPickerView *year;
@property (retain,nonatomic) UIPickerView *hour;
@property (retain,nonatomic) UIPickerView *min;
@property (retain,nonatomic) UIPickerView *ampm;
@property (retain, nonatomic) NSMutableArray *monthdata;
@property (retain, nonatomic) NSMutableArray *daydata;
@property (retain, nonatomic) NSMutableArray *yeardata;
@property (retain, nonatomic) NSMutableArray *hourdata;
@property (retain, nonatomic) NSMutableArray *mindata;
@property (retain, nonatomic) NSMutableArray *ampmdata;

@property (strong,nonatomic) PFObject *event;

- (IBAction)exit:(id)sender;

@end
