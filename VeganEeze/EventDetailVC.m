//
//  EventDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EventDetailVC.h"
#import "WebVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface EventDetailVC ()

@end

@implementation EventDetailVC
@synthesize eventName, eventAddress, eventCityState, eventPhoneNo, eventURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    NSString *twitterPrefixString = @"Checkout this event: ";
    NSString *twitterFullString = [twitterPrefixString stringByAppendingString:eventURL];
    
    //Add in default text to share
    [slComposeVC setInitialText:twitterFullString];
    
    //Present view to user for posting
    [self presentViewController:slComposeVC animated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set event labels to display information passed over from segue
    eventNameLabel.text = eventName;
    eventAddressLabel.text = eventAddress;
    eventCityStateLabel.text = eventCityState;
    eventPhoneLabel.text = eventPhoneNo;
    
    //Set URL button text
    [eventUrlLabel setTitle:eventURL forState:UIControlStateNormal];
    
    //Set phone # to appear in text view
    phoneNoTV.text = eventPhoneNo;
    
}

#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass restaurant's URL to web view
    webVC.websiteStr = eventURL;
    
}

#pragma mark - Save Favorites

//Method to save favorite places to Parse
-(IBAction)saveFavoritePlace:(id)sender {
    //Gather data for current restaurant and save as a favoritePlace Parse object
    PFObject *favoritePlace = [PFObject objectWithClassName:@"FavoritePlace"];
    favoritePlace[@"name"] = eventName;
    favoritePlace[@"address"] = eventAddress;
    favoritePlace[@"cityState"] = eventCityState;
    favoritePlace[@"phoneNo"] = eventPhoneNo;
    favoritePlace[@"url"] = eventURL;
    //Restrict data to this user only
    favoritePlace.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

    
    //Save in background on Parse server
    [favoritePlace saveInBackground];
}


//Method to save places to visit to Parse
-(IBAction)savePlaceToVisit:(id)sender {
    //Gather data for current restaurant and save as a placeToVisit Parse object
    PFObject *placeToVisit = [PFObject objectWithClassName:@"PlaceToVisit"];
    placeToVisit[@"name"] = eventName;
    placeToVisit[@"address"] = eventAddress;
    placeToVisit[@"cityState"] = eventCityState;
    placeToVisit[@"phoneNo"] = eventPhoneNo;
    placeToVisit[@"url"] = eventURL;
    //Restrict data to this user only
    placeToVisit.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

    
    //Save in background on Parse server
    [placeToVisit saveInBackground];
}


@end
