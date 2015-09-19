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
    
    appKey = @"&app_key=VrdtgSDWhZCHjRcK";
    
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

////Method to check if search bars are editing so cancel button can be displayed
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    
//    //Show cancel button
//    cancelButton.hidden = false;
//}

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
    //cancelButton.hidden = true;
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
            pickerChoiceSelected = @"veg+friendly"; //Vegan-Friendly
        default:
            pickerChoiceSelected = @"vegan"; //Default choice is vegan
            break;
    }
}

#pragma mark - Eventful API calls

//API key- VrdtgSDWhZCHjRcK

//Format = http://api.eventful.com/json/events/search?...&location=San+Diego

-(IBAction)searchVeganEvents:(id)sender {
    
    //Get text user entered in keyword field
    NSString *keywordText = keyword.text;
    
    //Encode text user entered
    searchKeyword = [keywordText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //Check how user wants to search
    if (searchCurrentLocation) {
        //User has chosen to search by current location
        
        //String used to access API
        partialURL = @"http://api.eventful.com/json/events/search?q=";
        
        //Add on picker choice selected to URL
        partialURL = [partialURL stringByAppendingString:pickerChoiceSelected];
        
        NSString *locationCoordinates = [NSString stringWithFormat:@"&l=%@,%@&within=40&units=miles", latitudeCoord, longitudeCoord];
        
        //Add location
        NSString *locationURL = [partialURL stringByAppendingString:locationCoordinates];
        
        //Add App key
        completeURL = [locationURL stringByAppendingString:appKey];
        
        NSLog(@"completeURL = %@", completeURL);
        
//        //Check if user entered a search keyword or not
//        if ([searchKeyword isEqualToString:@""]) {
//            //User did not enter a keywrod
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"%@", pickerChoiceSelected];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        } else {
//            //User entered a search keyword, need to add it to URL
//            
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"%@,%@", pickerChoiceSelected, searchKeyword];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        }

    } else {
        //User wants to search by address
        partialURL = @"http://api.eventful.com/json/events/search?q=";
        
        //Add on picker choice selected to URL
        partialURL = [partialURL stringByAppendingString:pickerChoiceSelected];
        
        //Get string user entered in search field
        NSString *userEnteredLocation = location.text;
        
        //Encode text user entered
        NSString *encodedLocation = [userEnteredLocation stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *locationToSearch = [NSString stringWithFormat:@"&l=%@", encodedLocation];
        
        //Append string to form complete URL
        NSString *locationURL = [partialURL stringByAppendingString:locationToSearch];
        
        //Add App key
        completeURL = [locationURL stringByAppendingString:appKey];
        NSLog(@"completeURL = %@", completeURL);
        
//        //Check if user entered a search keyword or not
//        if ([searchKeyword isEqualToString:@""]) {
//            //User did not enter a keywrod
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"%@", pickerChoiceSelected];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        } else {
//            //User entered a search keyword, need to add it to URL
//            
//            
//            //Add filter to search
//            NSString *searchFilter = [NSString stringWithFormat:@"%@,%@", pickerChoiceSelected, searchKeyword];
//            
//            //Add filter to completed URL
//            filterURL = [completeURL stringByAppendingString:searchFilter];
//            
//        }
        
    }
    
    //Set up URL for API call
    urlForAPICall = [[NSURL alloc] initWithString:completeURL];
    
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
    
    dictOfJSONData = [NSJSONSerialization JSONObjectWithData:dataRetrieved options:0 error:nil];
    
    
    //NSArray *eventsRetrieved = [dictOfJSONData objectForKey:@"events"];
    NSDictionary *eventsRetrieved = [dictOfJSONData objectForKey:@"events"];
    NSArray *eventsRetrievedArray = [eventsRetrieved valueForKey:@"event"];
    
    //Check to make sure array is not null or empy
    if ([eventsRetrievedArray isEqual:[NSNull null]]) {
        
        //Alert user no results were found
        UIAlertView *noResults = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No events found. Please revise your search and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noResults show];
        
        
        
    } else {
        //Results found
        
        if ([eventsRetrievedArray isKindOfClass:[NSArray class]]) {
            
            for (int i=0; i<[eventsRetrievedArray count]; i++) {
                
                //Use custom method to grab each object from dictionary and add each object to mutable array
                VeganEvent *event = [self createEventObjects:[eventsRetrievedArray objectAtIndex:i]];
                if (event != nil) {
                    //Add object to array
                    [eventObjects addObject:event];
                }
            }
            
       
        } else if([eventsRetrievedArray isKindOfClass:[NSDictionary class]]){

            
            
            
      //  } else {
            VeganEvent *singleEvent = [self createSingleEvent:eventsRetrievedArray];
            if (singleEvent != nil) {
                //Add object to array
                [eventObjects addObject:singleEvent];
        }
        
//        if ([eventsRetrievedArray valueForKey:@"venue_name"] != nil) {
//            //Only 1 result found, create event object
//            
//            VeganEvent *singleEvent = [self createSingleEvent:eventsRetrievedArray];
//            if (singleEvent != nil) {
//                //Add object to array
//                [eventObjects addObject:singleEvent];
//            }
//            
//            
//        } else {
            
            //Multiple results found
            
            //Loop through array of events
//            for (int i=0; i<[eventsRetrievedArray count]; i++) {
//                
//                //Use custom method to grab each object from dictionary and add each object to mutable array
//                VeganEvent *event = [self createEventObjects:[eventsRetrievedArray objectAtIndex:i]];
//                if (event != nil) {
//                    //Add object to array
//                    [eventObjects addObject:event];
//                }
//            }
//            
//
//        }
        }
        
                EventResultsTVC *eventResultsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventResultsViewController"];
        //Pass the array of VeganEvent objects to the Results view controller
        eventResultsTVC.arrayOfEvents = eventObjects;
        //Instantiate new view controller
        [self.navigationController pushViewController:eventResultsTVC animated:YES];
    }
    
    
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(VeganEvent*)createEventObjects:(NSDictionary*)eventDictionary {

    NSString *eventName = [eventDictionary valueForKey:@"title"];
    NSLog(@"eventName = %@", eventName);
    NSString *eventAddress = [eventDictionary valueForKey:@"venue_address"];
    NSString *eventCity = [eventDictionary valueForKey:@"city_name"];
    NSString *eventState = [eventDictionary valueForKey:@"region_abbr"];
    NSString *eventZip = [eventDictionary valueForKey:@"postal_code"];
    //NSString *eventPhone = [eventDictionary valueForKey:@""];
    NSString *eventWebsite = [eventDictionary valueForKey:@"url"];
    NSString *eventID = [eventDictionary valueForKey:@"id"];
    
    NSString *description = [eventDictionary valueForKey:@"description"];
    if (description != nil) {
        //Format description to make sure HTML tags are removed
        NSAttributedString *eventDescFormatted =[[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        descriptionStrFinal = [eventDescFormatted string];
    }
    
    
    NSString *startTime = [eventDictionary valueForKey:@"start_time"];
    NSString *venue = [eventDictionary valueForKey:@"venue_name"];
    NSString *price = [eventDictionary valueForKey:@"price"];
    NSLog(@"price = %@", price);
    
    NSDictionary *imagesDictionary = [eventDictionary valueForKey:@"image"];
    NSDictionary *smallImg = [imagesDictionary valueForKey:@"small"];
    singleImg = [smallImg valueForKey:@"url"];
    NSLog(@"singleImg = %@", singleImg);
    
    if ([singleImg isEqual:[NSNull null]]) {
     
        //Set image to an empty string
        singleImg = @"";
        
    }
    
    if ([eventZip isEqual:[NSNull null]] || eventZip == nil) {
        eventZip = @"";
    }
    
    //Get latitude/longitude of venue
    Float32 eventLatitude = [[eventDictionary objectForKey:@"latitude"] floatValue];
    Float32 eventLongitude = [[eventDictionary objectForKey:@"longitude"] floatValue];
    NSLog(@"Latitude = %f, longitude = %f", eventLatitude, eventLongitude);
    
    
    
    //Use object's custom init method to initialize object
    VeganEvent *newEvent = [[VeganEvent alloc] initWithEvent:eventName addressForEvent:eventAddress cityOfEvent:eventCity stateOfEvent:eventState zipOfEvent:eventZip websiteForEvent:eventWebsite idForEvent:eventID descOfEvent:descriptionStrFinal startTime:startTime venue:venue price:price imageURL:singleImg eventLatitude:eventLatitude eventLongitude:eventLongitude];
    
    return newEvent;
}

-(VeganEvent*)createSingleEvent:(NSArray*)singleEventArray {
    NSString *eventName = [singleEventArray valueForKey:@"title"];
    NSLog(@"eventName = %@", eventName);
    NSString *eventAddress = [singleEventArray valueForKey:@"venue_address"];
    NSString *eventCity = [singleEventArray valueForKey:@"city_name"];
    NSString *eventState = [singleEventArray valueForKey:@"region_abbr"];
    NSString *eventZip = [singleEventArray valueForKey:@"postal_code"];
    //NSString *eventPhone = [eventDictionary valueForKey:@""];
    NSString *eventWebsite = [singleEventArray valueForKey:@"url"];
    NSString *eventID = [singleEventArray valueForKey:@"id"];
    
    NSString *description = [singleEventArray valueForKey:@"description"];
    NSString *startTime = [singleEventArray valueForKey:@"start_time"];
    NSString *venue = [singleEventArray valueForKey:@"venue_name"];
    NSString *price = [singleEventArray valueForKey:@"price"];
    NSLog(@"price = %@", price);
    
    NSDictionary *imagesDictionary = [singleEventArray valueForKey:@"image"];
    NSDictionary *smallImg = [imagesDictionary valueForKey:@"small"];
    singleImg = [smallImg valueForKey:@"url"];
    NSLog(@"singleImg = %@", singleImg);
    
    if ([singleImg isEqual:[NSNull null]]) {
        
        //Set image to an empty string
        singleImg = @"";
        
    }
    
    if ([eventZip isEqual:[NSNull null]] || eventZip == nil) {
        eventZip = @"";
    }
    
    //Get latitude/longitude of venue
    Float32 eventLatitude = [[singleEventArray valueForKey:@"latitude"] floatValue];
    Float32 eventLongitude = [[singleEventArray valueForKey:@"longitude"] floatValue];
    NSLog(@"Latitude = %f, longitude = %f", eventLatitude, eventLongitude);
    
    
    
    //Use object's custom init method to initialize object
    VeganEvent *singleEvent = [[VeganEvent alloc] initWithEvent:eventName addressForEvent:eventAddress cityOfEvent:eventCity stateOfEvent:eventState zipOfEvent:eventZip websiteForEvent:eventWebsite idForEvent:eventID descOfEvent:description startTime:startTime venue:venue price:price imageURL:singleImg eventLatitude:eventLatitude eventLongitude:eventLongitude];
    
    return singleEvent;

}

@end
