//
//  EventDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EventDetailVC.h"
#import "WebVC.h"

@interface EventDetailVC ()

@end

@implementation EventDetailVC
@synthesize eventName, eventAddress, eventCityState, eventPhoneNo, eventURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set event labels to display information passed over from segue
    eventNameLabel.text = eventName;
    eventAddressLabel.text = eventAddress;
    eventCityStateLabel.text = eventCityState;
    eventPhoneLabel.text = eventPhoneNo;
    
    //Set URL button text
    [eventUrlLabel setTitle:eventURL forState:UIControlStateNormal];
    
}

#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass restaurant's URL to web view
    webVC.websiteStr = eventURL;
    
}

@end
