//
//  SearchEventsVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "SearchEventsVC.h"
#import "EventResultsTVC.h"
#import "VeganEvent.h"

@interface SearchEventsVC ()

@end

@implementation SearchEventsVC

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
    
    searchCurrentLocation = TRUE;
    
    //Set default for picker choice
    pickerChoiceSelected = @"vegan";
    
    //Get current location
    [self getCurrentLocation];
    
    //Add target selectors to segmented control buttons
    [searchSegmentedControl addTarget:self action:@selector(howToSearch:) forControlEvents:UIControlEventValueChanged];
    
    //Initalize NSMutableArray which will hold event objects
    eventObjects = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Clear text from search bars
    keyword.text = @"";
    location.text = @"";
    
    searchKeyword = @"";
    
    //Remove all objects from array
    if (eventObjects != nil) {
        [eventObjects removeAllObjects];
    }
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
    [self performSegueWithIdentifier:@"segueToEventResults" sender:self];
    
}

//Called when cancel button on search bar is clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Clear text from search bar
    searchBar.text = @"";
}

//Method to check when search bar finishes editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    cancelButton.hidden = true;
}

#pragma mark - Segmented Control Button methods

//Method called when segmented control button changes
- (void)howToSearch:(UISegmentedControl *)sender {
    //Get index of button pressed
    NSInteger segmentControlSelected = sender.selectedSegmentIndex;
    
    if (segmentControlSelected == 0) { //
        //Call the method to search by current location
        [self searchByCurrentLoc];
        
        //Set bool to true
        searchCurrentLocation = TRUE;
    } else {
        //Call method to search by city/state
        [self searchCityState];
        
        //Set bool to false
        searchCurrentLocation = FALSE;
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
        latitudeCoord = [NSString stringWithFormat:@"%g", coordinates.latitude];
        longitudeCoord = [NSString stringWithFormat:@"%g", coordinates.longitude];
        
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            //User selected first row
            pickerChoiceSelected = @"vegan"; //Vegan
            break;
            
        case 1:
            //User selected second row
            pickerChoiceSelected = @"vegetarian"; //Vegetarian
            break;
            
        case 2:
            //User selected 3rd row
            pickerChoiceSelected = @"veg friendly"; //Vegan-Friendly
        default:
            pickerChoiceSelected = @"vegan"; //Default choice is vegan
            break;
    }
}

#pragma mark - Eventful API calls

//API key- VrdtgSDWhZCHjRcK

-(IBAction)searchVeganEvents:(id)sender {
    //Set search keyword to keyword user entered
    searchKeyword = keyword.text;
    
    
    //Check how user wants to search
    if (searchCurrentLocation) {
        //User has chosen to search by current location
        
        //String used to access API
        partialURL = @"http://eventful.com/events";
        //Create a string to hold latititude/longitude coordinates
        NSString *coordinates = [NSString stringWithFormat:@"%@,%@", latitudeCoord, longitudeCoord];
        
        //Add coordinates term to url for API call
        completeURL = [partialURL stringByAppendingString:coordinates];
        
        //Check if user entered a search keyword or not
        if ([searchKeyword isEqualToString:@""]) {
            //User did not enter a keywrod
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        } else {
            //User entered a search keyword, need to add it to URL
            
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"%@,%@", pickerChoiceSelected, searchKeyword];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        }

    } else {
        //User wants to search by address
        partialURL = @"";
        
        //Get string user entered in search field
        NSString *userEnteredLocation = location.text;
        
        //Append string to form complete URL
        completeURL = [partialURL stringByAppendingString:userEnteredLocation];
        
        //Check if user entered a search keyword or not
        if ([searchKeyword isEqualToString:@""]) {
            //User did not enter a keywrod
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        } else {
            //User entered a search keyword, need to add it to URL
            
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"%@,%@", pickerChoiceSelected, searchKeyword];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        }
        
    }
    
    //Set up URL for API call
    urlForAPICall = [[NSURL alloc] initWithString:filterURL];
    
    //Set up request to send to server
    requestForData = [[NSMutableURLRequest alloc]initWithURL:urlForAPICall];
    if (requestForData != nil) {
        
        //Set up connection to get data from the server
        apiConnection = [[NSURLConnection alloc]initWithRequest:requestForData delegate:self];
        //Create mutableData object to hold data
        dataRetrieved = [NSMutableData data];
    }

}

//Method called when data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //Check to make sure data is valid
    if (data != nil) {
        //Add this data to mutableData object
        [dataRetrieved appendData:data];
    }
}

//Method called when all data from request has been retrieved
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(VeganEvent*)createEventObjects:(NSDictionary*)eventDictionary {

    return nil;
}


@end
