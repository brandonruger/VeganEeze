//
//  RestaurantResultsTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantResultsTVC.h"
#import "RestaurantDetailVC.h"

@interface RestaurantResultsTVC ()

@end

@implementation RestaurantResultsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfRestaurantNames = [[NSArray alloc]initWithObjects:@"Ethos", @"Toasted", @"Dandelion Cafe", @"Loving Hut", nil];
    restaurantLocations = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    if (resultsCell != nil) {
        
        
        
        resultsCell.textLabel.text = [arrayOfRestaurantNames objectAtIndex:indexPath.row];
        resultsCell.detailTextLabel.text = [restaurantLocations objectAtIndex:indexPath.row];
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
        NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
        //Get strings of restaurants name/location from array
        NSString *restaurantNameStr = [arrayOfRestaurantNames objectAtIndex:indexOfCell.row];
        NSString *restaurantLocStr = [restaurantLocations objectAtIndex:indexOfCell.row];
        //Pass the restaurant's name/location to the properties in the detail view
        restaurantDetailVC.restaurantName = restaurantNameStr;
        restaurantDetailVC.restaurantAddress = restaurantLocStr;
    }
    
}


@end
