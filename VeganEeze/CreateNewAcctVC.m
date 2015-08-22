//
//  CreateNewAcctVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "CreateNewAcctVC.h"
#import "MainMenuTVC.h"
#import <Parse/Parse.h>

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

//Segue to main menu
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    if (createAcctAlert != nil) {
        [createAcctAlert show];
    }
}

#pragma mark - Keyboard

//Method to check if keyboard is editing so cancel button can be displayed
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Show cancel button
    cancelButton.hidden = false;
}

//When user presses return button
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    cancelButton.hidden = true;
    
    return YES;
}

//Close keyboard when cancel button is pressed
- (IBAction)cancelKeyboard:(id)sender
{
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    cancelButton.hidden = true;
}

#pragma mark - Parse

- (IBAction)createNewAccount:(id)sender {
    //Create new user object
    PFUser *newUser = [PFUser user];
    //Set username, password and email to what user entered in text fields
    
    //Make sure passwords in both fields match
    if ([selectUsername.text isEqualToString:confirmPassword.text]) {
        //Both passwords match
        //Set username and password to what was entered
        newUser.username = selectUsername.text;
        newUser.password = selectPassword.text;
        
        //Verify email address format
        
        newUser.email = enterEmail.text;
        
        //Create account
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //No errors, log user into app
                [PFUser logInWithUsername:selectUsername.text password:selectPassword.text];
                
            } else {
                //There was an error
                NSString *errorString = [error userInfo][@"error"];
                //Log error
                NSLog(@"create account error = %@", errorString);
                
                //Alert user to try again
                UIAlertView *createAccountError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error setting up your account. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
            }
        }];
        
    } else {
        //Alert user that passwords do not match
        UIAlertView *passwordError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Passwords must match in order to create an account. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //Show alert
        [passwordError show];
        //Clear password fields
        selectPassword.text = @"";
        confirmPassword.text = @"";
    }
}


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
