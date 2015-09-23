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
    
    
    EventResultCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    if (eventCell != nil) {
        VeganEvent *currentEvent = [arrayOfEvents objectAtIndex:indexPath.row];
        
        //Call cell's custom method to update information in cell
        [eventCell updateCellWithEvent:currentEvent.eventName location:currentEvent.eventCity imageURL:currentEvent.eventImageURL date:currentEvent.eventStartTime];
    }
    
    //Alternate color for every other row
    if (indexPath.row %2 == 0) {
        
        UIColor *alternateColor=[[UIColor alloc]initWithRed:239.0/255.0 green:252.0/255.0 blue:214.0/255.0 alpha:1];
        eventCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        eventCell.backgroundColor = otherColor;
    }
    
    return eventCell;
}

#pragma mark - Navigation

//Segue to pass data to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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
        
    }
    
}

@end
