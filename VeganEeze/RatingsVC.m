//
//  RatingsVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/14/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RatingsVC.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "Reachability.h"

@interface RatingsVC ()

@end

@implementation RatingsVC
@synthesize currentEventsID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"eventID = %@", currentEventsID);
    
    NSString *choice1 = @"1 star";
    NSString *choice2 = @"2 stars";
    NSString *choice3 = @"3 stars";
    NSString *choice4 = @"4 stars";
    
    ratingPickerChoices = [[NSArray alloc]initWithObjects:choice1, choice2, choice3, choice4, nil];
    
    //Connect picker to delegates
    ratingsPicker.dataSource = self;
    ratingsPicker.delegate = self;
    
    //Set default picker choice
    pickerChoiceSelected = @"2";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [ratingPickerChoices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return ratingPickerChoices[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            //User selected first row
            pickerChoiceSelected = @"1";
            break;
            
        case 1:
            //User selected second row
            pickerChoiceSelected = @"2";
            break;
            
        case 2:
            //User selected 3rd row
            pickerChoiceSelected = @"3";
            break;
        case 3:
            //User selected 4th row
            pickerChoiceSelected = @"4";
            break;
        default:
            pickerChoiceSelected = @"2";
            break;
    }
}

-(IBAction)saveRating:(id)sender {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        
        //Get users comment
        NSString *commentEntered = commentTextBox.text;
        
        PFUser *loggedInUser = [PFUser currentUser];
        
        if (loggedInUser) {
            //User is logged in
            
            NSString *username = loggedInUser.username;
            
            //Create a Parse object to store the data with the items ID
            PFObject *userRating = [PFObject objectWithClassName:@"UserRating"];
            NSLog(@"eventID = %@", currentEventsID);
            userRating[@"itemID"] = currentEventsID;
            userRating[@"username"] = username;
            userRating[@"stars"] = pickerChoiceSelected;
            userRating[@"review"] = commentEntered;
            
            //Save item to Parse
            [userRating saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    // The object has been saved, alert user
                    UIAlertController *savedAlert = [UIAlertController alertControllerWithTitle:@"Saved" message:@"Your review has been successfully added." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        //Go back to previous page
                        [self.navigationController popViewControllerAnimated:TRUE];
                    }];
                    //Add action to alert controller
                    [savedAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:savedAlert animated:YES completion:nil];
                    
                    //Clear text field
                    commentTextBox.text = @"";
                    
                    
                    
                } else {
                    //Unable to save
                    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error trying to save your comment. Please make sure you have a valid network connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [errorAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:errorAlert animated:YES completion:nil];
                }
            }];
            
            
        } else {
            //User is not logged in
            UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"You must be logged in to post a review. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //Take user to login screen
                ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //Instantiate view controller
                [self.navigationController pushViewController:loginVC animated:YES];
                
            }];
            //Add action to alert controller
            [loginAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:loginAlert animated:YES completion:nil];
            
            
            
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
