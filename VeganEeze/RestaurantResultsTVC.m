//
//  RestaurantResultsTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantResultsTVC.h"
#import "RestaurantDetailVC.h"
#import "VeganRestaurant.h"
#import "RestaurantResultCell.h"

@interface RestaurantResultsTVC ()

@end

@implementation RestaurantResultsTVC
@synthesize arrayOfRestaurantObjs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayOfRestaurantObjs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantResultCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    if (resultsCell != nil) {
        VeganRestaurant *currentRest = [arrayOfRestaurantObjs objectAtIndex:indexPath.row];
        
        //Call cell's custom method to update information in cell
        [resultsCell updateCellWithRestaurant:currentRest.restaurantName description:currentRest.description range:currentRest.priceRange imageURI:currentRest.imageURI veganImage:currentRest.vegLevel city:currentRest.restaurantCity];
    }
    
    //Alternate color for every other row
    if (indexPath.row %2 == 0) {
        
        UIColor *alternateColor=[[UIColor alloc]initWithRed:239.0/255.0 green:252.0/255.0 blue:214.0/255.0 alpha:1];
        resultsCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        resultsCell.backgroundColor = otherColor;
    }
    
    return resultsCell;
}

#pragma mark - Navigation

//Segue to pass data to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access detail view controller
    RestaurantDetailVC *restaurantDetailVC = segue.destinationViewController;
    if (restaurantDetailVC != nil) {
        
        //Get cell that was clicked on
        UITableViewCell *cellClicked = (UITableViewCell*)sender;
        //Get index of cell that was clicked
        NSIndexPath *indexOfCell = [resultsTV indexPathForCell:cellClicked];
        
        //Get current restaurant object from Array to pass over to detail view
        VeganRestaurant *restaurantClicked = [arrayOfRestaurantObjs objectAtIndex:indexOfCell.row];
        
        //Pass over restaurant object
        restaurantDetailVC.currentRestaurant = restaurantClicked;
        
    }
    
}


@end
