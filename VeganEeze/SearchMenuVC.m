//
//  SearchMenuVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/12/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "SearchMenuVC.h"
#import <Parse/Parse.h>
#import "Reachability.h"

@interface SearchMenuVC ()

@end

@implementation SearchMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    settingsButton = self.navigationItem.leftBarButtonItem;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"mplus-1c-regular" size:21],
      NSFontAttributeName, nil]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Check if user is currently logged in
        PFUser *loggedInUser = [PFUser currentUser];
        if (loggedInUser) {
            //User is logged in, change login button to logout
            self.navigationItem.rightBarButtonItem.title = @"Logout";
            self.navigationItem.leftBarButtonItem = settingsButton;
            
        } else {
            self.navigationItem.rightBarButtonItem.title = @"Login";
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([sender tag] == 1) {
        //Login/logout button was pressed
        
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Login"]) {
            return YES;
        } else {
            //Call method to log user out
            [self logoutFromApp];
            
            return NO;
        }
        
    } else {
        return YES;
    }
    
}

-(void)logoutFromApp {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Log out of account
        [PFUser logOut];
        
        //Alert user they have been logged out
        UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"Logged Out" message:@"You have been logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //Show alert
        [logoutAlert show];
        
        //Change text on button back to "Login"
        self.navigationItem.rightBarButtonItem.title = @"Login";
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
    }
    
    
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

        
        return FALSE;
    }
}

@end
