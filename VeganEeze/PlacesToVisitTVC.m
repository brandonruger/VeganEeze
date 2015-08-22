//
//  PlacesToVisitTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "PlacesToVisitTVC.h"

@interface PlacesToVisitTVC ()

@end

@implementation PlacesToVisitTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Initialize mutable array
    parsePlacesToVisit = [[NSMutableArray alloc]init];
    placeName = [[NSMutableArray alloc]init];
    placeCityState = [[NSMutableArray alloc]init];
    objectIDs = [[NSMutableArray alloc]init];
    
    //Call method to retrieve objects from Parse server
    [self retrievePlacesToVisit];
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
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"ToVisitCell"];
    if (resultsCell != nil) {
        
        //NSArray *placesToVisit = [[NSArray alloc]initWithObjects:@"Place 1", @"Place 2", @"Place 3", @"Place 4", nil];
        //NSArray *locations = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
        
        resultsCell.textLabel.text = [placeName objectAtIndex:indexPath.row];
        resultsCell.detailTextLabel.text = [placeCityState objectAtIndex:indexPath.row];
    }
    
    return resultsCell;
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
                
                //Get name of place from object
                NSString *placeToVisitName = object[@"name"];
                //Get city/state of place from object
                NSString *placeToVisitCityState = object[@"cityState"];
                //Get object ID
                NSString *objectID = object.objectId;
                
                //Add objects to NSMutableArray
                //[parseFavorites addObject:object];
                
                //Add place names to array
                [placeName addObject:placeToVisitName];
                //Add city/state to array
                [placeCityState addObject:placeToVisitCityState];
                //Add object ID to array
                [objectIDs addObject:objectID];
            }
            
            //Refresh tableview
            [placesToVisitTV reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
