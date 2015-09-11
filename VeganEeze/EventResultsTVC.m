//
//  EventResultsTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EventResultsTVC.h"
#import "EventDetailVC.h"
#import "VeganEvent.h"
#import "EventResultCell.h"

@interface EventResultsTVC ()

@end

@implementation EventResultsTVC
@synthesize arrayOfEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup arrays w/ static data
//    eventNames = [[NSArray alloc]initWithObjects:@"Veg Festival", @"Vegan Fair", @"Dinner Theater", @"VegFestUK", nil];
//    eventAddresses = [[NSArray alloc]initWithObjects:@"133 South St", @"2409 N Park Ave", @"849 East Orange Ln", @"9189 Apple Rd", nil];
//    eventCityStates = [[NSArray alloc]initWithObjects:@"Winter Park, FL", @"Orlando, FL", @"Altamonte Springs, FL", @"Casselberry, FL", nil];
//    eventURLs = [[NSArray alloc]initWithObjects:@"www.cfvegfest.org", @"www.veganstreetfair.com", @"www.sleuths.com", @"www.vegfest.co.uk", nil];
//    eventPhones = [[NSArray alloc]initWithObjects:@"727-401-2009", @"727-394-3928", @"727-293-1293", @"727-203-5039", nil];
    
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
    
    return [arrayOfEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
//    if (resultsCell != nil) {
//        
//        VeganEvent *veganEventInfo = [arrayOfEvents objectAtIndex:indexPath.row];
//        
//        resultsCell.textLabel.text = veganEventInfo.eventName;
//        resultsCell.detailTextLabel.text = veganEventInfo.eventCity;
//    }
    
    EventResultCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    if (eventCell != nil) {
        VeganEvent *currentEvent = [arrayOfEvents objectAtIndex:indexPath.row];
        
        //Call cell's custom method to update information in cell
        [eventCell updateCellWithEvent:currentEvent.eventName location:currentEvent.eventCity imageURL:currentEvent.eventImageURL date:currentEvent.eventStartTime];
    }
    
    //Alternate color for every other row
    if (indexPath.row %2 == 0) {
        
        UIColor *alternateColor=[[UIColor alloc]initWithRed:239.0/255.0 green:252.0/255.0 blue:214.0/255.0 alpha:1];
        //resultsCell.backgroundColor = [UIColor clearColor];
        eventCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        //resultsCell.backgroundColor = [UIColor clearColor];
        eventCell.backgroundColor = otherColor;
    }
    
    return eventCell;
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
        
        //Get current event object to pass over to detail view
        VeganEvent *eventClicked = [arrayOfEvents objectAtIndex:indexOfCell.row];
        
        //Pass over event object to detail view
        eventDetailsVC.currentEvent = eventClicked;
        
        
//        NSLog(@"indexOfCell = %ld", (long)indexOfCell.row);
//        //Get strings of event's data from arrays
//        NSString *eventNameStr = [eventNames objectAtIndex:indexOfCell.row];
//        NSString *eventAddressStr = [eventAddresses objectAtIndex:indexOfCell.row];
//        NSString *eventCityStateStr = [eventCityStates objectAtIndex:indexOfCell.row];
//        NSString *eventURLStr = [eventURLs objectAtIndex:indexOfCell.row];
//        NSString *eventPhoneStr = [eventPhones objectAtIndex:indexOfCell.row];
//        
//        //Pass the event's information to the properties in the detail view
//        eventDetailsVC.eventName = eventNameStr;
//        eventDetailsVC.eventAddress = eventAddressStr;
//        eventDetailsVC.eventCityState = eventCityStateStr;
//        eventDetailsVC.eventURL = eventURLStr;
//        eventDetailsVC.eventPhoneNo = eventPhoneStr;
    }
    
}

@end
