//
//  FavoritePlacesTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "FavoritePlacesTVC.h"
#import "SavedPlacesDetailVC.h"
#import <Parse/Parse.h>

@interface FavoritePlacesTVC ()

@end

@implementation FavoritePlacesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    //Check if user is logged in
    PFUser *loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        //User is logged in
        //Initialize mutable array
        parseFavorites = [[NSMutableArray alloc]init];
        placeName = [[NSMutableArray alloc]init];
        placeCity = [[NSMutableArray alloc]init];
        objectIDs = [[NSMutableArray alloc]init];
        
        //Call method to retrieve objects from Parse server
        [self retrieveFavoritePlaces];
    } else {
        
        [objectIDs removeAllObjects];
        [placesTableView reloadData];
        
        //User is not logged in, alert user
        UIAlertView *logInAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must login in order to view your favorites" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [logInAlert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [objectIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"PlacesCell"];
    if (resultsCell != nil) {
        
        //NSArray *favoritePlaces = [[NSArray alloc]initWithObjects:@"Favorite Place 1", @"Favorite Place 2", @"Favorite Place 3", @"Favorite Place 4", nil];
        //NSArray *locations = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
        
        //Set cell labels to items stored in mutable arrays
        resultsCell.textLabel.text = [placeName objectAtIndex:indexPath.row];
        resultsCell.detailTextLabel.text = [placeCity objectAtIndex:indexPath.row];
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

#pragma mark - Parse

//Method to retrieve Favorite Places saved on Parse
- (void)retrieveFavoritePlaces {
    
    //Create a PFQuery to search for the data on Parse
    PFQuery *favoritePlaceQuery = [PFQuery queryWithClassName:@"FavoritePlace"];
    
    [favoritePlaceQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //No errors, found objects successfully
            
            //Loop through parse objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                //Get name of place from object
                NSString *favoritePlaceName = object[@"name"];
                //Get city of place from object
                NSString *favoritePlaceCity = object[@"city"];
                //Get object ID
                NSString *objectID = object.objectId;
                
                //Add objects to NSMutableArray
                //[parseFavorites addObject:object];
                
                //Add place names to array
                [placeName addObject:favoritePlaceName];
                //Add city to array
                [placeCity addObject:favoritePlaceCity];
                //Add object ID to array
                [objectIDs addObject:objectID];
            }
            
            //Refresh tableview
            [placesTableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Navigation

//Segue to pass data to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Access detail view controller
    SavedPlacesDetailVC *savedDetailsVC = segue.destinationViewController;
    if (savedDetailsVC != nil) {
        
        //Get cell that was clicked on
        UITableViewCell *cellClicked = (UITableViewCell*)sender;
        //Get index of cell that was clicked
        NSIndexPath *indexOfCell = [placesTableView indexPathForCell:cellClicked];
        NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
        //Get strings of restaurant's data from arrays
//        NSString *restaurantNameStr = [restaurantNames objectAtIndex:indexOfCell.row];
//        NSString *restaurantAddressStr = [restaurantAddresses objectAtIndex:indexOfCell.row];
//        NSString *restaurantCityStateStr = [restaurantCityStates objectAtIndex:indexOfCell.row];
//        NSString *restaurantURLStr = [restaurantURLs objectAtIndex:indexOfCell.row];
//        NSString *restaurantPhoneStr = [restaurantPhones objectAtIndex:indexOfCell.row];
        
        //Get object ID for item clicked on
        NSString *currentObjId = [objectIDs objectAtIndex:indexOfCell.row];
        
        //Pass the restaurant's information to the properties in the detail view
//        restaurantDetailVC.restaurantName = restaurantNameStr;
//        restaurantDetailVC.restaurantAddress = restaurantAddressStr;
//        restaurantDetailVC.restaurantCityState = restaurantCityStateStr;
//        restaurantDetailVC.restaurantURL = restaurantURLStr;
//        restaurantDetailVC.restaurantPhoneNo = restaurantPhoneStr;
        
        //Pass the object ID over to the detail view
        savedDetailsVC.objectId = currentObjId;
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
