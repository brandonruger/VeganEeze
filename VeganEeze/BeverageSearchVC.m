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
    
    //Set bool to false since data has not been retrieved yet
    dataRetrievalComplete = false;
    
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
    [self performSegueWithIdentifier:@"segueToBeverageResults" sender:self];
    
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
    
    
    //String used to access API
    NSString *partialURL = @"http://barnivore.com/search.json?keyword=";
    //Get search term entered by user
    searchKeyword = beverageName.text;
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

//Method called when data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //Check to make sure data is valid
    if (data != nil) {
        //Add this data to mutableData object
        [dataRetrieved appendData:data];
    }
}

///Method called when all data from request has been retrieved
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Serialize JSON data
    arrayOfJSONData = [NSJSONSerialization JSONObjectWithData:dataRetrieved options:0 error:nil];
    //NSDictionary *firstItemRetrieved = [arrayOfJSONData objectAtIndex:0];
    //NSLog(@"firstItem = %@", [firstItemRetrieved description]);
    
    //Loop through all results retrieved from API call
    for (int i=0; i<[arrayOfJSONData count]; i++) {
        //Use custom method to grab each object from dictionary and add each object to the NSMutableArray
        AlcoholBeverage *alcoholBevDetails = [self createAlcoholBeverageObjects:[arrayOfJSONData objectAtIndex:i]];
        if (alcoholBevDetails != nil) {
            //Add object to array
            [alcoholBeverageObjects addObject:alcoholBevDetails];
        }
    }
    
    BeverageResultsTVC *bevResultsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BeverageResultsViewController"];
    //Pass the array of AlcoholBeverage objects to the Beverage Results vc
    bevResultsTVC.arrayOfAlcoholBeverages = alcoholBeverageObjects;
    //Instantiate new view controller
    [self.navigationController pushViewController:bevResultsTVC animated:YES];

    
    //Set bool to true since data retrieval is complete
    dataRetrievalComplete = TRUE;
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(AlcoholBeverage*)createAlcoholBeverageObjects:(NSDictionary*)alcoholBevDictionary {
    //Get items from the dictionary of data received from API call
    
    //NSString *company = [alcoholBevDictionary valueForKey:@"company"];
    NSDictionary *beverageDictionary = [alcoholBevDictionary objectForKey:@"company"];
    
    NSString *alcoholBevName = [beverageDictionary valueForKey:@"company_name"];
    NSString *alcoholBrandName = [beverageDictionary valueForKey:@"company_name"];
    NSString *alcoholVeganStatus = [beverageDictionary valueForKey:@"status"];
    
    //Use object's custom init method to initalize object
    AlcoholBeverage *newAlcoholBev = [[AlcoholBeverage alloc]initWithBeverage:alcoholBevName brandDesc:alcoholBrandName veganStatus:alcoholVeganStatus];
    
    return newAlcoholBev;
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    //Access Beverage Results view controller
//    BeverageResultsTVC *bevResultsTVC = (BeverageResultsTVC *) segue.destinationViewController;
//    if (bevResultsTVC != nil) {
//        //Pass the array of AlcoholBeverage objects to the Beverage Results vc
//        bevResultsTVC.arrayOfAlcoholBeverages = alcoholBeverageObjects;
//        //bevResultsTVC.arrayOfAlcoholBeverages = [[NSArray alloc]initWithArray:alcoholBeverageObjects];
//    }
//    
//}
//
////Prevent segue from going until data is retrieved
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    if ([identifier isEqualToString:@"segueToBeverageResults"]) {
//        //Check if data retrieval is complete
//        if (dataRetrievalComplete) {
//            //Data retrieval is complete, OK to perform segue
//            return TRUE;
//        } else {
//            //Data retrieval is incomplete, don't perform segue
//            return FALSE;
//        }
//        
//    }
//    return FALSE;
//
//}


@end
