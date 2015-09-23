//
//  VeganResourcesTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganResourcesTVC.h"
#import "WebVC.h"
#import "VeganResource.h"

@interface VeganResourcesTVC ()

@end

@implementation VeganResourcesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up vegan resource objects
    VeganResource *resource1 = [[VeganResource alloc]initWithResource:@"Peta" resourceURL:@"http://www.peta.org"];
    VeganResource *resource2 = [[VeganResource alloc]initWithResource:@"Vegan.com" resourceURL:@"http://www.vegan.com"];
    VeganResource *resource3 = [[VeganResource alloc]initWithResource:@"Vegan Society" resourceURL:@"http://www.vegansociety.com"];
    VeganResource *resource4 = [[VeganResource alloc]initWithResource:@"The Vegan RD" resourceURL:@"http://www.theveganrd.com"];
    VeganResource *resource5 = [[VeganResource alloc]initWithResource:@"VeganEeze's Facebook" resourceURL:@"https://m.facebook.com/veganeeze"];
    VeganResource *resource6 = [[VeganResource alloc]initWithResource:@"Vegan Outreach" resourceURL:@"http://www.veganoutreach.org"];
    VeganResource *resource7 = [[VeganResource alloc]initWithResource:@"I Love Vegan" resourceURL:@"http://www.ilovevegan.com"];
    VeganResource *resource8 = [[VeganResource alloc]initWithResource:@"Vegan Bits" resourceURL:@"http://veganbits.com"];
    VeganResource *resource9 = [[VeganResource alloc]initWithResource:@"VegSource" resourceURL:@"http://www.vegsource.com"];
    VeganResource *resource10 = [[VeganResource alloc]initWithResource:@"Vegan Action" resourceURL:@"http://vegan.org"];
    VeganResource *resource11 = [[VeganResource alloc]initWithResource:@"Vegan Stoner" resourceURL:@"http://theveganstoner.blogspot.com"];
    
    //Create array to hold above resource objects
    resources = [[NSMutableArray alloc]initWithObjects:resource1, resource2, resource3, resource4, resource5, resource6, resource7, resource8, resource9, resource10, resource11, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [resources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resourcesCell = [tableView dequeueReusableCellWithIdentifier:@"ResourceCell"];
    if (resourcesCell != nil) {
        
        //Get current resource object from array of objects
        VeganResource *currentResource = [resources objectAtIndex:indexPath.row];
        
        resourcesCell.textLabel.text = currentResource.name;
    }
    
    //Alternate color for every other row
    if (indexPath.row %2 == 0) {
        
        UIColor *alternateColor=[[UIColor alloc]initWithRed:239.0/255.0 green:252.0/255.0 blue:214.0/255.0 alpha:1];
        resourcesCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        resourcesCell.backgroundColor = otherColor;
    }
    
    return resourcesCell;
}

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    //Get cell that was clicked on
    UITableViewCell *cellClicked = (UITableViewCell*)sender;
    //Get index of cell that was clicked
    NSIndexPath *indexOfCell = [resourcesTV indexPathForCell:cellClicked];
    
    //Get instance of VeganResource object
    VeganResource *currentResource = [resources objectAtIndex:indexOfCell.row];
    NSLog(@"index of cell = %ld", (long)indexOfCell.row);
    NSString *resourceURL = currentResource.url;
    NSLog(@"resourceURL = %@", resourceURL);
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass website's URL to web view
    webVC.websiteStr = resourceURL;
    
}

@end
