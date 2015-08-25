//
//  RestaurantDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RestaurantDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

{
  
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *cityStateLabel;
    IBOutlet UIButton *urlLabel;
    IBOutlet UILabel *phoneLabel;
    
    IBOutlet UITextView *phoneNoTV;
    
    IBOutlet UITableView *commentsTV;
    NSMutableArray *usernames;
    NSMutableArray *comments;
    
    //IBOutlet UIButton *addNewComment;
    PFUser *currentUser;
    
}

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *restaurantAddress;
@property (nonatomic, strong) NSString *restaurantCityState;
@property (nonatomic, strong) NSString *restaurantURL;
@property (nonatomic, strong) NSString *restaurantPhoneNo;






@end
