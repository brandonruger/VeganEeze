//
//  BeverageResultsTVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/20/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "BeverageResultsTVC.h"
#import "AlcoholBeverage.h"

@interface BeverageResultsTVC ()

@end

@implementation BeverageResultsTVC
@synthesize arrayOfAlcoholBeverages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //Initalize mutable array
    //arrayOfAlcoholBeverages = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayOfAlcoholBeverages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *resultsCell = [tableView dequeueReusableCellWithIdentifier:@"BeverageCell"];
    if (resultsCell != nil) {
        
//        NSArray *beverageArray = [[NSArray alloc]initWithObjects:@"Barefoot Moscato", @"Riunite Moscato", @"Another Moscato", @"Last Moscato", nil];
//        NSArray *veganArray = [[NSArray alloc]initWithObjects:@"Vegan", @"Not Vegan", @"May Be Vegan", @"Vegan", nil];
//        
//        resultsCell.textLabel.text = [beverageArray objectAtIndex:indexPath.row];
//        resultsCell.detailTextLabel.text = [veganArray objectAtIndex:indexPath.row];
        
        AlcoholBeverage *alcoholBevInfo = [arrayOfAlcoholBeverages objectAtIndex:indexPath.row];
        resultsCell.textLabel.text = alcoholBevInfo.alcoholName;
        resultsCell.detailTextLabel.text = alcoholBevInfo.veganOrNot;
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
