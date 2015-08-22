//
//  SavedPlacesDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/22/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "SavedPlacesDetailVC.h"
#import "WebVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface SavedPlacesDetailVC ()

@end

@implementation SavedPlacesDetailVC
//@synthesize name, address, cityState, phoneNo, url;
@synthesize objectId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup queries to check both classes for object ID
    PFQuery *favoritePlaceQuery = [PFQuery queryWithClassName:@"FavoritePlace"];
    PFQuery *placeToVisitQuery = [PFQuery queryWithClassName:@"PlaceToVisit"];
    
    //Run first query to check for object ID
    [favoritePlaceQuery getObjectInBackgroundWithId:objectId block:^(PFObject *savedPlace, NSError *error) {
        
        if (!error) {
            //Object ID was found
            //Get strings out of object
            nameOfPlace = savedPlace[@"name"];
            addressOfPlace = savedPlace[@"address"];
            cityStateOfPlace = savedPlace[@"cityState"];
            urlOfPlace = savedPlace[@"url"];
            phoneNoOfPlace = savedPlace[@"phoneNo"];
            
            //Set text labels to above object
            nameLabel.text = nameOfPlace;
            addressLabel.text = addressOfPlace;
            cityStateLabel.text = cityStateOfPlace;
            phoneLabel.text = phoneNoOfPlace;
            
            //Set button text
            [urlLabel setTitle:urlOfPlace forState:UIControlStateNormal];
            
        } else {
            //Run second query to check for Object ID
            [placeToVisitQuery getObjectInBackgroundWithId:objectId block:^(PFObject *savedPlace, NSError *error) {
                
                if (!error) {
                    //Object ID was found
                    //Get strings out of object
                    nameOfPlace = savedPlace[@"name"];
                    addressOfPlace = savedPlace[@"address"];
                    cityStateOfPlace = savedPlace[@"cityState"];
                    urlOfPlace = savedPlace[@"url"];
                    phoneNoOfPlace = savedPlace[@"phoneNo"];
                    
                    //Set text labels to above object
                    nameLabel.text = nameOfPlace;
                    addressLabel.text = addressOfPlace;
                    cityStateLabel.text = cityStateOfPlace;
                    phoneLabel.text = phoneNoOfPlace;
                    
                    //Set button text
                    [urlLabel setTitle:urlOfPlace forState:UIControlStateNormal];
                }
            }];
        }
        
    }];
    
//    //Run query on both classes searching for current object ID that was passed over through segue
//    PFQuery *queryBoth = [PFQuery orQueryWithSubqueries:@[favoritePlaceQuery, placeToVisitQuery]];
//    [queryBoth getObjectInBackgroundWithId:objectId block:^(PFObject *savedPlace, NSError *error) {
//        if (!error) {
//            //Object was found for this object ID
//            //Get strings out of object
//            nameOfPlace = savedPlace[@"name"];
//            addressOfPlace = savedPlace[@"address"];
//            cityStateOfPlace = savedPlace[@"cityState"];
//            urlOfPlace = savedPlace[@"url"];
//            phoneNoOfPlace = savedPlace[@"phoneNo"];
//            
//            //Set text labels to above object
//            nameLabel.text = nameOfPlace;
//            addressLabel.text = addressOfPlace;
//            cityStateLabel.text = cityStateOfPlace;
//            phoneLabel.text = phoneNoOfPlace;
//            
//            //Set button text
//            [urlLabel setTitle:urlOfPlace forState:UIControlStateNormal];
//        }
//    }];
    
    //Access user's Twitter account on device
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    if (accountStore != nil) {
        //Tell what type of account need to access
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (accountType != nil) {
            //Ask account store for direct access to Twitter account
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    //Success, we have access
                    NSArray *userTwitterAccts = [accountStore accountsWithAccountType:accountType];
                    if (userTwitterAccts != nil) {
                        //Access single account
                        ACAccount *currentAcct = [userTwitterAccts objectAtIndex:0];
                        if (currentAcct != nil) {
                            NSLog(@"currentAccount=%@", currentAcct);
                        }
                        NSLog(@"twitter accounts = %@", userTwitterAccts);
                    }
                }
                else {
                    //User did not approve accessing Twitter account
                    
                    //***NEED TO HANDLE THIS***
                }
            }];
        }
    }

}

#pragma mark - Twitter Sharing
-(IBAction)shareToTwitter:(id)sender {
    
    //Create view that allows user to post to Twitter
    SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterPrefixString = @"Check this place out: ";
    NSString *twitterFullString = [twitterPrefixString stringByAppendingString:urlOfPlace];
    
    //Add in default text to share
    [slComposeVC setInitialText:twitterFullString];
    
    //Present view to user for posting
    [self presentViewController:slComposeVC animated:TRUE completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set event labels to display information passed over from segue
//    nameLabel.text = name;
//    addressLabel.text = address;
//    cityStateLabel.text = cityState;
//    phoneLabel.text = phoneNo;
//    
//    //Set URL button text
//    [urlLabel setTitle:url forState:UIControlStateNormal];
    
}

#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass restaurant's URL to web view
    webVC.websiteStr = urlOfPlace;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
