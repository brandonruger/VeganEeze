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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Array of vegan resources
    
    //Set up vegan resource objects
    VeganResource *resource1 = [[VeganResource alloc]initWithResource:@"Peta" resourceURL:@"http://www.peta.org"];
    VeganResource *resource2 = [[VeganResource alloc]initWithResource:@"Vegan.com" resourceURL:@"http://www.vegan.com"];
    VeganResource *resource3 = [[VeganResource alloc]initWithResource:@"Vegan Society" resourceURL:@"http://www.vegansociety.com"];
    VeganResource *resource4 = [[VeganResource alloc]initWithResource:@"The Vegan RD" resourceURL:@"http://www.theveganrd.com"];
    
    //Create array to hold above resource objects
    resources = [[NSMutableArray alloc]initWithObjects:resource1, resource2, resource3, resource4, nil];
    
    
    //Array of URL's for resources
    //resources = [[NSArray alloc]initWithObjects:@"www.peta.org", @"www.vegan.com", @"www.vegansociety.com", @"www.theveganrd.com", nil];
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
        //resultsCell.backgroundColor = [UIColor clearColor];
        resourcesCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        //resultsCell.backgroundColor = [UIColor clearColor];
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
    
    //websiteAddress = [resources objectAtIndex:indexOfCell.row];
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass website's URL to web view
    webVC.websiteStr = resourceURL;
    
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
