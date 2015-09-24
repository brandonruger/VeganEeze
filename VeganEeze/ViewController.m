//
//  ViewController.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Set textfields' delegate
    username.delegate = self;
    password.delegate = self;
    
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

-(IBAction)loginToAccount:(id)sender {
    
    //Check if user has active connection
    if ([self isNetworkConnected]) {
        //Network connection is active
        //Get username/password entered by user in text fields
        usernameStr = username.text;
        passwordStr = password.text;
        
        //Make sure username was not left blank
        if ([usernameStr isEqualToString:@""]){
            
            //Alert user they must enter a username
            UIAlertController *usernameBlank = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username field cannot be left blank. Please enter your username and try again" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [usernameBlank addAction:defaultOk];
            //Show alert to user
            [self presentViewController:usernameBlank animated:YES completion:nil];
            
            //Make sure password wasn't left blank
        } else if ([passwordStr isEqualToString:@""]) {
            
            //Alert user they must enter a password
            UIAlertController *passwordBlank = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password field cannot be left blank. Please enter your password and try again" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [passwordBlank addAction:defaultOk];
            //Show alert
            [self presentViewController:passwordBlank animated:YES completion:nil];
            
        } else {
            //Both fields filled in, try to login to app
            [PFUser logInWithUsernameInBackground:usernameStr password:passwordStr
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    //Successfully logged in, go to main menu
                                                    //[self.navigationController popViewControllerAnimated:TRUE];
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                    
                                                } else {
                                                    //Get the error code from Parse
                                                    NSInteger errorCode = [error code];
                                                    if (errorCode == 101) {
                                                        
                                                        //Invalid login parameters, alert user
                                                        UIAlertController *invalidLogin = [UIAlertController alertControllerWithTitle:@"Invalid login" message:@"The username or password you entered is incorrect. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                            
                                                        }];
                                                        //Add action to alert controller
                                                        [invalidLogin addAction:defaultOk];
                                                        //Show alert
                                                        [self presentViewController:invalidLogin animated:YES completion:nil];
                                                        
                                                        
                                                        
                                                    } else {
                                                        
                                                        //Log in failed. Have user try again.
                                                        UIAlertController *loginFailed = [UIAlertController alertControllerWithTitle:@"Error" message:@"Login failed, please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                            
                                                        }];
                                                        //Add action to alert controller
                                                        [loginFailed addAction:defaultOk];
                                                        //Show alert
                                                        [self presentViewController:loginFailed animated:YES completion:nil];
                                                        
                                                        //Clear text fields
                                                        username.text = @"";
                                                        password.text = @"";
                                                    }
                                                }
                                            }];
        }
        
    }
    
}

#pragma mark - Forgot Password

-(IBAction)forgotPassword:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        //Network connection found
        //Show alert with text input for user to enter their email address
        
        UIAlertController *forgotPassword = [UIAlertController alertControllerWithTitle:@"Forgot Password?" message:@"Please enter your email address below to reset your password." preferredStyle:UIAlertControllerStyleAlert];
        
        
        //Add Cancel button
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //Dismiss alert
        }];
        
        //Add OK button
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UITextField *emailTextField = forgotPassword.textFields.firstObject;
            forgotPwEmail = emailTextField.text;
            
            //Call method to reset password
            [self requetPasswordReset: forgotPwEmail];
            
        }];
        
        //Add actions to alert controller
        [forgotPassword addAction:cancelButton];
        [forgotPassword addAction:defaultOk];
        
        
        //Add text field to alert for email address
        [forgotPassword addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter email address";
        }];
        
        //Show alert
        [self presentViewController:forgotPassword animated:YES completion:nil];
    }
    
}

-(void)requetPasswordReset:(NSString*)emailEntered {
    
    //Request password reset via Parse
    [PFUser requestPasswordResetForEmailInBackground:emailEntered block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            //Successful, alert user
            UIAlertController *requestSuccess = [UIAlertController alertControllerWithTitle:@"Success" message:@"You will receive an email shortly with a link to reset your password." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [requestSuccess addAction:defaultOk];
            //Show alert
            [self presentViewController:requestSuccess animated:YES completion:nil];
            
        } else {
            //Get error code from Parse
            NSInteger errorCode = [error code];
            
            //Error - Invalid email
            if (errorCode == 125) {
                //Alert user
                UIAlertController *invalidEmail = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"The email address you entered is not valid. Please enter a valid email address and try again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                //Add action to alert controller
                [invalidEmail addAction:defaultOk];
                //Show alert
                [self presentViewController:invalidEmail animated:YES completion:nil];
                
            }
            //Error - No user found
            if (errorCode == 205) {
                //No user found, alert user
                UIAlertController *noUser = [UIAlertController alertControllerWithTitle:@"Email Error" message:@"No user was found with the email address you entered. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                //Add action to alert controller
                [noUser addAction:defaultOk];
                //Show alert
                [self presentViewController:noUser animated:YES completion:nil];
                
                
            }
            
            
        }
    }];
    
    
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
