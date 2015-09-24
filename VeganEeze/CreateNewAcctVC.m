//
//  CreateNewAcctVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "CreateNewAcctVC.h"


@interface CreateNewAcctVC ()

@end

@implementation CreateNewAcctVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set textfields' delegate
    selectUsername.delegate = self;
    selectPassword.delegate = self;
    confirmPassword.delegate = self;
    enterEmail.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

//When user presses return button
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    return YES;
}


#pragma mark - Parse



-(IBAction)createNewAccount:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        //Network connection found
        
        //Get text entered
        username = selectUsername.text;
        password = selectPassword.text;
        secondPassword = confirmPassword.text;
        emailAddress = enterEmail.text;
        
        //Check to make sure username wasn't blank
        if ([username isEqualToString:@""]) {
            
            //Alert user they must enter a username
            UIAlertController *usernameAlert = [UIAlertController alertControllerWithTitle:@"Username Error" message:@"You must enter a username in order to create a new account. Please enter username and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [usernameAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:usernameAlert animated:YES completion:nil];
            
            
            //Username is okay, check to make sure user entered a password in the first field
        } else if ([password isEqualToString:@""]) {
            
            //Password field blank, alert user
            UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"You must enter a password in the select a password field in order to create a new account. Please enter your preferred password and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [passwordAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:passwordAlert animated:YES completion:nil];
            
            //Password field is not blank, check to make sure second password field isn't blank
        } else if ([secondPassword isEqualToString:@""]) {
            
            
            //Confirm password field is blank, alert user
            UIAlertController *confirmPasswordAlert = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"You must enter the password you chose again in the confirm password field. Please enter your password and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [confirmPasswordAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:confirmPasswordAlert animated:YES completion:nil];
            
            //Both password fields filled in, check to make sure password is at least 6 characters
        } else if (password.length < 6) {
            
            
            //Alert user
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
            
            //Make sure both password fields match
        } else if (![password isEqualToString:secondPassword]) {
            
            //Passwords do not match, alert user
            UIAlertController *passwordNoMatch = [UIAlertController alertControllerWithTitle:@"Password Error" message:@"The passwords you entered do not match. Please re-enter passwords and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [passwordNoMatch addAction:defaultOk];
            //Show alert
            [self presentViewController:passwordNoMatch animated:YES completion:nil];
            
            //Clear text fields
            selectPassword.text = @"";
            confirmPassword.text = @"";
            
            
            
            //Passwords match, check email address to make sure wasn't left blank
        } else if ([emailAddress isEqualToString:@""]) {
            
            
            //Email address field is blank, alert user
            UIAlertController *emailAlert = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"You must enter an email address in order to create a new account. Please enter your email address and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [emailAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:emailAlert animated:YES completion:nil];
            
        } else {
            
            //Email address was entered/ All fields validate. Create parse user object to set up user account
            
            //Create new user object
            PFUser *newUser = [PFUser user];
            //Set username and password to what was entered
            newUser.username = username;
            newUser.password = password;
            newUser.email = emailAddress;
            
            //Create account
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    //Alert user account has been created
                    UIAlertController *accountCreated = [UIAlertController alertControllerWithTitle:@"Congratulations" message:@"Your new account has successfully been created! You will now be logged into the app." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        //Log user into app
                        [PFUser logInWithUsernameInBackground:username password:password
                                                        block:^(PFUser *user, NSError *error) {
                                                            if (user) {
                                                                //Successfully logged in, go to main menu
                                                                [self.navigationController popToRootViewControllerAnimated:TRUE];
                                                            } else {
                                                                
                                                                //Log in failed. Have user try again.
                                                                UIAlertController *loginFailed = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"Login failed, please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                                UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                    
                                                                    
                                                                }];
                                                                //Add action to alert controller
                                                                [loginFailed addAction:defaultOk];
                                                                //Show alert
                                                                [self presentViewController:loginFailed animated:YES completion:nil];
                                                                
                                                            }
                                                        }];
                    }];
                    //Add action to alert controller
                    [accountCreated addAction:defaultOk];
                    //Show alert
                    [self presentViewController:accountCreated animated:YES completion:nil];
                    
                    
                    
                    
                } else {
                    //There was an error
                    NSString *errorString = [error userInfo][@"error"];
                    
                    //Check error code
                    NSInteger errorCode = [error code];
                    NSLog(@"Error code = %ld", (long)errorCode);
                    
                    
                    //Log error
                    NSLog(@"create account error = %@", errorString);
                    
                    //Error - Invalid email
                    if (errorCode == 125) {
                        //Alert user to try again
                        UIAlertController *invalidEmail = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"The email address you entered is not valid, please try again." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                        }];
                        //Add action to alert controller
                        [invalidEmail addAction:defaultOk];
                        //Show alert
                        [self presentViewController:invalidEmail animated:YES completion:nil];
                        
                        //Clear email field
                        enterEmail.text = @"";
                        
                    } else if (errorCode == 202) {
                        //Error - Username taken
                        UIAlertController *usernameTaken = [UIAlertController alertControllerWithTitle:@"Username Error" message:@"The username you chose is already taken. Please pick a new username and try again." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                        }];
                        //Add action to alert controller
                        [usernameTaken addAction:defaultOk];
                        //Show alert
                        [self presentViewController:usernameTaken animated:YES completion:nil];
                        
                        //Clear username field
                        selectUsername.text = @"";
                        
                        
                    } else if (errorCode == 203) {
                        
                        UIAlertController *emailTaken = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"The email address you entered is already associated to another account. Please enter a different email address to create a new account." preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            
                        }];
                        //Add action to alert controller
                        [emailTaken addAction:defaultOk];
                        //Show alert
                        [self presentViewController:emailTaken animated:YES completion:nil];
                        
                        //Clear email field
                        enterEmail.text = @"";
                    }
                    
                }
            }];
            
            
            
        }
        
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
