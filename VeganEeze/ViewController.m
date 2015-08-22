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
    self.navigationItem.hidesBackButton = YES;
    
    //Set textfields' delegate
    username.delegate = self;
    password.delegate = self;
    
    //Check if user is already logged in
    loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        //User is logged in, go to main menu
        [self performSegueWithIdentifier:@"segueLoginToMainMenu" sender:self];
        
    }
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

//        //Check if segue for main menu was called
//        if ([segue.identifier isEqualToString:@"segueToMainMenu"]) {
//            //Call method to log user in to account
//            [self loginToAccount];
//            
//        }

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"segueLoginToMainMenu"]) {
        if (loggedInUser) {
            //User is logged in, okay to perform segue
            return TRUE;
        } else {
            //User is not logged in, don't perform segue
            //Call method to login to account
            [self loginToAccount];
            
            return FALSE;
        }
    }
    return FALSE;
}

#pragma mark - Parse
- (void)loginToAccount {
    
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
                                                [self performSegueWithIdentifier:@"segueLoginToMainMenu" sender:self];
                                            } else {
                                                //Log in failed. Have user try again.
                                                UIAlertView *loginFailed = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Login failed, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [loginFailed show];
                                                //Clear text fields
                                                username.text = @"";
                                                password.text = @"";
                                            }
                                        }];
    }
}



@end
