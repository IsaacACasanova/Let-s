//
//  LetsCommentsTableViewController.h
//  LetsComments
//
//  Created by Isaac  Casanova on 3/31/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LetsCommentsTableViewController : PFQueryTableViewController

@property (strong, nonatomic) UITableView *dataTableView;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) NSMutableArray *thumbnails;

@property (strong, nonatomic) NSMutableArray *userName;

@property (strong, nonatomic) NSMutableArray *time;

@property (strong, nonatomic) PFObject *object;

@end