//
//  RestaurantResultsTVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantResultsTVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>

{
    IBOutlet UITableView *resultsTV;
    
    NSArray *restaurantNames;
    NSArray *restaurantAddresses;
    NSArray *restaurantCityStates;
    NSArray *restaurantURLs;
    NSArray *restaurantPhones;
}

@property (nonatomic, strong) NSMutableArray *arrayOfRestaurantObjs;


@end
