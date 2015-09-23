//
//  WebVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/21/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "WebVC.h"
#import "Reachability.h"

@interface WebVC ()

@end

@implementation WebVC
@synthesize websiteStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"URL = %@", websiteStr);
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Create URL object
        NSURL *restaurantURL = [[NSURL alloc]initWithString:websiteStr];
        if (restaurantURL != nil) {
            //Create NSURLRequest for launching website
            NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:restaurantURL];
            if (urlRequest != nil) {
                //Launch web page in web view
                [webView loadRequest:urlRequest];
            }
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method to check if network is connected
- (BOOL) isNetworkConnected
{
    Reachability *currentConnection = [Reachability reachabilityForInternetConnection];
    if ([currentConnection isReachable]) {
        //Network connection active, return true
        NSLog(@"Network connection is active");
        return TRUE;
    } else {
        //No network connection
        NSLog(@"Network connection is inactive");
        
        //Alert user
        UIAlertController *noConnection = [UIAlertController alertControllerWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noConnection addAction:defaultOk];
        //Show alert
        [self presentViewController:noConnection animated:YES completion:nil];
        
        return FALSE;
    }
}

@end
