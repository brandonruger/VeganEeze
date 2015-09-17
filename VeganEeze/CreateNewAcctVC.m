//
//  CreateNewAcctVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "CreateNewAcctVC.h"
#import "MainMenuTVC.h"


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


#pragma mark - Navigation

////Segue to main menu
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"segueNewAcctToMainMenu"]) {
//        [self createNewAccount];
//    }
//
//    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    if (createAcctAlert != nil) {
//        [createAcctAlert show];
//    }
//}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    if ([identifier isEqualToString:@"segueNewAcctToMainMenu"]) {
//        if (loggedInUser) {
//            //User is logged in, okay to perform segue
//            return TRUE;
//        } else {
//            //User is not logged in, don't perform segue
//            //Call method to login to account
//            //[self loginToAccount];
//            
////            //Log in failed. Have user try again.
////            UIAlertView *loginFailed = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Login failed, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////            [loginFailed show];
////            
////            //Go back to login screen
////            [self dismissViewControllerAnimated:true completion:nil];
//            
//            //Call method to create new account
//            [self createNewAccount];
//            
//            return FALSE;
//        }
//    }
//    return FALSE;
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
//    //cancelButton.hidden = true;
//}

#pragma mark - Parse



-(IBAction)createNewAccount:(id)sender {
    
    
    //Get username entered
    username = selectUsername.text;
    //Check to make sure username wasn't blank
    if ([username isEqualToString:@""]) {
        //Alert user they must enter a username
        UIAlertView *usernameAlert = [[UIAlertView alloc]initWithTitle:@"Username error" message:@"You must enter a username in order to create a new account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [usernameAlert show];
    } else {
        //Username is okay, check to make sure user entered a password in the first field
        //Get password entered in first field
        password = selectPassword.text;
        if ([password isEqualToString:@""]) {
            //Password field blank, alert user
            UIAlertView *passwordAlert = [[UIAlertView alloc]initWithTitle:@"Password error" message:@"You must enter a password in the select a password field in order to create a new account."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [passwordAlert show];
        } else {
            //User entered a password in the first field, check second field
            secondPassword = confirmPassword.text;
            if ([secondPassword isEqualToString:@""]) {
                //Confirm password field is blank, alert user
                UIAlertView *confirmPasswordAlert = [[UIAlertView alloc]initWithTitle:@"Password error" message:@"You must enter your password again in the confirm password field in order to create a new account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [confirmPasswordAlert show];
            } else {
                
                //Make sure password is at least 6 characters
                if (password.length < 6) {
                    //Alert user
                    UIAlertView *passwordLength = [[UIAlertView alloc]initWithTitle:@"Password Length" message:@"Password must be at least 6 characters long. Please enter a new password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [passwordLength show];
                    
                    //Clear password fields
                    selectPassword.text = @"";
                    confirmPassword.text = @"";
                    
                    
                } else {
                    
                    //User entered passwords in both fields, check to make sure they match
                    if ([password isEqualToString:secondPassword]) {
                        //Passwords match, check email address
                        emailAddress = enterEmail.text;
                        if ([emailAddress isEqualToString:@""]) {
                            //Email address field is blank, alert user
                            UIAlertView *emailAlert =[[UIAlertView alloc]initWithTitle:@"Email error" message:@"You must enter an email address in order to create an account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [emailAlert show];
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
                                    UIAlertView *accountCreated = [[UIAlertView alloc]initWithTitle:@"Congratulations" message:@"Your new account has successfully been created!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [accountCreated show];
                                    
                                    //Log user into app
                                    [PFUser logInWithUsernameInBackground:username password:password
                                                                    block:^(PFUser *user, NSError *error) {
                                                                        if (user) {
                                                                            //Successfully logged in, go to main menu
                                                                            [self.navigationController popToRootViewControllerAnimated:TRUE];
                                                                        } else {
                                                                            //Log in failed. Have user try again.
                                                                            UIAlertView *loginFailed = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Login failed, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                            [loginFailed show];
                                                                            
                                                                            //Go back to login screen
                                                                            //[self dismissViewControllerAnimated:true completion:nil];
                                                                            [self.navigationController popViewControllerAnimated:TRUE];
                                                                            
                                                                        }
                                                                    }];
                                    
                                    
                                } else {
                                    //There was an error
                                    NSString *errorString = [error userInfo][@"error"];
                                    
                                    //Check error code
                                    NSInteger errorCode = [error code];
                                    NSLog(@"Error code = %ld", (long)errorCode);
                                    
                                    
                                    //Log error
                                    NSLog(@"create account error = %@", errorString);
                                    
                                    //Invalid email
                                    if (errorCode == 125) {
                                        //Alert user to try again
                                        UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"The email address you entered is not valid, please try again.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [invalidEmail show];
                                        
                                        //Clear email field
                                        enterEmail.text = @"";
                                    }
                                    
                                    if (errorCode == 202) {
                                        //Username taken
                                        UIAlertView *usernameTaken = [[UIAlertView alloc]initWithTitle:@"Username Error" message:@"The username you entered is already taken. Please pick a new username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [usernameTaken show];
                                        
                                        //Clear username field
                                        selectUsername.text = @"";
                                        
                                        
                                    }
                                    if (errorCode == 203) {
                                        //Email taken
                                        UIAlertView *emailTaken = [[UIAlertView alloc]initWithTitle:@"Email Error" message:@"The email address you entered is already taken. Please enter a different email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        [emailTaken show];
                                        
                                        //Clear email field
                                        enterEmail.text = @"";
                                    }
                                    
                                }
                            }];
                            
                            
                            
                        }
                        
                        
                        
                        
                    } else {
                        //Passwords do not match, alert user
                        //Alert user that passwords do not match
                        UIAlertView *passwordError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Passwords must match in order to create an account. Please reenter passwords and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        //Show alert
                        [passwordError show];
                        //Clear password fields
                        selectPassword.text = @"";
                        confirmPassword.text = @"";
                    }
                }
            }
        }
        
    }
}


    //Set username, password and email to what user entered in text fields
    
    //Gather info entered in text fields
//    username = selectUsername.text;
//    password = selectPassword.text;
//    secondPassword = confirmPassword.text;
//    emailAddress = enterEmail.text;
    
    
    //Make sure passwords in both fields match
//    if ([password isEqualToString:secondPassword]) {
//        //Both passwords match
//        
//        
//        
//    } else {
////        //Alert user that passwords do not match
////        UIAlertView *passwordError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Passwords must match in order to create an account. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////        //Show alert
////        [passwordError show];
////        //Clear password fields
////        selectPassword.text = @"";
////        confirmPassword.text = @"";
//    }
//}


//- (IBAction)createNewAccount:(id)sender
//{
//    
//    //Create an alert to let user know account has been created
//    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    if (createAcctAlert != nil) {
//        [createAcctAlert show];
//    }
//    
//}

@end
