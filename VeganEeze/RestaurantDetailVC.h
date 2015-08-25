//
//  RestaurantDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

{
  
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *cityStateLabel;
    IBOutlet UIButton *urlLabel;
    IBOutlet UILabel *phoneLabel;
    
    IBOutlet UITextView *phoneNoTV;
    
    IBOutlet UITableView *commentsTV;
    NSArray *usernames;
    NSArray *comments;
    
}

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *restaurantAddress;
@property (nonatomic, strong) NSString *restaurantCityState;
@property (nonatomic, strong) NSString *restaurantURL;
@property (nonatomic, strong) NSString *restaurantPhoneNo;






@end
