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
#import "Reachability.h"
#import "CommentCell.h"

@interface SavedPlacesDetailVC ()

@end

@implementation SavedPlacesDetailVC
//@synthesize name, address, cityState, phoneNo, url;
@synthesize objectId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"objectID = %@", objectId);
    

    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Setup queries to check both classes for object ID
        PFQuery *favoritePlaceQuery = [PFQuery queryWithClassName:@"FavoritePlace"];
        PFQuery *placeToVisitQuery = [PFQuery queryWithClassName:@"PlaceToVisit"];
        
        //Run first query to check for object ID
        [favoritePlaceQuery getObjectInBackgroundWithId:objectId block:^(PFObject *savedPlace, NSError *error) {
            
            if (!error) {
                //Object ID was found
                //Get strings out of object
                nameOfPlace = savedPlace[@"name"];
                if (nameOfPlace != nil) {
                    nameLabel.text = nameOfPlace;
                }
                
                
                addressOfPlace = savedPlace[@"address"];
                //cityStateOfPlace = savedPlace[@"cityState"];
                if (addressOfPlace != nil) {
                    addressTV.text = addressOfPlace;
                } else {
                    addressTV.text = @"Address unknown";
                }
                
                urlOfPlace = savedPlace[@"url"];
                if (urlOfPlace == nil) {
                    //Disable website button
                    [urlLabel setEnabled:NO];
                }
                
                phoneNoOfPlace = savedPlace[@"phoneNo"];
                if (phoneNoOfPlace == nil) {
                    //Disable button
                    [phoneButton setEnabled:NO];
                }
                
                description = savedPlace[@"description"];
                if (description != nil) {
                    descriptionTV.text = description;
                } else {
                    descriptionTV.text = @"No description available";
                }
                
                itemID = savedPlace[@"itemID"];
                
                //Initialize array for reviews
                reviewsArray = [[NSMutableArray alloc]init];
                
                [self retrieveReviews: itemID];
                
                //Set text labels to above object
                
                //addressTV.text = addressOfPlace;
                
                //cityStateLabel.text = cityStateOfPlace;
                //phoneLabel.text = phoneNoOfPlace;
                
                
                //            //Format address for textview
                //            completeAddress = [NSString stringWithFormat:@"%@ \n%@", addressOfPlace, cityStateOfPlace];
                //            //Set textview to display address
                //            addressTV.text = completeAddress;
                
                //Set button text
                //[urlLabel setTitle:urlOfPlace forState:UIControlStateNormal];
                
                //Set phone # to appear in text view
                //phoneNoTV.text = phoneNoOfPlace;
                
            } else {
                //Run second query to check for Object ID
                [placeToVisitQuery getObjectInBackgroundWithId:objectId block:^(PFObject *savedPlace, NSError *error) {
                    
                    if (!error) {
                        //Object ID was found
                        //Get strings out of object
                        nameOfPlace = savedPlace[@"name"];
                        if (nameOfPlace != nil) {
                            nameLabel.text = nameOfPlace;
                        }
                        
                        addressOfPlace = savedPlace[@"address"];
                        if (addressOfPlace != nil) {
                            addressTV.text = addressOfPlace;
                        } else {
                            addressTV.text = @"Address unknown";
                        }
                        
                        
                        
                        //cityStateOfPlace = savedPlace[@"cityState"];
                        urlOfPlace = savedPlace[@"url"];
                        if (urlOfPlace == nil) {
                            [urlLabel setEnabled:NO];
                        }
                        
                        phoneNoOfPlace = savedPlace[@"phoneNo"];
                        if (phoneNoOfPlace == nil) {
                            //Disable button
                            [phoneButton setEnabled:NO];
                        }
                        
                        
                        description = savedPlace[@"description"];
                        if (description != nil) {
                            descriptionTV.text = description;
                        } else {
                            descriptionTV.text = @"No description available";
                        }
                        
                        itemID = savedPlace[@"itemID"];
                        
                        //Initialize array for reviews
                        reviewsArray = [[NSMutableArray alloc]init];
                        
                        [self retrieveReviews: itemID];
                        
                        
                        //Set text labels to above object
                        
                        //addressTV.text = addressOfPlace;
                        
                        //cityStateLabel.text = cityStateOfPlace;
                        //phoneLabel.text = phoneNoOfPlace;
                        
                        
                        //Format address for textview
                        //completeAddress = [NSString stringWithFormat:@"%@ \n%@", addressOfPlace, cityStateOfPlace];
                        //Set textview to display address
                        //addressTV.text = completeAddress;
                        
                        //Set button text
                        //[urlLabel setTitle:urlOfPlace forState:UIControlStateNormal];
                    }
                }];
            }
            
        }];

    }
    
    
    
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
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Create view that allows user to post to Twitter
        SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *twitterPrefixString = @"Check this place out: ";
        NSString *twitterFullString = [twitterPrefixString stringByAppendingString:urlOfPlace];
        
        //Add in default text to share
        [slComposeVC setInitialText:twitterFullString];
        
        //Present view to user for posting
        [self presentViewController:slComposeVC animated:TRUE completion:nil];
    }
}

#pragma mark - Phone Dialer

-(IBAction)launchPhoneDialer:(id)sender {
    
    //Get string for phone number and append it to tel prefix
    NSString *phoneNum = [@"tel://" stringByAppendingString:phoneNoOfPlace];
    //Launch phone dialer
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
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

//Method to check if network is connected
- (BOOL) isNetworkConnected
{
    Reachability *currentConnection = [Reachability reachabilityForInternetConnection];
    if ([currentConnection isReachable]) {
        //Network connection active, return true
        NSLog(@"Network connection is active");
        return TRUE;
    } else {
        //No network connection
        NSLog(@"Network connection is inactive");
        
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
        
        return FALSE;
    }
}

#pragma mark - Comments/Ratings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [reviewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"savedCommentCell"];
    if (commentsCell != nil) {
        
        //Get current object out of array
        //RestaurantReview *currentReview = [restaurantReviewsArray objectAtIndex:indexPath.row];
        
        PFObject *currentReview = [reviewsArray objectAtIndex:indexPath.row];
        
        //Get index of row and use index to get username/comments from array
        NSString *currentUsername = currentReview[@"username"];
        NSString *currentComment = currentReview[@"review"];
        NSString *currentRating = currentReview[@"stars"];
        
        //Call cell's custom method to update cell
        [commentsCell updateCellWithComments:currentUsername userComment:currentComment usersRating:currentRating];
        
        //commentsCell.textLabel.text = [comments objectAtIndex:indexPath.row];
        //commentsCell.detailTextLabel.text = [restaurantCityStates objectAtIndex:indexPath.row];
    }
    
    return commentsCell;
}

//Method to retrieve current item's reviews from Parse

-(void)retrieveReviews: (NSString*)placesID {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        
        if (itemID != nil) {
            PFQuery *reviewQuery = [PFQuery queryWithClassName:@"UserRating"];
            [reviewQuery whereKey:@"itemID" equalTo:placesID];
            
            [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                        
                        //Add objects to eventReviewsArray
                        [reviewsArray addObject:object];
                    }
                    
                    [commentsTV reloadData];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        
        
    }
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
