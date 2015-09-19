//
//  PlacesToVisitTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "PlacesToVisitTVC.h"
#import "SavedPlacesDetailVC.h"
#import <Parse/Parse.h>
#import "ViewController.h"

@interface PlacesToVisitTVC ()

@end

@implementation PlacesToVisitTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    placeName = [[NSMutableArray alloc]init];
//    placeCity = [[NSMutableArray alloc]init];
//    objectIDs = [[NSMutableArray alloc]init];
    

}

-(void) viewWillAppear:(BOOL)animated {
    //Check if user is logged in
    PFUser *loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        //User is logged in
        //Initialize mutable array
        parsePlacesToVisit = [[NSMutableArray alloc]init];
//        placeName = [[NSMutableArray alloc]init];
//        placeCity = [[NSMutableArray alloc]init];
//        objectIDs = [[NSMutableArray alloc]init];
        
        //Call method to retrieve objects from Parse server
        [self retrievePlacesToVisit];

    } else {
        //[objectIDs removeAllObjects];
        [parsePlacesToVisit removeAllObjects];
        [placesToVisitTV reloadData];
        
        //User is not logged in, alert user
        UIAlertView *logInAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must login in order to view your saved places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [logInAlert show];
        
        //Take user to login screen
        ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //Instantiate view controller
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [parsePlacesToVisit count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"ToVisitCell"];
    if (resultsCell != nil) {
        
        //NSArray *placesToVisit = [[NSArray alloc]initWithObjects:@"Place 1", @"Place 2", @"Place 3", @"Place 4", nil];
        //NSArray *locations = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
        
        PFObject *currentPlace = [parsePlacesToVisit objectAtIndex:indexPath.row];
        
        resultsCell.textLabel.text = currentPlace[@"name"];
        resultsCell.detailTextLabel.text = currentPlace[@"city"];
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

//Method called when delete button is pressed
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Check to make sure tableview is in delete mode
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //TV is in delete mode
        
        //Remove the object from Parse database
        //PFQuery *retrieveObj = [PFQuery queryWithClassName:@"FavoritePlace"];
        //PFObject *objToDelete = [retrieveObj getObjectWithId:[objectIDs objectAtIndex:indexPath.row]];
        PFObject *objToDelete = [parsePlacesToVisit objectAtIndex:indexPath.row];
        [objToDelete deleteInBackground];
        //Remove object from Array
        [parsePlacesToVisit removeObjectAtIndex:indexPath.row];
        
        
        //Remote the row from the tableview
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [placesToVisitTV reloadData];
    }
}

//Dynamically put tableview in edit mode
-(IBAction)editTableView:(id)sender {
    placesToVisitTV.editing = !placesToVisitTV.isEditing;
}

#pragma mark - Parse

//Method to retrieve Places to Visit saved on Parse
- (void)retrievePlacesToVisit {
    
    //Create a PFQuery to search for the data on Parse
    PFQuery *placeToVisitQuery = [PFQuery queryWithClassName:@"PlaceToVisit"];
    
    [placeToVisitQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //No errors, found objects successfully
            
            //Loop through parse objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                [parsePlacesToVisit addObject:object];
                
//                //Get name of place from object
//                NSString *placeToVisitName = object[@"name"];
//                //Get city/state of place from object
//                NSString *placeToVisitCityState = object[@"city"];
//                //Get object ID
//                NSString *objectID = object.objectId;
//                
//                //Add objects to NSMutableArray
//                //[parseFavorites addObject:object];
//                
//                //Add place names to array
//                [placeName addObject:placeToVisitName];
//                //Add city/state to array
//                [placeCity addObject:placeToVisitCityState];
//                //Add object ID to array
//                [objectIDs addObject:objectID];
            }
            
            //Refresh tableview
            [placesToVisitTV reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Navigation

//Segue to pass data to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"placesToSavedSegue"]) {
        //Access detail view controller
        SavedPlacesDetailVC *savedDetailsVC = segue.destinationViewController;
        if (savedDetailsVC != nil) {
            
            //Get cell that was clicked on
            UITableViewCell *cellClicked = (UITableViewCell*)sender;
            //Get index of cell that was clicked
            NSIndexPath *indexOfCell = [placesToVisitTV indexPathForCell:cellClicked];
            NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
            
            //Get object ID for item clicked on
            //NSString *currentObjId = [objectIDs objectAtIndex:indexOfCell.row];
            PFObject *currentObj = [parsePlacesToVisit objectAtIndex:indexOfCell.row];
            NSString *currentObjId = currentObj[@"objectId"];
            
            //Pass the object ID over to the detail view
            savedDetailsVC.objectId = currentObjId;
        }
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
