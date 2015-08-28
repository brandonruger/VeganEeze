//
//  FindARestaurantVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "FindARestaurantVC.h"

@interface FindARestaurantVC ()

@end

@implementation FindARestaurantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set search bars' delegate
    keyword.delegate = self;
    location.delegate = self;
    
    //Setup array with choices for picker
    pickerChoices = [[NSArray alloc]initWithObjects:@"Vegan", @"Vegetarian", @"Veg-Friendly", nil];
    
    //Connect picker view to delegates
    veganChoicePicker.dataSource = self;
    veganChoicePicker.delegate = self;
    
    //Get current location
    [self getCurrentLocation];
    
    //Add target selectors to segmented control buttons
    [searchSegmentedControl addTarget:self action:@selector(howToSearch:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

//Method to check if search bars are editing so cancel button can be displayed
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    //Show cancel button
    cancelButton.hidden = false;
}

//Method to check when search bar finishes editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    cancelButton.hidden = true;
}

//Close keyboard when cancel button is pressed
- (IBAction)cancelKeyboard:(id)sender
{
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    cancelButton.hidden = true;
}

//Called when search button is clicked on keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //Perform segue to Beverage Search Results
    [self performSegueWithIdentifier:@"segueToRestaurantResults" sender:self];
    
}

//Called when cancel button on search bar is clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Clear text from search bar
    searchBar.text = @"";
}

#pragma mark - Segmented Control Button methods

//Method called when segmented control button changes
- (void)howToSearch:(UISegmentedControl *)sender {
    //Get index of button pressed
    NSInteger segmentControlSelected = sender.selectedSegmentIndex;
    
    if (segmentControlSelected == 0) { //
        //Call the method to search by current location
        [self searchByCurrentLoc];
    } else {
        //Call method to search by city/state
        [self searchCityState];
    }
}

//Method called when segmented control is set to "search current location"
- (void)searchByCurrentLoc {
    NSLog(@"Search by current location enabled");
    
    //Hide location search bar
    location.hidden = TRUE;
}

//Method called when segmented control is set to "search by city/state"
- (void)searchCityState {
    NSLog(@"Search by city state enabled");
    
    //Show location search bar
    location.hidden = FALSE;
}

#pragma mark - Current Location

- (void)getCurrentLocation {
    //Create location manager object
    locationMgr = [[CLLocationManager alloc]init];
    if (locationMgr != nil) {
        
        [locationMgr requestWhenInUseAuthorization];
        
        //Set location accuracy
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        //Set delegate
        locationMgr.delegate = self;
        //Start gathering location info
        [locationMgr startUpdatingLocation];
    }
}

//Delegate method to get current locations
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        //Get coordinates of current location
        CLLocationCoordinate2D coordinates = currentLocation.coordinate;
        
        //Convert latitude/longitude coordinates to strings
        NSString *latitudeCoord = [NSString stringWithFormat:@"%g", coordinates.latitude];
        NSString *longitudeCoord = [NSString stringWithFormat:@"%g", coordinates.longitude];
        
        NSLog(@"Latitude = %@", latitudeCoord);
        NSLog(@"Longitude = %@", longitudeCoord);
    }
}

#pragma mark - Picker View

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerChoices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return pickerChoices[row];
}


@end
