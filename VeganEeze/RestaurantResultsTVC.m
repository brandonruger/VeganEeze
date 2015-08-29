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
@synthesize arrayOfRestaurantObjs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup arrays w/ static data
    restaurantNames = [[NSArray alloc]initWithObjects:@"Ethos", @"Toasted", @"Dandelion Cafe", @"Loving Hut", nil];
    restaurantAddresses = [[NSArray alloc]initWithObjects:@"133 South St", @"2409 N Park Ave", @"849 East Orange Ln", @"9189 Apple Rd", nil];
    restaurantCityStates = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
    restaurantURLs = [[NSArray alloc]initWithObjects:@"www.ethosvegankitchen.com", @"www.igettoasted.com", @"www.dandelioncommunitea.com", @"www.lovinghut.us", nil];
    restaurantPhones = [[NSArray alloc]initWithObjects:@"727-401-2009", @"727-394-3928", @"727-293-1293", @"727-203-5039", nil];
    
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
        
        
        
        resultsCell.textLabel.text = [restaurantNames objectAtIndex:indexPath.row];
        resultsCell.detailTextLabel.text = [restaurantCityStates objectAtIndex:indexPath.row];
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
        //Get strings of restaurant's data from arrays
        NSString *restaurantNameStr = [restaurantNames objectAtIndex:indexOfCell.row];
        NSString *restaurantAddressStr = [restaurantAddresses objectAtIndex:indexOfCell.row];
        NSString *restaurantCityStateStr = [restaurantCityStates objectAtIndex:indexOfCell.row];
        NSString *restaurantURLStr = [restaurantURLs objectAtIndex:indexOfCell.row];
        NSString *restaurantPhoneStr = [restaurantPhones objectAtIndex:indexOfCell.row];
        
        //Pass the restaurant's information to the properties in the detail view
        restaurantDetailVC.restaurantName = restaurantNameStr;
        restaurantDetailVC.restaurantAddress = restaurantAddressStr;
        restaurantDetailVC.restaurantCityState = restaurantCityStateStr;
        restaurantDetailVC.restaurantURL = restaurantURLStr;
        restaurantDetailVC.restaurantPhoneNo = restaurantPhoneStr;
    }
    
}


@end
