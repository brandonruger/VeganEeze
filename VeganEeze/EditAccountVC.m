//
//  EditAccountVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/16/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EditAccountVC.h"
#import "Reachability.h"

@interface EditAccountVC ()

@end

@implementation EditAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set textfields' delegate
    selectUsername.delegate = self;
    selectPassword.delegate = self;
    confirmPassword.delegate = self;
    enterEmail.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        
        //Get user info from Parse
        loggedInUser = [PFUser currentUser];
        
        NSString *currentUsername = loggedInUser.username;
        NSString *currentEmail = loggedInUser.email;
        
        //Load text fields with above data
        selectUsername.text = currentUsername;
        enterEmail.text = currentEmail;
    } else {
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to edit your account. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)editAccountInfo:(id)sender {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Get username entered
        username = selectUsername.text;
        
        //Check to make sure username wasn't blank
        if ([username isEqualToString:@""]) {
            //Alert user they must enter a username
            UIAlertView *usernameAlert = [[UIAlertView alloc]initWithTitle:@"Username error" message:@"Username cannot be blank. Please enter a username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [usernameAlert show];
            
            
        } else {
            
            
            //Check email address
            emailAddress = enterEmail.text;
            if ([emailAddress isEqualToString:@""]) {
                //Email address field is blank, alert user
                UIAlertView *emailAlert =[[UIAlertView alloc]initWithTitle:@"Email error" message:@"Email address cannot be blank. Please enter your email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [emailAlert show];
                
            } else {
                
                //Email address was entered
                
                //Update user's profile with information entered
                loggedInUser.username = username;
                loggedInUser.email = emailAddress;
                
                
                //Check to see if user entered in a new password
                password = selectPassword.text;
                secondPassword = confirmPassword.text;
                if ([password isEqualToString:@""]) {
                    //Check if there is a password in the second field
                    if ([secondPassword isEqualToString:@""]) {
                        //Both passwords are blank, user does not want to change password
                        //Proceed with updating username/email address
                        
                        [loggedInUser saveInBackground];
                        
                        //Alert user
                        UIAlertView *success = [[UIAlertView alloc]initWithTitle:@"Account updated" message:@"Your account has successfully been updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [success show];
                        
                        //Clear text fields
                        selectUsername.text = @"";
                        selectPassword.text = @"";
                        confirmPassword.text = @"";
                        enterEmail.text = @"";
                        
                        //Return to main menu
                        [self.navigationController popToRootViewControllerAnimated:TRUE];
                        
                    } else {
                        //Second password has text, but not first password
                        UIAlertView *passwordAlert = [[UIAlertView alloc]initWithTitle:@"Password Error" message:@"You did not enter a password in the first field. Please enter and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [passwordAlert show];
                    }
                    
                } else {
                    
                    //Make sure password is at least 6 characters
                    if (password.length < 6) {
                        //Password is < 6 characters, alert user
                        UIAlertView *passwordLength = [[UIAlertView alloc]initWithTitle:@"Password Length" message:@"Password must be at least 6 characters long. Please enter a new password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [passwordLength show];
                        
                        //Clear password fields
                        selectPassword.text = @"";
                        confirmPassword.text = @"";
                        
                    } else {
                        
                        //Check to make sure both fields match
                        if ([password isEqualToString:secondPassword]) {
                            //Both passwords match
                            //Update user password
                            loggedInUser.password = password;
                            
                            //Save updated info
                            [loggedInUser saveInBackground];
                            
                            //Alert user
                            UIAlertView *success = [[UIAlertView alloc]initWithTitle:@"Account updated" message:@"Your account has successfully been updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [success show];
                            
                            //Clear text fields
                            selectUsername.text = @"";
                            selectPassword.text = @"";
                            confirmPassword.text = @"";
                            enterEmail.text = @"";
                            
                            //Return to main menu
                            [self.navigationController popToRootViewControllerAnimated:TRUE];
                            
                        } else {
                            //Passwords do not match
                            UIAlertView *passwordAlert = [[UIAlertView alloc]initWithTitle:@"Password Error" message:@"Both passwords must match. Please re-enter passwords and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            //Clear password fields
                            selectPassword.text = @"";
                            confirmPassword.text = @"";
                            
                            [passwordAlert show];
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        
    } else {
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to edit your account. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
