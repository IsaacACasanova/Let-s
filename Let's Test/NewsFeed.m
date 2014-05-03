//
//  NewsFeed.m
//  Let's Test
//
//  Created by Alexander Buck on 2/16/14.
//  Copyright (c) 2014 Let's. All rights reserved.
//

#import "NewsFeed.h"
#import "NewsFeedCell.h"
#import "EventViewController.h"
#import "ProfileController3.h"
#import "CreateEvent.h"

@interface NewsFeed ()

@end

@implementation NewsFeed
@synthesize all,pub,pri;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"EventList"];
    if (self.userinfo!=NULL) {
        _Proback.title = @"Back";
        PFQuery *person = [PFQuery queryWithClassName:@"_User"];
        [person whereKey:@"username" equalTo:_userinfo];
        //need to know if i follow
        PFUser *curuser = [PFUser currentUser];
        NSString *cp = [curuser objectForKey:@"username"];
        
        
        PFQuery *amIFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        
        [amIFollowingQuery whereKey:@"Follower" equalTo:cp];
        [amIFollowingQuery whereKey:@"Following" equalTo:_userinfo];
        PFObject *yes = amIFollowingQuery.getFirstObject;
        if(yes==NULL&& ![cp isEqualToString: _userinfo]){
            self.state=1;
            self.all.enabled = NO;
            self.pri.enabled = NO;
            self.pub.enabled = NO;
        }
        
        
        
        
        
        if(self.state==0)/*all*/{
            [query whereKey:@"CreatedBy" equalTo:person.getFirstObject];
            [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
            [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
            [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
        }else if(self.state==1)/*public*/{
            [query whereKey:@"CreatedBy" equalTo:person.getFirstObject];
            [query whereKey:@"public" equalTo:@"yes"];
            [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
            [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
            [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
        }else/*private*/{
            [query whereKey:@"CreatedBy" equalTo:person.getFirstObject];
            [query whereKey:@"public" equalTo:@"no"];
            [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
            [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
            [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
        }
    }else if(self.person!=NULL){
        _Proback.title = @"Back";
        PFQuery *events = [PFQuery queryWithClassName:@"Attending"];
        [events whereKey:@"Attendee" equalTo:self.person];
        NSArray *eventarray = events.findObjects;
        //need to know if I follow
        
        PFUser *curuser = [PFUser currentUser];
        NSString *cp = [curuser objectForKey:@"username"];
        
        PFQuery *amIFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        NSString *p = [self.person objectForKey:@"username"];
        NSLog(@"CHECKing: %@",p);
        [amIFollowingQuery whereKey:@"Follower" equalTo:cp];
        [amIFollowingQuery whereKey:@"Following" equalTo:p];
        PFObject *yes = amIFollowingQuery.getFirstObject;
        if(yes==NULL&&![cp isEqualToString: p]){
            self.state=1;
            self.all.enabled = NO;
            self.pri.enabled = NO;
            self.pub.enabled = NO;
        }
        
        
        if(eventarray.count>0){
            NSMutableArray *myarray = [[NSMutableArray alloc] init];
            for(PFObject *object in eventarray){
                PFObject *event = [object objectForKey:@"Event"];
                [myarray addObject:event.objectId];
            }
            if(self.state==0)/*all*/{
                [query whereKey:@"objectId" containedIn:myarray];
                [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else if(self.state==1)/*public*/{
                [query whereKey:@"objectId" containedIn:myarray];
                [query whereKey:@"public" equalTo:@"yes"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else/*private*/{
                [query whereKey:@"objectId" containedIn:myarray];
                [query whereKey:@"public" equalTo:@"no"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
            }
        }
        
    }else{
        PFUser *user = [PFUser currentUser];
        [query whereKey:@"CreatedBy" notEqualTo:[PFUser currentUser]];
        
        PFQuery *findifIntable = [PFQuery queryWithClassName:@"Pass"];
        [findifIntable whereKey:@"Attendee" equalTo:user];
        PFQuery *findifIntable2 = [PFQuery queryWithClassName:@"Attending"];
        [findifIntable whereKey:@"Attendee" equalTo:user];
        [findifIntable2 whereKey:@"Attendee" equalTo:user];
        NSArray *objects = findifIntable.findObjects;
        NSArray *objects2 = findifIntable2.findObjects;
        //need to know I am following
        
        NSString *username = [user objectForKey:@"username"];
        PFQuery *iAmFollowingQuery = [PFQuery queryWithClassName:@"Follow"];
        [iAmFollowingQuery whereKey:@"Follower" equalTo:username];
        NSArray *userobj = iAmFollowingQuery.findObjects;
        
        
        
        
        
        if(objects2.count==0&&objects.count==0){
            if(self.state==0){
                [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else if(self.state==1){
                [query whereKey:@"public" equalTo:@"yes"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else{
                if(userobj.count>0){
                    NSArray *queryobjs = query.findObjects;
                    NSLog(@"COUNTQ %d",queryobjs.count);
                    
                    NSMutableArray *myarray = [[NSMutableArray alloc] init];
                    for (PFObject *object in userobj) {
                        NSString *follower = [object objectForKey:@"Following"];
                        NSLog(@"USERARRAY %@",follower);
                        [myarray addObject:follower];
                    }
                    
                    PFQuery *jibs = [PFQuery queryWithClassName:@"_User"];
                    [jibs whereKey:@"username" containedIn:myarray];
                    NSArray *follower1 =jibs.findObjects;
                    
                    if(follower1.count>0){
                        NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                        for (PFObject *object in follower1) {
                            NSLog(@"Fuck %@",object);
                            
                            PFQuery *eventq = [PFQuery queryWithClassName:@"EventList"];
                            [eventq whereKey:@"CreatedBy" equalTo:object];
                            NSArray *objectev = eventq.findObjects;
                            
                            if(objectev.count>0){
                                for(PFObject *object in objectev){
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                            
                        }
                        NSLog(@"COUNTD %d",queryobjs.count);
                        if(queryobjs.count>0){
                            // NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                            for (PFObject *object in queryobjs) {
                                NSString *public = [object objectForKey:@"public"];
                                NSLog(@"PUB %@",public);
                                if([public isEqualToString:@"yes"]){
                                    NSLog(@"THEFUCK");
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                        }
                        
                        [query whereKey:@"objectId" containedIn:queryarray];
                         [query whereKey:@"public" equalTo:@"no"];
                    }
                    
                }else{
                    [query whereKey:@"objectId" equalTo:@""];
                }
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
            }
            
            
        }else if(objects2.count>0&&objects.count==0){
            NSMutableArray *myarray = [[NSMutableArray alloc] init];
            for (PFObject *object in objects2) {
                PFObject *event = [object objectForKey:@"Event"];
                NSLog(@"ARRAY %@",event);
                [myarray addObject:event.objectId];
            }
            
            if(self.state==0)/*all*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else if(self.state==1)/*public*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [query whereKey:@"public" equalTo:@"yes"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else/*private*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                if(userobj.count>0){
                    NSArray *queryobjs = query.findObjects;
                    NSLog(@"COUNTQ %d",queryobjs.count);
                    
                    NSMutableArray *myarray = [[NSMutableArray alloc] init];
                    for (PFObject *object in userobj) {
                        NSString *follower = [object objectForKey:@"Following"];
                        NSLog(@"USERARRAY %@",follower);
                        [myarray addObject:follower];
                    }
                    
                    PFQuery *jibs = [PFQuery queryWithClassName:@"_User"];
                    [jibs whereKey:@"username" containedIn:myarray];
                    NSArray *follower1 =jibs.findObjects;
                    
                    if(follower1.count>0){
                        NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                        for (PFObject *object in follower1) {
                            NSLog(@"Fuck %@",object);
                            
                            PFQuery *eventq = [PFQuery queryWithClassName:@"EventList"];
                            [eventq whereKey:@"CreatedBy" equalTo:object];
                            NSArray *objectev = eventq.findObjects;
                            
                            if(objectev.count>0){
                                for(PFObject *object in objectev){
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                            
                        }
                        NSLog(@"COUNTD %d",queryobjs.count);
                        if(queryobjs.count>0){
                            // NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                            for (PFObject *object in queryobjs) {
                                NSString *public = [object objectForKey:@"public"];
                                NSLog(@"PUB %@",public);
                                if([public isEqualToString:@"yes"]){
                                    NSLog(@"THEFUCK");
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                        }
                        
                        [query whereKey:@"objectId" containedIn:queryarray];
                         [query whereKey:@"public" equalTo:@"no"];
                    }
                    
                }else{
                    [query whereKey:@"objectId" equalTo:@""];
                }
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
            }
            
        }else if(objects.count>0&&objects2.count>0){
            NSMutableArray *myarray = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                PFObject *event = [object objectForKey:@"Event"];
                NSLog(@"ARRAY %@",event);
                [myarray addObject:event.objectId];
            }
            for (PFObject *object in objects2) {
                PFObject *event = [object objectForKey:@"Event"];
                NSLog(@"ARRAY %@",event);
                [myarray addObject:event.objectId];
            }
            
            if(self.state==0)/*all*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else if(self.state==1)/*public*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [query whereKey:@"public" equalTo:@"yes"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else/*private*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                if(userobj.count>0){
                    NSArray *queryobjs = query.findObjects;
                    NSLog(@"COUNTQ %d",queryobjs.count);
                    
                    NSMutableArray *myarray = [[NSMutableArray alloc] init];
                    for (PFObject *object in userobj) {
                        NSString *follower = [object objectForKey:@"Following"];
                        NSLog(@"USERARRAY %@",follower);
                        [myarray addObject:follower];
                    }
                    
                    PFQuery *jibs = [PFQuery queryWithClassName:@"_User"];
                    [jibs whereKey:@"username" containedIn:myarray];
                    NSArray *follower1 =jibs.findObjects;
                    
                    if(follower1.count>0){
                        NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                        for (PFObject *object in follower1) {
                            NSLog(@"Fuck %@",object);
                            
                            PFQuery *eventq = [PFQuery queryWithClassName:@"EventList"];
                            [eventq whereKey:@"CreatedBy" equalTo:object];
                            NSArray *objectev = eventq.findObjects;
                            
                            if(objectev.count>0){
                                for(PFObject *object in objectev){
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                            
                        }
                        NSLog(@"COUNTD %d",queryobjs.count);
                        if(queryobjs.count>0){
                            // NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                            for (PFObject *object in queryobjs) {
                                NSString *public = [object objectForKey:@"public"];
                                NSLog(@"PUB %@",public);
                                if([public isEqualToString:@"yes"]){
                                    NSLog(@"THEFUCK");
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                        }
                        
                        [query whereKey:@"objectId" containedIn:queryarray];
                         [query whereKey:@"public" equalTo:@"no"];
                    }
                    
                }else{
                    [query whereKey:@"objectId" equalTo:@""];
                }
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
            }
            
        }else if(objects.count>0&&objects2.count==0){
            NSMutableArray *myarray = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                PFObject *event = [object objectForKey:@"Event"];
                NSLog(@"ARRAY %@",event);
                [myarray addObject:event.objectId];
            }
            
            if(self.state==0)/*all*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [self.all setImage:[UIImage imageNamed:@"allselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else if(self.state==1)/*public*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                [query whereKey:@"public" equalTo:@"yes"];
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"selectedpublic.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privatedeselected.png"] forState:UIControlStateNormal];
            }else/*private*/{
                [query whereKey:@"objectId" notContainedIn:myarray];
                if(userobj.count>0){
                    NSArray *queryobjs = query.findObjects;
                    NSLog(@"COUNTQ %d",queryobjs.count);
                    
                    NSMutableArray *myarray = [[NSMutableArray alloc] init];
                    for (PFObject *object in userobj) {
                        NSString *follower = [object objectForKey:@"Following"];
                        NSLog(@"USERARRAY %@",follower);
                        [myarray addObject:follower];
                    }
                    
                    PFQuery *jibs = [PFQuery queryWithClassName:@"_User"];
                    [jibs whereKey:@"username" containedIn:myarray];
                    NSArray *follower1 =jibs.findObjects;
                    
                    if(follower1.count>0){
                        NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                        for (PFObject *object in follower1) {
                            NSLog(@"Fuck %@",object);
                            
                            PFQuery *eventq = [PFQuery queryWithClassName:@"EventList"];
                            [eventq whereKey:@"CreatedBy" equalTo:object];
                            NSArray *objectev = eventq.findObjects;
                            
                            if(objectev.count>0){
                                for(PFObject *object in objectev){
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                            
                        }
                        NSLog(@"COUNTD %d",queryobjs.count);
                        if(queryobjs.count>0){
                            // NSMutableArray *queryarray = [[NSMutableArray alloc] init];
                            for (PFObject *object in queryobjs) {
                                NSString *public = [object objectForKey:@"public"];
                                NSLog(@"PUB %@",public);
                                if([public isEqualToString:@"yes"]){
                                    NSLog(@"THEFUCK");
                                    [queryarray addObject:object.objectId];
                                }
                            }
                            
                        }
                        
                        [query whereKey:@"objectId" containedIn:queryarray];
                        [query whereKey:@"public" equalTo:@"no"];
                    }
                    
                }else{
                    [query whereKey:@"objectId" equalTo:@""];
                }
                [self.all setImage:[UIImage imageNamed:@"alldeselected.png"] forState:UIControlStateNormal];
                [self.pub setImage:[UIImage imageNamed:@"publicdeselected.png"] forState:UIControlStateNormal];
                [self.pri setImage:[UIImage imageNamed:@"privateselected.png"] forState:UIControlStateNormal];
            }
            
        }
        
       



        
        
        
        
    }
    
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"NewsFeedCell";
    PFObject *obd = [object objectForKey:@"CreatedBy"];
    NSLog(@"%@",obd);
    NSLog(@"%@",obd.objectId);
    PFQuery *q = [PFQuery queryWithClassName:@"_User"];
    [q whereKey:@"objectId" equalTo:obd.objectId];
    PFObject *o = q.getFirstObject;
    PFFile *blah = [o objectForKey:@"image"];
    NSData *imageData = [blah getData];
    
    PFUser *user = [PFUser currentUser];
    
    PFQuery *findifIntable = [PFQuery queryWithClassName:@"Attending"];
    [findifIntable whereKey:@"Attendee" equalTo:user];
    [findifIntable whereKey:@"Event" equalTo:object];
    
    
    PFQuery *findifIntable2 = [PFQuery queryWithClassName:@"Pass"];
    [findifIntable2 whereKey:@"Attendee" equalTo:user];
    [findifIntable2 whereKey:@"Event" equalTo:object];
    
    
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleSubtitle
    //                                   reuseIdentifier:CellIdentifier];
    //    }
    
    
    // Configure the cell to show todo item with a priority at the bottom
    // cell.textLabel.text = [object objectForKey:@"Address"];
    cell.EventLabel.text = [object objectForKey:@"EventName"];
    cell.DecriptionLabel.text = [object objectForKey:@"Details"];
    cell.ProfileImage.image = [UIImage imageWithData:imageData];
    //cell.commentLabel.text = @"comment";
    cell.timeStamp.text = @"2 min ago";
    cell.dateLabel.text = [object objectForKey:@"DateTime"];
    if([obd.objectId isEqualToString: user.objectId]){
        NSLog(@"WHATTTTTTT");
        cell.LetsButton.hidden = YES;
        cell.PassButton.hidden = YES;
    }
    else{
        cell.EditButton.hidden = YES;
        cell.DeleteButton.hidden =YES;
    }
    
    [cell.LetsButton setImage:[UIImage imageNamed:@"deselectedlets.png"] forState:UIControlStateNormal];
    [cell.PassButton setImage:[UIImage imageNamed:@"deselectedpass.png"] forState:UIControlStateNormal];
    
    if(findifIntable.getFirstObject!=NULL){
        cell.thefuck =1;
        [cell.LetsButton setImage:[UIImage imageNamed:@"selectedlets.png"] forState:UIControlStateNormal];
        [cell.PassButton setImage:[UIImage imageNamed:@"deselectedpass.png"] forState:UIControlStateNormal];
        cell.LetsButton.enabled = NO;
    }
    
    if(findifIntable2.getFirstObject!=NULL){
        cell.thefuck =0;
        [cell.LetsButton setImage:[UIImage imageNamed:@"deselectedlets.png"] forState:UIControlStateNormal];
        [cell.PassButton setImage:[UIImage imageNamed:@"selectedpass.png"] forState:UIControlStateNormal];
        cell.PassButton.enabled = NO;
    }
    cell.event = object;
    cell.EditButton.tag = indexPath.row;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowEvent"]){
        
        EventViewController *eventViewController = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        PFObject *obd = [object objectForKey:@"CreatedBy"];
        PFQuery *q = [PFQuery queryWithClassName:@"_User"];
        [q whereKey:@"objectId" equalTo:obd.objectId];
        PFObject *o = q.getFirstObject;
        PFFile *blah = [o objectForKey:@"image"];
        NSData *imageData = [blah getData];
        
        eventViewController.DetailModal = @[[UIImage imageWithData:imageData],[object objectForKey:@"EventName"],[object objectForKey:@"DateTime"],[object objectForKey:@"Details"], @"2 min ago"];
        eventViewController.object = object;
        eventViewController.creator = o;
        eventViewController.profilePicture.image = [UIImage imageWithData:imageData];
    }
    else if([[segue identifier] isEqualToString:@"SelfProfileSegue"]){
        
        ProfileController3 *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        PFUser *current = [PFUser currentUser];
        NSString *username = current.username;
        [vc grabOtherUserInfo:username];
        
        
        
        
    }else if([[segue identifier] isEqualToString:@"Edit"]){
        CreateEvent *vc =  [segue destinationViewController];
        vc.event = self.event;
    }else if([[segue identifier] isEqualToString:@"All"]){
               NewsFeed *vc =  [segue destinationViewController];
                vc.event = self.event;
                vc.userinfo = self.userinfo;
                vc.person = self.person;
                vc.state = 0;
           }else if([[segue identifier] isEqualToString:@"Public"]){
                    NewsFeed *vc =  [segue destinationViewController];
                    vc.event = self.event;
                    vc.userinfo = self.userinfo;
                   vc.person = self.person;
                    vc.state = 1;
                }else if([[segue identifier] isEqualToString:@"Private"]){
                        NewsFeed *vc =  [segue destinationViewController];
                        vc.event = self.event;
                        vc.userinfo = self.userinfo;
                        vc.person = self.person;
                        vc.state =2;
            }
    
    
    
}



- (IBAction)allpressed:(id)sender {
    self.state = 0;
    [self viewDidLoad];
}

- (IBAction)publicpressed:(id)sender {
    self.state  = 1;
    [self viewDidLoad];
}
- (IBAction)privatepressed:(id)sender {
    self.state = 2;
    [self viewDidLoad];
}



- (IBAction)editPressed:(UIButton *)sender {
    NSLog(@"TAG: %d",sender.tag);
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    self.event = object;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_Proback setTarget:self];
    [_Proback setAction:@selector(probackmeth:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)probackmeth:(UIStoryboardSegue *)sender{
    if(self.userinfo==NULL&&self.person==NULL){
        [self performSegueWithIdentifier:@"SelfProfileSegue" sender:sender];
    }else{
        //go back to profile
        [self performSegueWithIdentifier:@"Return" sender:sender];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end