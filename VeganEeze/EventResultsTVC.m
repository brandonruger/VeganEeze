//
//  EventResultsTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EventResultsTVC.h"
#import "EventDetailVC.h"

@interface EventResultsTVC ()

@end

@implementation EventResultsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup arrays w/ static data
    eventNames = [[NSArray alloc]initWithObjects:@"Veg Festival", @"Vegan Fair", @"Dinner Theater", @"Celebration", nil];
    eventAddresses = [[NSArray alloc]initWithObjects:@"133 South St", @"2409 N Park Ave", @"849 East Orange Ln", @"9189 Apple Rd", nil];
    eventCityStates = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
    eventURLs = [[NSArray alloc]initWithObjects:@"www.ethos.com", @"www.toasted.com", @"www.dandelion.com", @"www.lovinghut.com", nil];
    eventPhones = [[NSArray alloc]initWithObjects:@"727-401-2009", @"727-394-3928", @"727-293-1293", @"727-203-5039", nil];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    if (resultsCell != nil) {
        
        
        
        resultsCell.textLabel.text = [eventNames objectAtIndex:indexPath.row];
        resultsCell.detailTextLabel.text = [eventCityStates objectAtIndex:indexPath.row];
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
    EventDetailVC *eventDetailsVC = segue.destinationViewController;
    if (eventDetailsVC != nil) {
        
        //Get cell that was clicked on
        UITableViewCell *cellClicked = (UITableViewCell*)sender;
        //Get index of cell that was clicked
        NSIndexPath *indexOfCell = [eventResultsTV indexPathForCell:cellClicked];
        NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
        //Get strings of event's data from arrays
        NSString *eventNameStr = [eventNames objectAtIndex:indexOfCell.row];
        NSString *eventAddressStr = [eventAddresses objectAtIndex:indexOfCell.row];
        NSString *eventCityStateStr = [eventCityStates objectAtIndex:indexOfCell.row];
        NSString *eventURLStr = [eventURLs objectAtIndex:indexOfCell.row];
        NSString *eventPhoneStr = [eventPhones objectAtIndex:indexOfCell.row];
        
        //Pass the event's information to the properties in the detail view
        eventDetailsVC.eventName = eventNameStr;
        eventDetailsVC.eventAddress = eventAddressStr;
        eventDetailsVC.eventCityState = eventCityStateStr;
        eventDetailsVC.eventURL = eventURLStr;
        eventDetailsVC.eventPhoneNo = eventPhoneStr;
    }
    
}

@end
