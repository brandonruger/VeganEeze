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

@interface FindARestaurantVC ()

@end

@implementation FindARestaurantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set search bars' delegate
    //keyword.delegate = self;
    location.delegate = self;
    
    //Setup array with choices for picker
    pickerChoices = [[NSArray alloc]initWithObjects:@"Vegan", @"Vegetarian", @"Veg-Friendly", nil];
    
    //Connect picker view to delegates
    veganChoicePicker.dataSource = self;
    veganChoicePicker.delegate = self;
    
    searchCurrentLocation = TRUE;
    
    //Set default for picker choice
    pickerChoiceSelected = @"5";
    
    //Get current location
    [self getCurrentLocation];
    
    //Add target selectors to segmented control buttons
    [searchSegmentedControl addTarget:self action:@selector(howToSearch:) forControlEvents:UIControlEventValueChanged];
    
    //Initialize NSMutableArray which will hold VeganRestaurant objects
    restaurantObjects = [[NSMutableArray alloc]init];
    
    //Set user agent for API call
    userAgent = @"VeganEeze App/v1.0";
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Clear text from search bars
    //keyword.text = @"";
    location.text = @"";
    
    //searchKeyword = @"";
    
    //Remove all objects from array
    if (restaurantObjects != nil) {
        [restaurantObjects removeAllObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

////Method to check if search bars are editing so cancel button can be displayed
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    
//    //Show cancel button
//    cancelButton.hidden = false;
//}

//Method to check when search bar finishes editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    //Dismiss keyboard
    [self.view endEditing:YES];
    
    //Hide cancel button
    //cancelButton.hidden = true;
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
        
        //NSLog(@"Latitude = %@", latitudeCoord);
        //NSLog(@"Longitude = %@", longitudeCoord);
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
    
    //Get text user entered in keyword field
    //NSString *keywordText = keyword.text;
    
    //Encode text user entered
    //searchKeyword = [keywordText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    //Set search keyword to keyword user entered
//    searchKeyword = keyword.text;
    
    
    //Check how user wants to search
    if (searchCurrentLocation) {
        //User has chosen to search by current location
        
        //String used to access API
        partialURL = @"https://www.vegguide.org/search/by-lat-long/";
        //Create a string to hold latititude/longitude coordinates
        NSString *coordinates = [NSString stringWithFormat:@"%@,%@", latitudeCoord, longitudeCoord];
        
        //Add coordinates term to url for API call
        completeURL = [partialURL stringByAppendingString:coordinates];
        
        //Check if user entered a search keyword or not
        //if ([searchKeyword isEqualToString:@""]) {
            //User did not enter a keywrod
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
//        } else {
//            //User entered a search keyword, need to add it to URL
//            
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@;key1=%@", pickerChoiceSelected, searchKeyword];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        }
        
//        //Add filter to search
//        NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
//        
//        //Add filter to completed URL
//        filterURL = [completeURL stringByAppendingString:searchFilter];
        
        //NSLog(@"completeURL= %@", completeURL);
        //NSLog(@"coordinates= %@", coordinates);
        
    } else {
        //User wants to search by address
        partialURL = @"https://www.vegguide.org/search/by-address/";
        
        //Get string user entered in search field
        NSString *userEnteredLocation = location.text;
        
        //Encode text user entered
        NSString *encodedLocation = [userEnteredLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //Append string to form complete URL
        completeURL = [partialURL stringByAppendingString:encodedLocation];
        
        //Check if user entered a search keyword or not
        //if ([searchKeyword isEqualToString:@""]) {
            //User did not enter a keywrod
            
            //Add filter to search
            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
            
            //Add filter to completed URL
            filterURL = [completeURL stringByAppendingString:searchFilter];
            
//        } else {
//            //User entered a search keyword, need to add it to URL
//            
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@;key1=%@", pickerChoiceSelected, searchKeyword];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        }
        
//        //Add filter to search
//        NSString *searchFilter = [NSString stringWithFormat:@"/filter/category_id=1;veg_level=%@", pickerChoiceSelected];
//        
//        //Add filter to completed URL
//        filterURL = [completeURL stringByAppendingString:searchFilter];
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
    
    //NSString *strData = [[NSString alloc]initWithData:dataRetrieved encoding:NSUTF8StringEncoding];
    
    //NSLog(@"reviewData = %@", strData);
    
    //Serialize JSON data
    dictOfJSONData = [NSJSONSerialization JSONObjectWithData:dataRetrieved options:0 error:nil];
    //NSDictionary *firstItemRetrieved = [arrayOfJSONData objectAtIndex:0];
    NSArray *restaurantsRetrieved = [dictOfJSONData objectForKey:@"entries"];
   // NSLog(@"firstItem = %@", [firstItemRetrieved description]);
    
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
        
        RestaurantResultsTVC *restResultsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantResultsViewController"];
        //Pass the array of VeganRestaurant objects to the Restaurant Results vc
        restResultsTVC.arrayOfRestaurantObjs = restaurantObjects;
        //Instantiate new view controller
        [self.navigationController pushViewController:restResultsTVC animated:YES];
    } else {
        //No results found
        //Alert user no results were found
        UIAlertView *noResults = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No restaurants found. Please revise your search and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noResults show];
    }
    
    
    
    //Set bool to true since data retrieval is complete
    //dataRetrievalComplete = TRUE;
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(VeganRestaurant*)createRestaurantObjects:(NSDictionary*)restaurantsDictionary {
    //Get items from the dictionary of data received from API call
    
    
    //NSString *company = [alcoholBevDictionary valueForKey:@"company"];
    //NSArray *vegRestaurants = [restaurantsDictionary objectForKey:@"entries"];
    
    NSString *restaurantsName = [restaurantsDictionary valueForKey:@"name"];
    NSLog(@"restaurantsName = %@", restaurantsName);
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
    NSLog(@"uriForImg = %@", uriForImg);
    //Grab first image
    //UIImage *restaurantImage = [arrayOfImages objectAtIndex:0];
    
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

@end
