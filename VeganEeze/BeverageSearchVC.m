//
//  BeverageSearchVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "BeverageSearchVC.h"
#import "AlcoholBeverage.h"

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
}

//Method to create custom AlcoholBeverage objects and initalize each object
-(AlcoholBeverage*)createAlcoholBeverageObjects:(NSDictionary*)alcoholBevDictionary {
    //Get items from the dictionary of data received from API call
    NSString *alcoholBevName = [alcoholBevDictionary valueForKey:@""];
    NSString *alcoholBrandName = [alcoholBevDictionary valueForKey:@""];
    NSString *alcoholVeganStatus = [alcoholBevDictionary valueForKey:@""];
    
    //Use object's custom init method to initalize object
    AlcoholBeverage *newAlcoholBev = [[AlcoholBeverage alloc]initWithBeverage:alcoholBevName brandDesc:alcoholBrandName veganStatus:alcoholVeganStatus];
    
    return newAlcoholBev;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
