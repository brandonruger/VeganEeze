//
//  FindARestaurantVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "FindARestaurantVC.h"
#import "RestaurantResultsTVC.h"
#import "VeganRestaurant.h"
#import "Reachability.h"

@interface FindARestaurantVC ()

@end

@implementation FindARestaurantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set search bar's delegate
    location.delegate = self;
    
    //Setup array with choices for picker
    pickerChoices = [[NSArray alloc]initWithObjects:@"Vegan", @"Vegetarian", @"Veg-Friendly", nil];
    
    //Connect picker view to delegates
    veganChoicePicker.dataSource = self;
    veganChoicePicker.delegate = self;
    
    //Default to search by location
    searchCurrentLocation = TRUE;
    
    //Set default for picker choice
    pickerChoiceSelected = @"5";
    
    //Create location manager object
    locationMgr = [[CLLocationManager alloc]init];
    if (locationMgr != nil) {
        
        //Request permission to access location
        [locationMgr requestWhenInUseAuthorization];
    }
    
    
    //Add target selectors to segmented control buttons
    [searchSegmentedControl addTarget:self action:@selector(howToSearch:) forControlEvents:UIControlEventValueChanged];
    
    //Initialize NSMutableArray which will hold VeganRestaurant objects
    restaurantObjects = [[NSMutableArray alloc]init];
    
    //Set user agent for API call
    userAgent = @"VeganEeze App/v1.0";
    
    
    }

- (void)viewWillAppear:(BOOL)animated {
    
    //Clear text from search bars
    location.text = @"";
    
    //Remove all objects from array
    if (restaurantObjects != nil) {
        [restaurantObjects removeAllObjects];
    }
    
    //Check if Location Services are enabled on the device
    if([CLLocationManager locationServicesEnabled]){
        
        //Location Services enabled on device
        
        //Check if user has approved this app to use Location Services
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            //User has denied request for this app to use location services
            
            //Disable location button on segmented controller
            [searchSegmentedControl setEnabled:NO forSegmentAtIndex:0];
            //Change default selection to search by city
            [searchSegmentedControl setSelectedSegmentIndex:1];

            
        } else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
            //User has granted permission for this app to use location services
            
            //Enable location button on segmented controller
            [searchSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            
            //Get current location
            [self getCurrentLocation];

            
        }
        
    } else {
        
        //Location Services are disabled on device
    
        
        //Disable location button on segmented controller
        [searchSegmentedControl setEnabled:NO forSegmentAtIndex:0];
        //Change default selection to search by city
        [searchSegmentedControl setSelectedSegmentIndex:1];
        
        //Set search current location to false
        searchCurrentLocation = FALSE;

    }
    
    //Call method to determine how to search
    [self howToSearch:searchSegmentedControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

//Method to check when search bar finishes editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
}

//Called when search button is clicked on keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //Call method to search for vegan restaurants
    [self searchForVeganRestaurants:nil];
    
    //Dismiss keyboard
    [self.view endEditing:YES];
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
    
    if (segmentControlSelected == 0) {
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
    
    //Hide location search bar
    location.hidden = TRUE;
}

//Method called when segmented control is set to "search by city/state"
- (void)searchCityState {
    
    //Show location search bar
    location.hidden = FALSE;
}

#pragma mark - Current Location

//Method to get user's current location
- (void)getCurrentLocation {
    
    if ([self isNetworkConnected]) {
        
        //Create location manager object
        //locationMgr = [[CLLocationManager alloc]init];
        if (locationMgr != nil) {
            
            //Request permission to access location
            [locationMgr requestWhenInUseAuthorization];
            
            //Set location accuracy
            locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
            //Set delegate
            locationMgr.delegate = self;
            //Start gathering location info
            [locationMgr startUpdatingLocation];
        }
    }
    
}

//Delegate method to get current locations
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    //Get location data for the most recent location obtained
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        //Get coordinates of current location
        CLLocationCoordinate2D coordinates = currentLocation.coordinate;
        
        //Convert latitude/longitude coordinates to strings
        latitudeCoord = [NSString stringWithFormat:@"%g", coordinates.latitude];
        longitudeCoord = [NSString stringWithFormat:@"%g", coordinates.longitude];
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

//Method called when picker choice changes
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (row) {
        case 0:
            //User selected first row
            pickerChoiceSelected = @"5"; //Vegan
            break;
            
        case 1:
            //User selected second row
            pickerChoiceSelected = @"4"; //Vegetarian
            break;
            
        case 2:
            //User selected 3rd row
            pickerChoiceSelected = @"2"; //Veg-Friendly
            break;
            
        default:
            pickerChoiceSelected = @"5"; //Default choice is vegan
            break;
    }
}

#pragma mark - VegGuide API Calls

//Method to request data from VegGuide API
-(IBAction)searchForVeganRestaurants:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        //Check how user wants to search
        if (searchCurrentLocation) {
            //User has chosen to search by current location
            
            //String used to access API
            partialURL = @"https://www.vegguide.org/search/by-lat-long/";
            //Create a string to hold latititude/longitude coordinates
            NSString *coordinates = [NSString stringWithFormat:@"%@,%@", latitudeCoord, longitudeCoord];
            
            //Add coordinates term to url for API call
            completeURL = [partialURL stringByAppendingString:coordinates];
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        } else {
            //User wants to search by address
            partialURL = @"https://www.vegguide.org/search/by-address/";
            
            //Get string user entered in search field
            NSString *userEnteredLocation = location.text;
            
            //Encode text user entered
            NSString *encodedLocation = [userEnteredLocation stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            //Append string to form complete URL
            completeURL = [partialURL stringByAppendingString:encodedLocation];
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
        }
        
        //Set up URL for API call
        urlForAPICall = [[NSURL alloc] initWithString:filterURL];
        
        //Set up request to send to server
        requestForData = [[NSMutableURLRequest alloc]initWithURL:urlForAPICall];
        if (requestForData != nil) {
            
            [requestForData setValue:userAgent forHTTPHeaderField:@"User-Agent"];
            
            //Set up connection to get data from the server
            apiConnection = [[NSURLConnection alloc]initWithRequest:requestForData delegate:self];
            //Create mutableData object to hold data
            dataRetrieved = [NSMutableData data];
        }
        
    } else {
        
        //No network connection
        
        //Alert user
        UIAlertController *noConnection = [UIAlertController alertControllerWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noConnection addAction:defaultOk];
        //Show alert
        [self presentViewController:noConnection animated:YES completion:nil];
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
    
    //Serialize JSON data
    dictOfJSONData = [NSJSONSerialization JSONObjectWithData:dataRetrieved options:0 error:nil];
    //Get restaurant entries from JSON data
    NSArray *restaurantsRetrieved = [dictOfJSONData objectForKey:@"entries"];
    
    if (restaurantsRetrieved != nil) {
        //Results were found
        //Loop through all results retrieved from API call
        for (int i=0; i<[restaurantsRetrieved count]; i++) {
            //Use custom method to grab each object from dictionary and add each object to the NSMutableArray
            VeganRestaurant *veganRestDetails = [self createRestaurantObjects:[restaurantsRetrieved objectAtIndex:i]];
            if (veganRestDetails != nil) {
                //Add object to array
                [restaurantObjects addObject:veganRestDetails];
            }
        }
        
        //Instantiate results view controller
        RestaurantResultsTVC *restResultsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantResultsViewController"];
        //Pass the array of VeganRestaurant objects to the Restaurant Results vc
        restResultsTVC.arrayOfRestaurantObjs = restaurantObjects;
        //Push view controller onto screen
        [self.navigationController pushViewController:restResultsTVC animated:YES];
        
    } else {
        //No results found
        //Alert user no results were found
        UIAlertController *noResults = [UIAlertController alertControllerWithTitle:@"No Results Found" message:@"No restaurants found. Please revise your search and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noResults addAction:defaultOk];
        //Show alert
        [self presentViewController:noResults animated:YES completion:nil];
    }
    
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(VeganRestaurant*)createRestaurantObjects:(NSDictionary*)restaurantsDictionary {
    
    //Get items from the dictionary of data received from API call
    
    NSString *restaurantsName = [restaurantsDictionary valueForKey:@"name"];
    NSString *restaurantsAddress = [restaurantsDictionary valueForKey:@"address1"];
    NSString *restaurantsCity = [restaurantsDictionary valueForKey:@"city"];
    NSString *restaurantsState = [restaurantsDictionary valueForKey:@"region"];
    NSString *restaurantsZip = [restaurantsDictionary valueForKey:@"postal_code"];
    NSString *restaurantsPhone = [restaurantsDictionary valueForKey:@"phone"];
    NSString *restaurantsWebsite = [restaurantsDictionary valueForKey:@"website"];
    NSString *restaurantReviewURI = [restaurantsDictionary valueForKey:@"reviews_uri"];
    NSString *restaurantRating = [restaurantsDictionary valueForKey:@"weighted_rating"];
    
    NSString *restaurantPriceRange = [restaurantsDictionary valueForKey:@"price_range"];
    NSString *restaurantVegLevel = [restaurantsDictionary valueForKey:@"veg_level"];
    NSString *restaurantDesc = [restaurantsDictionary valueForKey:@"short_description"];
    
    NSArray *arrayOfImages = [restaurantsDictionary valueForKey:@"images"];
    NSArray *imageFiles = [arrayOfImages valueForKey:@"files"];
    NSArray *arrayOfImgURIs = [imageFiles valueForKey:@"uri"];
    //Grab 1st image
    NSArray *arrayOfImgSizes = [arrayOfImgURIs objectAtIndex:0];
    //Grab small size
    NSString *uriForImg = [arrayOfImgSizes objectAtIndex:1];
    
    NSDictionary *fullDescription = [restaurantsDictionary valueForKey:@"long_description"];
    NSString *restDescStr = [fullDescription valueForKey:@"text/vnd.vegguide.org-wikitext"];
    
    //If zip returns null value, set it to an empty string
    if (restaurantsZip == nil) {
        restaurantsZip = @"";
    }
    
    //Use object's custom init method to initalize object
    VeganRestaurant *newRestaurant = [[VeganRestaurant alloc] initWithRestaurant:restaurantsName addressOfRestaurant:restaurantsAddress cityOfRestaurant:restaurantsCity stateOfRestaurant:restaurantsState zipOfRestaurant:restaurantsZip phoneNo:restaurantsPhone urlOfRestaurant:restaurantsWebsite reviewsOfRestaurant:restaurantReviewURI rating:restaurantRating restPriceRange:restaurantPriceRange restVegLevel:restaurantVegLevel restDesc:restaurantDesc restImgURI:uriForImg fullDesc:restDescStr];
    
    return newRestaurant;
}

//Method to check if network is connected
- (BOOL) isNetworkConnected
{
    Reachability *currentConnection = [Reachability reachabilityForInternetConnection];
    if ([currentConnection isReachable]) {
        //Network connection active, return true
        return TRUE;
    } else {
        //No network connection        
        return FALSE;
    }
}

@end
