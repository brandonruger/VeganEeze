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
        if (loggedInUser != nil) {
            NSString *currentUsername = loggedInUser.username;
            NSString *currentEmail = loggedInUser.email;
            
            //Load text fields with above data
            selectUsername.text = currentUsername;
            enterEmail.text = currentEmail;
        }
        
    } else {
        //Alert user
        UIAlertController *noConnection = [UIAlertController alertControllerWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noConnection addAction:defaultOk];
        //Show alert
        [self presentViewController:noConnection animated:YES completion:nil];
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
        password = selectPassword.text;
        secondPassword = confirmPassword.text;
        emailAddress = enterEmail.text;
        
        //Check to make sure username isn't blank
        if ([username isEqualToString:@""]) {
            //Alert user they must enter a username
            UIAlertController *usernameAlert = [UIAlertController alertControllerWithTitle:@"Username Error" message:@"Username cannot be blank. Please enter a new username and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [usernameAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:usernameAlert animated:YES completion:nil];
            
            //Check length of username to make sure it's at least 6 characters
        } else if (username.length < 6) {
            
            //Alert user
            UIAlertController *usernameLength = [UIAlertController alertControllerWithTitle:@"Username Error" message:@"Your username must be at least 6 characters long. Please enter a new username and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [usernameLength addAction:defaultOk];
            //Show alert
            [self presentViewController:usernameLength animated:YES completion:nil];
            
            //Clear username field
            selectUsername.text = @"";
            
            //Check email field to make sure it isn't blank
        } else if ([emailAddress isEqualToString:@""]) {
            
            //Email address field is blank, alert user
            UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"Email address cannot be blank. Please enter a new email address if you would like change it, or enter your current email address and then try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [emailAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:emailAlert animated:YES completion:nil];
            
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
                    UIAlertController *success = [UIAlertController alertControllerWithTitle:@"Account Updated" message:@"Your account has successfully been updated." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        //Login with new credentials
                        [PFUser logInWithUsernameInBackground:username password:password];
                        
                        //Return to main menu
                        [self.navigationController popViewControllerAnimated:TRUE];
                        
                    }];
                    //Add action to alert controller
                    [success addAction:defaultOk];
                    //Show alert
                    [self presentViewController:success animated:YES completion:nil];
                    
                    //Clear text fields
                    selectUsername.text = @"";
                    selectPassword.text = @"";
                    confirmPassword.text = @"";
                    enterEmail.text = @"";
                    
                    
                } else {
                    //Second password field has text, but not first password field
                    UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"You did not enter a password in the first field. Please enter your new password and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [passwordAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:passwordAlert animated:YES completion:nil];
                }
                
            } else {
                //Both password fields filled in
                
                //Make sure password is at least 6 characters
                if (password.length < 6) {
                    //Password is < 6 characters, alert user
                    UIAlertController *passwordLength = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"Your password must be at least 6 characters long. Please enter a new password and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [passwordLength addAction:defaultOk];
                    //Show alert
                    [self presentViewController:passwordLength animated:YES completion:nil];
                    
                    //Clear password fields
                    selectPassword.text = @"";
                    confirmPassword.text = @"";
                    
                } else {
                    //Password is at least 6 characters
                    
                    //Check to make sure both fields match
                    if ([password isEqualToString:secondPassword]) {
                        //Both passwords match
                        //Update user password
                        loggedInUser.password = password;
                        
                        //Save updated info
                        [loggedInUser saveInBackground];
                        
                        //Alert user
                        UIAlertController *success = [UIAlertController alertControllerWithTitle:@"Account Updated" message:@"Your account has successfully been updated." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                            //Login with new credentials
                            [PFUser logInWithUsernameInBackground:username password:password];
                            
                            [self.navigationController popViewControllerAnimated:TRUE];
                            
                        }];
                        //Add action to alert controller
                        [success addAction:defaultOk];
                        //Show alert
                        [self presentViewController:success animated:YES completion:nil];
                        
                        //Clear text fields
                        selectUsername.text = @"";
                        selectPassword.text = @"";
                        confirmPassword.text = @"";
                        enterEmail.text = @"";
                        
                        //Return to main menu
                        //[self.navigationController popToRootViewControllerAnimated:TRUE];
                        
                    } else {
                        //Passwords do not match, alert user
                        UIAlertController *passwordNoMatch = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"The passwords you entered do not match. Please re-enter passwords and try again." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                        }];
                        //Add action to alert controller
                        [passwordNoMatch addAction:defaultOk];
                        //Show alert
                        [self presentViewController:passwordNoMatch animated:YES completion:nil];
                        
                        //Clear password fields
                        selectPassword.text = @"";
                        confirmPassword.text = @"";
                        
                    }
                    
                    
                }
                
            }
            
            
            
        }
        
        
    } else {
        //Alert user
        UIAlertController *noConnection = [UIAlertController alertControllerWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noConnection addAction:defaultOk];
        //Show alert
        [self presentViewController:noConnection animated:YES completion:nil];
    }
}

//Method to check if network is connected
- (BOOL) isNetworkConnected
{
    Reachability *currentConnection = [Reachability reachabilityForInternetConnection];
    if ([currentConnection isReachable]) {
        //Network connection active, return true
        return TRUE;
    } else {
        //No network connection        
        return FALSE;
    }
}


@end
