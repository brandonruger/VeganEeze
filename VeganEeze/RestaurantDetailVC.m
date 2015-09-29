//
//  RestaurantDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantDetailVC.h"
#import "WebVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Parse/Parse.h>
#import "CommentCell.h"
#import "RatingsVC.h"
#import "ViewController.h"
#import "Reachability.h"

@interface RestaurantDetailVC ()

@end

@implementation RestaurantDetailVC
@synthesize currentRestaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userAgent = @"VeganEeze App/v1.0";
    
    //Initialize array for reviews
    restaurantReviewsArray = [[NSMutableArray alloc]init];
    
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
                    if (userTwitterAccts != nil && userTwitterAccts.count > 0) {
                        //Access single account
                        ACAccount *currentAcct = [userTwitterAccts objectAtIndex:0];
                        if (currentAcct != nil) {
                        }
                        
                    } else {
                        //Disable Tweet button
                        [tweetButton setEnabled:NO];
                    }
                }
                else {
                    //User did not approve accessing Twitter account
                    
                    //Disable Tweet button
                    [tweetButton setEnabled:NO];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set strings to values from current restaurant object
    restaurantName = currentRestaurant.restaurantName;
    if (restaurantName != nil) {
        nameLabel.text = restaurantName;
    }
    
    restaurantURL = currentRestaurant.restaurantURL;
    if (restaurantURL == nil) {
        //Disable website button
        [urlLabel setEnabled:NO];
    }
    restaurantPhoneNo = currentRestaurant.restaurantPhone;
    if (restaurantPhoneNo == nil) {
        //Disable phone button
        [callButton setEnabled:NO];
    }
    
    restPriceRange = currentRestaurant.priceRange;
    if (restPriceRange != nil) {
        
        NSString *priceRangeFormatted = [NSString stringWithFormat:@"Price Range: %@", restPriceRange];
        if (priceRangeFormatted != nil) {
            priceRangeLabel.text = priceRangeFormatted;
        }
    }
    
    
    restVegLevel = currentRestaurant.vegLevel;
    if (restVegLevel != nil) {
        //Convert vegLevel to integer
        NSInteger veganLevelInt = [restVegLevel integerValue];
        
        //Veg Level
        //Change imageview for veganLevelImage depending on the veg level
        switch (veganLevelInt) {
            case 0:
                //Not veg
                vegLevelImg.image = [UIImage imageNamed:@"NotVeg"];
                break;
            case 1:
                //Vegetarian-friendly
                vegLevelImg.image = [UIImage imageNamed:@"Vegetarian"];
                break;
            case 2:
                //Vegan-Friendly
                vegLevelImg.image = [UIImage imageNamed:@"Vegetarian"];
                break;
            case 3:
                //Vegetarian, but not vegan-friendly
                vegLevelImg.image = [UIImage imageNamed:@"Vegetarian"];
                break;
            case 4:
                //Vegetarian
                vegLevelImg.image = [UIImage imageNamed:@"Vegetarian"];
                break;
            case 5:
                //Vegan
                vegLevelImg.image = [UIImage imageNamed:@"Vegan"];
                break;
                
            default:
                //Unknown
                vegLevelImg.image = [UIImage imageNamed:@"Question"];
                break;
        }
        
    } else {
        //Show unknown image
        vegLevelImg.image = [UIImage imageNamed:@"Question"];
    }
    
    
    restDesc = currentRestaurant.longDescription;
    if (restDesc != nil) {
        restDescTV.text = restDesc;
    }
    
    restImageURI = currentRestaurant.imageURI;
    //Image for restaurant
    if (restImageURI != nil) {
        //Create URL to download restaurant image
        NSURL *restImageURL = [NSURL URLWithString:restImageURI];
        NSData *restImgData = [NSData dataWithContentsOfURL:restImageURL];
        //Create image from data
        UIImage *imageForRest = [UIImage imageWithData:restImgData];
        //Set image view to restaurant image
        restImage.image = imageForRest;
    } else {
        //No images found, set default image
        restImage.image = [UIImage imageNamed:@"VeganEeze-Logo"];
    }
    
    //Get data from current restaurant object
    restaurantAddress = currentRestaurant.restaurantAddress;
    restaurantCity = currentRestaurant.restaurantCity;
    restaurantState = currentRestaurant.restaurantState;
    currentRestaurantZip = currentRestaurant.restaurantZip;
    
    //Check to see if any of the restaurant data is invalid
    if (restaurantAddress != nil && restaurantCity != nil && restaurantState != nil && currentRestaurantZip != nil) {
        //All data is valid, format to complete the address into one string
        completeAddress = [NSString stringWithFormat:@"%@ \n%@, %@ %@", restaurantAddress, restaurantCity, restaurantState, currentRestaurantZip];
        if (completeAddress != nil) {
            //Set text view to display complete address
            addressTV.text = completeAddress;
        }
        
        //Check if city/state are valid
    } else if (restaurantCity != nil && restaurantState != nil) {
        //Use only the city/state as the address
        completeAddress = [NSString stringWithFormat:@"%@, %@", restaurantCity, restaurantState];
        if (completeAddress != nil) {
            addressTV.text = completeAddress;
        }
    } else {
        //Data missing from address, set as "Address Unknown"
        addressTV.text = @"Address unknown";
    }
    
    
    
    
    
    NSString *ratingLabelStr = @"Rating: ";
    NSString *ratingForRestaurant = currentRestaurant.restaurantRating;
    if (ratingForRestaurant != nil) {
        restaurantRating = [NSString stringWithFormat:@"%@ %@ Stars", ratingLabelStr, ratingForRestaurant];
        ratingLabel.text = restaurantRating;
        
    } else {
        [ratingLabel setHidden:YES];
    }
    
    
    //Get URI for restaurants reviews
    restaurantReviewURI = currentRestaurant.reviewsURI;
    
    //Remove all objects from array
    [restaurantReviewsArray removeAllObjects];
    
    [self retrieveRestaurantReviews];
    
}

#pragma mark - Twitter Sharing
-(IBAction)shareToTwitter:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        //Create view that allows user to post to Twitter
        SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *twitterPrefixString = @"Checkout this restaurant: ";
        NSString *twitterFullString = [twitterPrefixString stringByAppendingString:restaurantURL];
        
        //Add in default text to share
        [slComposeVC setInitialText:twitterFullString];
        
        //Present view to user for posting
        [self presentViewController:slComposeVC animated:TRUE completion:nil];
    } else {
       
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


#pragma mark - Navigation

//Segue method to pass information to web view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"restaurantWebsiteSegue"]) {
        
        //Access the web view
        WebVC *webVC = segue.destinationViewController;
        //Pass restaurant's URL to web view
        webVC.websiteStr = restaurantURL;
    }
    
    if ([segue.identifier isEqualToString:@"segueRestaurantRatings"]) {
        RatingsVC *ratingsVC = segue.destinationViewController;
        //Pass the review URI to ratings view to use as the ID
        
        ratingsVC.currentEventsID = restaurantReviewURI;
    }
}

#pragma mark - Save Favorites

//Method to save favorite places to Parse
-(IBAction)saveFavoritePlace:(id)sender {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        //Check if user is logged in
        PFUser *loggedInUser = [PFUser currentUser];
        if (loggedInUser) {
            
            //Run a query to see if item already exists in Parse
            PFQuery *favoritesQuery = [PFQuery queryWithClassName:@"FavoritePlace"];
            [favoritesQuery whereKey:@"itemID" equalTo:restaurantReviewURI];
            
            [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error && objects.count >= 1) {
                    
                    
                    //Alert user that they've already saved this place
                    UIAlertController *duplicateFave = [UIAlertController alertControllerWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of favorites." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [duplicateFave addAction:defaultOk];
                    //Show alert
                    [self presentViewController:duplicateFave animated:YES completion:nil];
                    
                } else {
                    
                    
                    
                    //User is logged in
                    //Gather data for current restaurant and save as a favoritePlace Parse object
                    PFObject *favoritePlace = [PFObject objectWithClassName:@"FavoritePlace"];
                    
                    if (restaurantName != nil) {
                        favoritePlace[@"name"] = restaurantName;
                        
                    }
                    if (completeAddress != nil) {
                        favoritePlace[@"address"] = completeAddress;
                        
                    }
                    if (restaurantPhoneNo != nil) {
                        favoritePlace[@"phoneNo"] = restaurantPhoneNo;
                        
                    }
                    if (restaurantCity != nil) {
                        favoritePlace[@"city"] = restaurantCity;
                        
                    }
                    
                    if (restaurantURL != nil) {
                        favoritePlace[@"url"] = restaurantURL;
                        
                    }
                    
                    if (restDesc != nil) {
                        favoritePlace[@"description"] = restDesc;
                        
                    }
                    
                    if (restaurantReviewURI != nil) {
                        favoritePlace[@"itemID"] = restaurantReviewURI;
                    }
                    
                    //Restrict data to this user only
                    favoritePlace.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    
                    //Save in background on Parse server
                    [favoritePlace saveInBackground];
                    
                    //Alert user
                    UIAlertController *savedAlert = [UIAlertController alertControllerWithTitle:@"Favorite Saved" message:@"This restaurant has been saved to your favorites." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [savedAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:savedAlert animated:YES completion:nil];
                    
                }
                
            }];
            
            
        } else {
            //User is not logged in, alert user
            UIAlertController *notLoggedIn = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must be logged in to your account in order to save this to your favorites. Please login." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //Take user to login screen
                ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //Instantiate view controller
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            //Add action to alert controller
            [notLoggedIn addAction:defaultOk];
            //Show alert
            [self presentViewController:notLoggedIn animated:YES completion:nil];
            
            
        }
    } else {
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


//Method to save places to visit to Parse
-(IBAction)savePlaceToVisit:(id)sender {
    
    //Check for valid internet connection
    if ([self isNetworkConnected]) {
        //Make sure user is logged in
        PFUser *loggedInUser = [PFUser currentUser];
        if (loggedInUser) {
            //User is logged in
            
            //Run a query to see if item already exists in Parse
            PFQuery *placesQuery = [PFQuery queryWithClassName:@"PlaceToVisit"];
            [placesQuery whereKey:@"itemID" equalTo:restaurantReviewURI];
            
            [placesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error && objects.count >= 1) {
                    // The find succeeded.
                    
                    //Alert user that they've already saved this place
                    UIAlertController *duplicatePlace = [UIAlertController alertControllerWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of Places to Visit." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [duplicatePlace addAction:defaultOk];
                    //Show alert
                    [self presentViewController:duplicatePlace animated:YES completion:nil];
                    
                    
                } else {
                    // No object found, proceed with saving the place
                    //Gather data for current restaurant and save as a placeToVisit Parse object
                    PFObject *placeToVisit = [PFObject objectWithClassName:@"PlaceToVisit"];
                    
                    if (restaurantName != nil) {
                        placeToVisit[@"name"] = restaurantName;
                    }
                    if (completeAddress != nil) {
                        placeToVisit[@"address"] = completeAddress;
                        
                    }
                    if (restaurantCity != nil) {
                        placeToVisit[@"city"] = restaurantCity;
                        
                    }
                    
                    if (restaurantPhoneNo != nil) {
                        placeToVisit[@"phoneNo"] = restaurantPhoneNo;
                        
                    }
                    if (restaurantURL != nil) {
                        placeToVisit[@"url"] = restaurantURL;
                        
                    }
                    if (restDesc != nil) {
                        placeToVisit[@"description"] = restDesc;
                        
                    }
                    if (restaurantReviewURI != nil) {
                        placeToVisit[@"itemID"] = restaurantReviewURI;
                    }
                    
                    //Restrict data to this user only
                    placeToVisit.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    
                    
                    //Save in background on Parse server
                    [placeToVisit saveInBackground];
                    
                    //Alert user
                    UIAlertController *savedAlert = [UIAlertController alertControllerWithTitle:@"Place Saved" message:@"This restaurant has been saved to your places to visit." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [savedAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:savedAlert animated:YES completion:nil];
                    
                }
            }];
            
            
            
        } else {
            //User is not logged in, alert user
            UIAlertController *notLoggedIn = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must be logged in to your account in order to save this to your places to visit. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //Take user to login screen
                ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //Instantiate view controller
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            //Add action to alert controller
            [notLoggedIn addAction:defaultOk];
            //Show alert
            [self presentViewController:notLoggedIn animated:YES completion:nil];
            
            
        }
        
    } else {
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

#pragma mark - Comments/Ratings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [restaurantReviewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Create custom cell
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (commentsCell != nil) {
        
        //Get current object out of array
        PFObject *currentReview = [restaurantReviewsArray objectAtIndex:indexPath.row];
        
        //Get index of row and use index to get username/comments from array
        NSString *currentUsername = currentReview[@"username"];
        NSString *currentComment = currentReview[@"review"];
        NSString *currentRating = currentReview[@"stars"];
        
        //Call cell's custom method to update cell
        [commentsCell updateCellWithComments:currentUsername userComment:currentComment usersRating:currentRating];
        
    }
    
    return commentsCell;
}

//Method to launch phone dialer when call button is pressed
-(IBAction)launchPhoneDialer:(id)sender {
    
    //Get string for phone number and append it to tel prefix
    NSString *phoneNum = [@"tel://" stringByAppendingString:restaurantPhoneNo];
    //Launch phone dialer
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
}

//Method to retrieve current restaurant's reviews from Parse
-(void)retrieveRestaurantReviews {
    
    //Check for valid network connection
    if ([self isNetworkConnected]) {
        PFQuery *reviewQuery = [PFQuery queryWithClassName:@"UserRating"];
        [reviewQuery whereKey:@"itemID" equalTo:restaurantReviewURI];
        
        [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                
                //Loop through the objects returned from the query
                for (PFObject *object in objects) {
                    
                    //Add object to eventReviewsArray
                    [restaurantReviewsArray addObject:object];
                }
                
                //Refresh tableview
                [commentsTV reloadData];
                
            } else {
                //Do nothing
            }
        }];
        
    }
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
