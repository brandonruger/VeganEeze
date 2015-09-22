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
        //resultsCell.backgroundColor = [UIColor clearColor];
        resultsCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        //resultsCell.backgroundColor = [UIColor clearColor];
        resultsCell.backgroundColor = otherColor;
    }
    
    return resultsCell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//Segue to pass data to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Access detail view controller
    RestaurantDetailVC *restaurantDetailVC = segue.destinationViewController;
    if (restaurantDetailVC != nil) {
        
        //Get cell that was clicked on
        UITableViewCell *cellClicked = (UITableViewCell*)sender;
        //Get index of cell that was clicked
        NSIndexPath *indexOfCell = [resultsTV indexPathForCell:cellClicked];
        //NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
        
        //Get current restaurant object from Array to pass over to detail view
        VeganRestaurant *restaurantClicked = [arrayOfRestaurantObjs objectAtIndex:indexOfCell.row];
        
        //Pass over restaurant object
        restaurantDetailVC.currentRestaurant = restaurantClicked;
        
//        //Get strings of restaurant's data from arrays
//        NSString *restaurantNameStr = [restaurantNames objectAtIndex:indexOfCell.row];
//        NSString *restaurantAddressStr = [restaurantAddresses objectAtIndex:indexOfCell.row];
//        NSString *restaurantCityStateStr = [restaurantCityStates objectAtIndex:indexOfCell.row];
//        NSString *restaurantURLStr = [restaurantURLs objectAtIndex:indexOfCell.row];
//        NSString *restaurantPhoneStr = [restaurantPhones objectAtIndex:indexOfCell.row];
//        
//        //Pass the restaurant's information to the properties in the detail view
//        restaurantDetailVC.restaurantName = restaurantNameStr;
//        restaurantDetailVC.restaurantAddress = restaurantAddressStr;
//        restaurantDetailVC.restaurantCityState = restaurantCityStateStr;
//        restaurantDetailVC.restaurantURL = restaurantURLStr;
//        restaurantDetailVC.restaurantPhoneNo = restaurantPhoneStr;
    }
    
}


@end
