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
    
    //ratingPickerChoices = [[NSArray alloc]initWithObjects:@"1 star", "2 stars", "3 stars", "4 stars", nil];
    
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
    
    //Get rating user entered
    //int starRating = [pickerChoiceSelected intValue];
    
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
                // The object has been saved.
                UIAlertView *savedAlert = [[UIAlertView alloc]initWithTitle:@"Saved" message:@"Your review has been added" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [savedAlert show];
                
                //Clear text field
                commentTextBox.text = @"";
                
                //Go back to previous page
                [self.navigationController popViewControllerAnimated:TRUE];
                
            } else {
                //Unable to save
                UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error trying to save your comment. Please make sure you have a valid network connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        }];

        
    } else {
        //User is not logged in
        
        UIAlertView *logInAlert = [[UIAlertView alloc]initWithTitle:@"Login error" message:@"You must be logged in to post a review. Press the OK button to go to the login screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [logInAlert show];
        
        //Take user to login screen
        ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //Instantiate view controller
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
   
}


@end
