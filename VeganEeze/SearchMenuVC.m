//
//  SearchMenuVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/12/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "SearchMenuVC.h"
#import <Parse/Parse.h>

@interface SearchMenuVC ()

@end

@implementation SearchMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Hide back button on navigation bar
    //self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.leftBarButtonItem = nil;
    
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
    //Check if user is currently logged in
    PFUser *loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        //User is logged in, change login button to logout
        self.navigationItem.rightBarButtonItem.title = @"Logout";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Login";
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
    
//    if ([identifier isEqualToString:@"segueToLogin"]) {
//        //Check button text
//        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Login"]) {
//            return YES;
//            
//        } else {
//            
//            //Call method to log user out
//            [self logoutFromApp];
//            
//            return NO;
//        }
//    } else {
//        return YES;
//    }
    
}

-(void)logoutFromApp {
    
    //Log out of account
    [PFUser logOut];
    
    //Alert user they have been logged out
    UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"Logged Out" message:@"You have been logged out." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //Show alert
    [logoutAlert show];
    
    //Change text on button back to "Login"
    self.navigationItem.rightBarButtonItem.title = @"Login";
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
