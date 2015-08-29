//
//  BeverageResultsTVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeverageResultsTVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>

{
    NSString *alcoholBeverageName;
    NSString *alcoholBeverageBrand;
    NSString *alcoholBeverageVeganStatus;
    
    //Array to hold beverage custom objects
    
}

@property (nonatomic, strong) NSMutableArray *arrayOfAlcoholBeverages;

@end
