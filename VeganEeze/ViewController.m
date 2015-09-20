//
//  ViewController.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "ViewController.h"
#import "MainMenuTVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Hide back button on navigation bar
    //self.navigationItem.hidesBackButton = YES;
    
    //Set textfields' delegate
    username.delegate = self;
    password.delegate = self;
    
//    //Check if user is already logged in
//    loggedInUser = [PFUser currentUser];
//    if (loggedInUser) {
//        //User is logged in, go to main menu
//        [self performSegueWithIdentifier:@"segueLoginToMainMenu" sender:self];
//        
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////Segue to launch other view controllers
//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"segueLoginToMainMenu"] && loggedInUser ) {
//        
//        }
//        
//        //Call method to login to app
//        [self loginToAccount];
//    }
//}

#pragma mark - Keyboard

//Method to check if keyboard is editing so cancel button can be displayed
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Show cancel button
    //cancelButton.hidden = false;
}

//When user presses return button
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    //cancelButton.hidden = true;
    
    return YES;
}

////Close keyboard when cancel button is pressed
//- (IBAction)cancelKeyboard:(id)sender
//{
//    //Dismiss keyboard
//    [self.view endEditing:YES];
//    
//    //Hide cancel button
//    cancelButton.hidden = true;
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//
////        //Check if segue for main menu was called
////        if ([segue.identifier isEqualToString:@"segueToMainMenu"]) {
////            //Call method to log user in to account
////            [self loginToAccount];
////            
////        }
//
//}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    if ([identifier isEqualToString:@"segueLoginToMainMenu"]) {
//        if (loggedInUser) {
//            //User is logged in, okay to perform segue
//            return TRUE;
//        } else {
//            //User is not logged in, don't perform segue
//            //Call method to login to account
//            [self loginToAccount];
//            
//            return FALSE;
//        }
//    }
//    
//    if ([identifier isEqualToString:@"segueToCreateNewAcctVC"]) {
//        return TRUE;
//    }
//    
//    return FALSE;
//}

#pragma mark - Parse
//- (void)loginToAccount {
-(IBAction)loginToAccount:(id)sender {

    //Check if user has active connection
    if ([self isNetworkConnected]) {
        //Network connection is active
        //Get username/password entered by user in text fields
        usernameStr = username.text;
        passwordStr = password.text;
        
        //Make sure fields were not blank
        if ([usernameStr isEqualToString:@""] || [passwordStr isEqualToString:@""]) {
            //Alert user they must enter both username and password
            UIAlertView *blankField = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enter username and password. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [blankField show];
        } else {
            //Try to login to app
            [PFUser logInWithUsernameInBackground:usernameStr password:passwordStr
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    //Successfully logged in, go to main menu
                                                    //[self performSegueWithIdentifier:@"segueLoginToMainMenu" sender:self];
                                                    
                                                    //MainMenuTVC *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
                                                    //Instantiate new view controller
                                                    //[self.navigationController pushViewController:mainMenuVC animated:YES];
                                                    [self.navigationController popViewControllerAnimated:TRUE];
                                                    //self.tabBarController.selectedIndex = 0;
                                                    //[self presentViewController:mainMenuVC animated:YES completion:nil];
                                                    
                                                } else {
                                                    
                                                    
                                                    NSInteger errorCode = [error code];
                                                    if (errorCode == 101) {
                                                        //Invalid login parameters, alert user
                                                        UIAlertView *invalidLogin = [[UIAlertView alloc]initWithTitle:@"Invalid login" message:@"The username or password you entered is incorrect. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                        [invalidLogin show];
                                                    } else {
                                                        
                                                        
                                                        //Log in failed. Have user try again.
                                                        UIAlertView *loginFailed = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Login failed, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                        [loginFailed show];
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
        UIAlertView *forgotPassword = [[UIAlertView alloc]initWithTitle:@"Forgot Password?" message:@"Please enter your email address below to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        //Set style to allow text input
        forgotPassword.alertViewStyle = UIAlertViewStylePlainTextInput;
        //Show alert
        [forgotPassword show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //User clicked submit button
    if (buttonIndex == 1) {
        //Gather the email address user entered
        NSString *emailAddressEntered = [[alertView textFieldAtIndex:0] text];
        
        //Request password reset via Parse
        [PFUser requestPasswordResetForEmailInBackground:emailAddressEntered block:^(BOOL succeeded, NSError *error) {
            
            
            if (succeeded) {
                //Successful, alert user
                UIAlertView *requestSuccess = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You will receieve an email shortly with a link to reset your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [requestSuccess show];
                
            } else {
                
                NSInteger errorCode = [error code];
                
                //There was an error
                //Invalid email
                if (errorCode == 125) {
                    //Alert user to try again
                    UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"The email address you entered is not valid, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [invalidEmail show];
                    
//                    //Show alert with text input for user to enter their email address
//                    UIAlertView *forgotPassword = [[UIAlertView alloc]initWithTitle:@"Forgot Password?" message:@"Please enter your email address below to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//                    //Set style to allow text input
//                    forgotPassword.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    //Show alert
//                    [forgotPassword show];

                }
                
                if (errorCode == 205) {
                    //No user found
                    UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"No user was found with the email address you entered. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [invalidEmail show];
                    
//                    //Show alert with text input for user to enter their email address
//                    UIAlertView *forgotPassword = [[UIAlertView alloc]initWithTitle:@"Forgot Password?" message:@"Please enter your email address below to reset your password." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//                    //Set style to allow text input
//                    forgotPassword.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    //Show alert
//                    [forgotPassword show];
                    
                }

                
            }
        }
         
         
         
         ];
        
        
        
        
        
        
    
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
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
        
        return FALSE;
    }
}



@end
