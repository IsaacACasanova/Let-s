//
//  SecondViewController.m
//  CreateEvent
//
//  Created by Yamiel Zea on 11/23/13.
//  Copyright (c) 2013 Yamiel Zea. All rights reserved.
//

#import "CreateEvent.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface CreateEvent ()

@property NSString* loglatlabel,*cleanaddress,*date,*monthlabel,*daylabel,*yearlabel,*hourlabel,*minlabel,*ampmlabel;
@property CLLocationCoordinate2D coords;
@property UIEdgeInsets originalInsets;
@property PFGeoPoint* point;
@property NSMutableArray* day30, *day29, *day28, *day31;
@end




@implementation CreateEvent
@synthesize puborpri,ampm,month,day,year,hour,min,monthdata,daydata,yeardata,hourdata,mindata,ampmdata,dettext,swicher;



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
	// Do any additional setup after loading the view.
    
    [self.dettext.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.25] CGColor]];
    [self.dettext.layer setBorderWidth:1.0];
    self.dettext.layer.cornerRadius = 5;
    self.dettext.clipsToBounds = YES;
    
    
    self.scroller.scrollEnabled = YES;
    self.scroller.contentSize = self.contentview.bounds.size;
    self.month.tag = 1;
    self.day.tag = 2;
    self.year.tag = 3;
    self.hour.tag = 4;
    self.min.tag = 5;
    self.ampm.tag = 6;
    
    self.monthdata = [[NSMutableArray alloc] init];
    self.daydata = [[NSMutableArray alloc] init];
    self.yeardata = [[NSMutableArray alloc] init];
    self.hourdata = [[NSMutableArray alloc] init];
    self.mindata = [[NSMutableArray alloc] init];
    self.ampmdata = [[NSMutableArray alloc] init];
    self.day28 = [[NSMutableArray alloc] init];
    self.day29 = [[NSMutableArray alloc] init];
    self.day30 = [[NSMutableArray alloc] init];
    self.day31 = [[NSMutableArray alloc] init];
    
    [self.ampmdata addObject:[NSString localizedStringWithFormat:@"%s","AM"]];
    [self.ampmdata addObject:[NSString localizedStringWithFormat:@"%s","PM"]];
    for(int i=1;i<13;i++){
        if(i<10){
            [self.monthdata addObject:[NSString localizedStringWithFormat:@"0%d",i]];
        }else{
            [self.monthdata addObject:[NSString localizedStringWithFormat:@"%d",i]];
        }
        [self.hourdata addObject:[NSString localizedStringWithFormat:@"%d",i]];
    }
    for(int i=1;i<32;i++){
        if(i<10){
            [self.day31 addObject:[NSString localizedStringWithFormat:@"0%d",i]];
            [self.day30 addObject:[NSString localizedStringWithFormat:@"0%d",i]];
            [self.day29 addObject:[NSString localizedStringWithFormat:@"0%d",i]];
            [self.day28 addObject:[NSString localizedStringWithFormat:@"0%d",i]];
        }else{
            if(i<29){
                [self.day31 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day30 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day29 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day28 addObject:[NSString localizedStringWithFormat:@"%d",i]];
            }else if(i<30){
                [self.day31 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day30 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day29 addObject:[NSString localizedStringWithFormat:@"%d",i]];
            }else if(i<31){
                [self.day31 addObject:[NSString localizedStringWithFormat:@"%d",i]];
                [self.day30 addObject:[NSString localizedStringWithFormat:@"%d",i]];
            }else{
                [self.day31 addObject:[NSString localizedStringWithFormat:@"%d",i]];
            }
        }
    }
    for(int i=14;i<21;i++){
        [self.yeardata addObject:[NSString localizedStringWithFormat:@"20%d",i]];
    }
    for(int i=0;i<60;i++){
        if(i<10){
            [self.mindata addObject:[NSString localizedStringWithFormat:@"0%d",i]];
        }else{
            [self.mindata addObject:[NSString localizedStringWithFormat:@"%d",i]];
        }
    }
    self.daydata = self.day31;
    if(self.event !=NULL){
        //self.CreateButton.titleLabel.text = @"Update";
        
        [self.CreateButton setTitle:@"Update" forState:UIControlStateNormal];
        PFGeoPoint *point = [self.event objectForKey:@"Coordinates"];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        [coder reverseGeocodeLocation:loc
                    completionHandler: ^(NSArray *placemarks, NSError *error){
                        if (error){
                            //  self.loglatlabel.text = @"error";
                            return;
                        }
                        
                        if(placemarks && placemarks>0){
                            CLPlacemark *placemark = placemarks[0];
                            NSDictionary *dic = placemark.addressDictionary;
                            NSString *address = [dic objectForKey:(NSString *) kABPersonAddressStreetKey];
                            NSString *city = [dic objectForKey:(NSString *) kABPersonAddressCityKey];
                            NSString *state = [dic objectForKey:(NSString *) kABPersonAddressStateKey];
                            NSString *zip = [dic objectForKey:(NSString *) kABPersonAddressZIPKey];
                            
                            
                            streettxt.text = address;
                            citytxt.text = city;
                            statetxt.text = state;
                            ziptxt.text = zip;
                            
                        }
                    }];
        
        eventtxt.text = [self.event objectForKey:@"EventName"];
        dettext.text = [self.event objectForKey:@"Details"];
        nametxt.text = [self.event objectForKey:@"LocationName"];
        
        if([[self.event objectForKey:@"public"] isEqual:(@"yes")]){
            puborpri.text = @"Public";
            swicher.on=YES;
        }else{
            puborpri.text = @"Private";
            swicher.on = NO;
        }
        
        NSString *date = [self.event objectForKey:@"DateTime"];
        
        self.monthlabel = [date substringToIndex:2];
        self.daylabel = [date substringWithRange:NSMakeRange(3, 2)];
        self.yearlabel = [date substringWithRange:NSMakeRange(6, 4)];
        
        NSString *time = [date substringFromIndex:13];
        NSArray *myWords = [time componentsSeparatedByString:@":"];
        self.hourlabel = myWords[0];
        NSString *mt = myWords[1];
        NSArray *mWords = [mt componentsSeparatedByString:@" "];
        self.minlabel = mWords[0];
        self.ampmlabel = mWords[1];
        
        
        
        int monthvalue = [[date substringToIndex:2] intValue];
        NSLog(@"month: %d",monthvalue);
        int dayvalue = [[date substringWithRange:NSMakeRange(3, 2)] intValue];
        int yearvalue = [[date substringWithRange:NSMakeRange(6, 4)] intValue]-2013;
        int hourvalue = [myWords[0] intValue];
        int minvalue = [mWords[0] intValue]+1;
        
        [month selectRow:(60-(61-monthvalue)) inComponent:0 animated:YES];
        
        if(monthvalue==2){
            if(yearvalue==3||yearvalue==7){
                self.daydata = self.day29;
                [day selectRow:(60-(61-dayvalue)) inComponent:0 animated:YES];
            }else{
                self.daydata = self.day28;
                [day selectRow:(60-(61-dayvalue)) inComponent:0 animated:YES];
            }
        }else if(monthvalue==4||monthvalue==6||monthvalue==9||monthvalue==11){
            self.daydata = self.day30;
            [day selectRow:(60-(61-dayvalue)) inComponent:0 animated:YES];
        }else{
            self.daydata = self.day31;
            [day selectRow:(60-(61-dayvalue)) inComponent:0 animated:YES];
        }
        NSLog(@"min: %d",minvalue);
        [hour selectRow:(60-(61-hourvalue)) inComponent:0 animated:YES];
        [min selectRow:(80-(81-minvalue)) inComponent:0 animated:YES];
        [year selectRow:(60-(61-yearvalue)) inComponent:0 animated:YES];
        if([self.ampmlabel isEqualToString:@"AM"]){
            [ampm selectRow:0 inComponent:0 animated:YES];
        }else{
            [ampm selectRow:1 inComponent:0 animated:YES];
        }
        
    }
    
    [self MakeInfinite:NULL pickerView:month pickerData:monthdata];
    [self MakeInfinite:NULL pickerView:day pickerData:daydata];
    [self MakeInfinite:NULL pickerView:year pickerData:yeardata];
    [self MakeInfinite:NULL pickerView:hour pickerData:hourdata];
    [self MakeInfinite:NULL pickerView:min pickerData:mindata];
    // [self MakeInfinite:NULL pickerView:ampm pickerData:ampmdata];
    
    

    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//                          PICKERVIEW CONSTRUCTION

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerview numberOfRowsInComponent:(NSInteger)component{
    if(pickerview.tag==6){
        return [self.ampmdata count];
    }else{
        return 16384;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    if(pickerView.tag ==1){
        label.text = [NSString stringWithFormat:@"  %@",  self.monthdata[row%[self.monthdata count]]];
    }else
        if(pickerView.tag ==2){
            label.text = [NSString stringWithFormat:@"  %@",  self.daydata[row%[self.daydata count]]];
        }else
            if(pickerView.tag ==3){
                label.text = [NSString stringWithFormat:@"  %@",  self.yeardata[row%[self.yeardata count]]];
            }
            else
                if(pickerView.tag ==4){
                    label.text = [NSString stringWithFormat:@"  %@",  self.hourdata[row%[self.hourdata count]]];
                }
                else
                    if(pickerView.tag ==5){
                        label.text = [NSString stringWithFormat:@"  %@",  self.mindata[row%[self.mindata count]]];
                    }else{
                        label.text = [NSString stringWithFormat:@" %@",  self.ampmdata[row%[self.ampmdata count]]];
                    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView.tag ==1){
        _monthlabel = self.monthdata[row%[self.monthdata count]];
        NSLog(@"moncomp: %d",component);
        if([_monthlabel  isEqual:@"02"]){
            if(([_yearlabel  isEqual:@"2016"]||[_yearlabel  isEqual:@"2020"])){
                self.daydata = self.day29;
                [self.day reloadAllComponents];
                [self.day selectRow:8178 inComponent:0 animated:NO];
            }else{
                self.daydata = self.day28;
                [self.day reloadAllComponents];
                [self.day selectRow:8176 inComponent:0 animated:NO];
            }
        }else if([_monthlabel  isEqual:@"04" ] || [_monthlabel  isEqual:@"06" ] || [_monthlabel  isEqual:@"09" ]||[ _monthlabel  isEqual:@"11"]){
            self.daydata = self.day30;
            [self.day reloadAllComponents];
            [self.day selectRow:8190 inComponent:0 animated:NO];
        }else{
            if(self.daydata!=self.day31){
                self.daydata = self.day31;
                [self.day reloadAllComponents];
                [self.day selectRow:8184 inComponent:0 animated:NO];
            }
        }
    }else
        if(pickerView.tag ==2){
            _daylabel = self.daydata[row%[self.daydata count]];
            NSLog(@"%d",row);
        }else
            if(pickerView.tag ==3){
                _yearlabel = self.yeardata[row%[self.yeardata count]];
                if([_monthlabel isEqual:@"02"]){
                    if(([_yearlabel  isEqual:@"2016"]||[_yearlabel  isEqual:@"2020"])&&[_monthlabel isEqual:@"02"]){
                        self.daydata = self.day29;
                        [self.day reloadAllComponents];
                        [self.day selectRow:8178 inComponent:0 animated:NO];
                    }else{
                        if(self.daydata !=self.day28){
                            self.daydata = self.day28;
                            [self.day reloadAllComponents];
                            [self.day selectRow:8176 inComponent:0 animated:NO];
                        }
                    }
                }
            }
            else
                if(pickerView.tag ==4){
                    _hourlabel = self.hourdata[row%[self.hourdata count]];
                }
                else
                    if(pickerView.tag ==5){
                        _minlabel = self.mindata[row%[self.mindata count]];
                    }else{
                        _ampmlabel = self.ampmdata[row%[self.ampmdata count]];
                    }
}

-(void)MakeInfinite: (id)blah pickerView:(UIPickerView *)pickerView pickerData:(NSMutableArray *)array{
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2)-(max/2)%[array count];
    [pickerView selectRow:[pickerView selectedRowInComponent:0]%[array count]+base10 inComponent:0 animated:false];
    NSLog(@"@check");
}


//                          SWITCH AND DELEGATE STUFF

- (IBAction)switchfrompubtopri:(id)sender {
    if([puborpri.text isEqual:(@"Public")]){
        puborpri.text = @"Private";
    }else{
        puborpri.text = @"Public";
    }
}


- (IBAction)exit:(id)sender {
    [eventtxt resignFirstResponder];
    [dettext resignFirstResponder];
    [statetxt resignFirstResponder];
    [citytxt resignFirstResponder];
    [statetxt resignFirstResponder];
    [ziptxt resignFirstResponder];
    [nametxt resignFirstResponder];
}

//                                  DATABASE PREP
- (IBAction)CreateEvent:(id)sender {
    if(_monthlabel==NULL){
        _monthlabel = monthdata[0];
    }
    if(_daylabel==NULL){
        _daylabel = daydata[0];
    }
    if(_yearlabel==NULL){
        _yearlabel = yeardata[0];
    }
    if(_hourlabel==NULL){
        _hourlabel = hourdata[0];
    }
    if(_minlabel==NULL){
        _minlabel = mindata[0];
    }
    if(_ampmlabel==NULL){
        _ampmlabel = ampmdata[0];
    }
    NSString *x;
    //    if(streettxt.text!=NULL && citytxt.text!=NULL && statetxt.text!=NULL && ziptxt.text!=NULL){
    x = [NSString localizedStringWithFormat:@"%@ %@ %@ %@",streettxt.text,citytxt.text,statetxt.text,ziptxt.text];
    //    }else{
    
    //    }
    _loglatlabel = [[NSString alloc] init];
    _date = [NSString localizedStringWithFormat:@"%@/%@/%@ at %@:%@ %@",
             _monthlabel,_daylabel,_yearlabel,_hourlabel,_minlabel,_ampmlabel];

    
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder geocodeAddressString:x
              completionHandler: ^(NSArray *placemarks, NSError *error){
                  if (error){
                      _loglatlabel = @"error";
                      return;
                  }
                  
                  if(placemarks && placemarks>0){
                      CLPlacemark *placemark = placemarks[0];
                      CLLocation *location = placemark.location;
                      _coords = location.coordinate;
                      _point = [PFGeoPoint geoPointWithLatitude:_coords.latitude longitude:_coords.longitude];
                      [self cleanAddress];
                  }
              }];
    
    
}


-(void)cleanAddress{
    _cleanaddress = [[NSString alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:_coords.latitude longitude:_coords.longitude];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:loc
                completionHandler: ^(NSArray *placemarks, NSError *error){
                    if (error){
                        //  self.loglatlabel.text = @"error";
                        return;
                    }
                    
                    if(placemarks && placemarks>0){
                        CLPlacemark *placemark = placemarks[0];
                        NSDictionary *dic = placemark.addressDictionary;
                        NSString *address = [dic objectForKey:(NSString *) kABPersonAddressStreetKey];
                        NSString *city = [dic objectForKey:(NSString *) kABPersonAddressCityKey];
                        NSString *state = [dic objectForKey:(NSString *) kABPersonAddressStateKey];
                        NSString *zip = [dic objectForKey:(NSString *) kABPersonAddressZIPKey];
                        
                        _cleanaddress = [NSString localizedStringWithFormat:@"%@ %@, %@ %@",address,city,state, zip];
                        [self sendtodatabase];
                    }
                }];
    
}

-(void)sendtodatabase{
    NSLog(@"WHATT");
    if(self.event==NULL){
    PFObject *Event = [PFObject objectWithClassName:@"EventList"];
    Event[@"EventName"]=eventtxt.text;
    Event[@"Details"]=dettext.text;
    Event[@"LocationName"]=nametxt.text;
    Event[@"Address"]=_cleanaddress;
    Event[@"DateTime"]=_date;
    Event[@"CreatedBy"] = [PFUser currentUser];
    Event[@"Coordinates"] = _point;
    if ([puborpri.text isEqual:(@"Public")]) {
        Event[@"public"]=@"yes";
    }else{
        Event[@"public"]=@"no";
    }
    [Event save];
    PFObject *attend = [PFObject objectWithClassName:@"Attending"];
    attend[@"Attendee"]=[PFUser currentUser];
    attend[@"Event"]= Event;
    [attend save];
    }else{
        self.event[@"EventName"]=eventtxt.text;
        self.event[@"Details"]=dettext.text;
        self.event[@"LocationName"]=nametxt.text;
        self.event[@"Address"]=_cleanaddress;
        self.event[@"DateTime"]=_date;
        self.event[@"CreatedBy"] = [PFUser currentUser];
        self.event[@"Coordinates"] = _point;
        if ([puborpri.text isEqual:(@"Public")]) {
            self.event[@"public"]=@"yes";
        }else{
            self.event[@"public"]=@"no";
        }
        [self.event saveInBackground];

    }
}

//                              HANDLING KEYBOARD

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"this was called first");
    
    _originalInsets = UIEdgeInsetsMake(self.scroller.contentInset.top, self.scroller.contentInset.left, self.scroller.contentInset.bottom, self.scroller.contentInset.right);
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.scroller.contentInset.top, self.scroller.contentInset.left, kbSize.height+5, self.scroller.contentInset.right);
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"this was called");
    self.scroller.contentInset = _originalInsets;
    self.scroller.scrollIndicatorInsets = _originalInsets;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
