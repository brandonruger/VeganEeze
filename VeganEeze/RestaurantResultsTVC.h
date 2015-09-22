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

}

@property (nonatomic, strong) NSMutableArray *arrayOfRestaurantObjs;


@end
