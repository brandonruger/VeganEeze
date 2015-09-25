//
//  BeverageSearchVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "BeverageSearchVC.h"
#import "AlcoholBeverage.h"
#import "BeverageResultsTVC.h"
#import "Reachability.h"

@interface BeverageSearchVC ()

@end

@implementation BeverageSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set search bar delegate
    beverageName.delegate = self;
    
    //Inititalize NSMutableArray which will hold AlcoholBeverage objects
    alcoholBeverageObjects = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Clear text from search field
    beverageName.text = @"";
    
    //Remove all objects from array
    if (alcoholBeverageObjects != nil) {
        [alcoholBeverageObjects removeAllObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar

//Called when search button is clicked on keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //Call method to search for beverages
    [self searchAlcoholBeveragesAPI:nil];
    
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

#pragma mark - Barnivore API calls

//Method to request data from Barnivore API
-(IBAction)searchAlcoholBeveragesAPI:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        
        //String used to access API
        NSString *partialURL = @"http://barnivore.com/search.json?keyword=";
        
        //Get text user entered in search field
        NSString *searchKeywordEntered = beverageName.text;
        
        if ([searchKeywordEntered isEqualToString:@""]) {
            //Alert user that they must enter in a search term
            UIAlertController *blankAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must enter in a keyword in order to search. Please enter a brand or type of beverage to search for and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //Add action to alert controller
            [blankAlert addAction:defaultOk];
            //Show alert
            [self presentViewController:blankAlert animated:YES completion:nil];
            
        } else {
            
            //Encode text
            searchKeyword = [searchKeywordEntered stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //Add search term to url for API call
            NSString *completeURL = [partialURL stringByAppendingString:searchKeyword];
            
            //Set up URL for API call
            urlForAPICall = [[NSURL alloc] initWithString:completeURL];
            
            //Set up request to send to server
            requestForData = [[NSURLRequest alloc]initWithURL:urlForAPICall];
            if (requestForData != nil) {
                //Set up connection to get data from the server
                apiConnection = [[NSURLConnection alloc]initWithRequest:requestForData delegate:self];
                //Create mutableData object to hold data
                dataRetrieved = [NSMutableData data];
            }
        }
        
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
    arrayOfJSONData = [NSJSONSerialization JSONObjectWithData:dataRetrieved options:0 error:nil];
    
    //Check to see if any data was found
    if (arrayOfJSONData == nil || [arrayOfJSONData count] == 0) {
        
        //Alert user that no results were found
        UIAlertController *noResultsFound = [UIAlertController alertControllerWithTitle:@"No Results Found" message:@"No results were found based on your search. Please revise your search and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        //Add action to alert controller
        [noResultsFound addAction:defaultOk];
        //Show alert
        [self presentViewController:noResultsFound animated:YES completion:nil];
        
    } else {
        //Loop through all results retrieved from API call
        for (int i=0; i<[arrayOfJSONData count]; i++) {
            //Use custom method to grab each object from dictionary and add each object to the NSMutableArray
            AlcoholBeverage *alcoholBevDetails = [self createAlcoholBeverageObjects:[arrayOfJSONData objectAtIndex:i]];
            if (alcoholBevDetails != nil) {
                //Add object to array
                [alcoholBeverageObjects addObject:alcoholBevDetails];
            }
        }
        
        //Instantiate beverage results view controller
        BeverageResultsTVC *bevResultsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BeverageResultsViewController"];
        //Pass the array of VeganRestaurant objects to the Restaurant Results vc
        bevResultsVC.arrayOfAlcoholBeverages = alcoholBeverageObjects;
        //Push view controller onto the screen
        [self.navigationController pushViewController:bevResultsVC animated:YES];
    }
    
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(AlcoholBeverage*)createAlcoholBeverageObjects:(NSDictionary*)alcoholBevDictionary {
    
    //Get items from the dictionary of data received from API call
    NSDictionary *beverageDictionary = [alcoholBevDictionary objectForKey:@"company"];
    
    NSString *alcoholBevName = [beverageDictionary valueForKey:@"company_name"];
    NSString *alcoholBrandName = [beverageDictionary valueForKey:@"company_name"];
    NSString *alcoholVeganStatus = [beverageDictionary valueForKey:@"status"];
    
    //Use object's custom init method to initalize object
    AlcoholBeverage *newAlcoholBev = [[AlcoholBeverage alloc]initWithBeverage:alcoholBevName brandDesc:alcoholBrandName veganStatus:alcoholVeganStatus];
    
    return newAlcoholBev;
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
