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
        
        AlcoholBeverage *alcoholBevInfo = [arrayOfAlcoholBeverages objectAtIndex:indexPath.row];
        resultsCell.textLabel.text = alcoholBevInfo.alcoholName;
        resultsCell.detailTextLabel.text = alcoholBevInfo.veganOrNot;
    }
    
    //Alternate color for every other row
    if (indexPath.row %2 == 0) {
        
        UIColor *alternateColor=[[UIColor alloc]initWithRed:239.0/255.0 green:252.0/255.0 blue:214.0/255.0 alpha:1];
        resultsCell.backgroundColor = alternateColor;
    } else {
        UIColor *otherColor=[[UIColor alloc]initWithRed:162.0/255.0 green:201.0/255.0 blue:142.0/255.0 alpha:1];
        resultsCell.backgroundColor = otherColor;
    }
    
    
    return resultsCell;
}
@end
