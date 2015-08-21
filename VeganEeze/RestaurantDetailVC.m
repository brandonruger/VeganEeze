//
//  RestaurantDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantDetailVC.h"

@interface RestaurantDetailVC ()

@end

@implementation RestaurantDetailVC
@synthesize restaurantName, restaurantAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set restaurant name/address labels to display information passed over through segue
    nameLabel.text = restaurantName;
    addressLabel.text = restaurantAddress;
}


//#pragma mark - Navigation
//
////Segue method to pass information to detail view
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    
//}

@end
