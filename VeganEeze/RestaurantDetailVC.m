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
    
//    //Setup array for usernames
//    usernames = [[NSMutableArray alloc]initWithObjects:@"brandon01", @"vegangirl83", @"animallover221", @"am1985", nil];
//    
//    //Setup array for comments
//    comments = [[NSMutableArray alloc]initWithObjects:@"This place was one of my favorites!", @"I absolutely love this place", @"I wanna go back", @"I love it here!", nil];
    
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
        //restaurantImage.image = [UIImage imageNamed:@"NoImage"];
        restImage.image = [UIImage imageNamed:@"VeganEeze-Logo"];
    }
    
    restaurantAddress = currentRestaurant.restaurantAddress;
    restaurantCity = currentRestaurant.restaurantCity;
    restaurantState = currentRestaurant.restaurantState;
    currentRestaurantZip = currentRestaurant.restaurantZip;
    
    NSLog(@"restaurantZip = %@", currentRestaurantZip);
    
    if (restaurantAddress != nil && restaurantCity != nil && restaurantState != nil && currentRestaurantZip != nil) {
        completeAddress = [NSString stringWithFormat:@"%@ \n%@, %@ %@", restaurantAddress, restaurantCity, restaurantState, currentRestaurantZip];
        if (completeAddress != nil) {
            addressTV.text = completeAddress;
        }
        
    } else if (restaurantCity != nil && restaurantState != nil) {
        completeAddress = [NSString stringWithFormat:@"%@, %@", restaurantCity, restaurantState];
        if (completeAddress != nil) {
            addressTV.text = completeAddress;
        }
    } else {
        addressTV.text = @"Address unknown";
    }
    
    
    
    
    
    NSString *ratingLabelStr = @"Rating: ";
    NSString *ratingForRestaurant = currentRestaurant.restaurantRating;
    if (ratingForRestaurant != nil) {
        //restaurantRating = [ratingLabelStr stringByAppendingString:ratingForRestaurant];
        restaurantRating = [NSString stringWithFormat:@"%@ %@ Stars", ratingLabelStr, ratingForRestaurant];
        ratingLabel.text = restaurantRating;
        
    } else {
        [ratingLabel setHidden:YES];
    }

    
    //Get URI for restaurants reviews
    restaurantReviewURI = currentRestaurant.reviewsURI;
   // NSLog(@"URI = %@", restaurantReviewURI);
    
    //Call method to get restaurant reviews from API
   // [self getRestaurantReviews];
    
    //Remove all objects from array
    [restaurantReviewsArray removeAllObjects];
    
    [self retrieveRestaurantReviews];
    
    //Set restaurant labels to display information for object passed over from segue
    
    
    //cityLabel.text = restaurantCity;
    //stateLabel.text = restaurantState;
    //zipLabel.text = restaurantZip;
    //phoneLabel.text = restaurantPhoneNo;
    
    
    
    
    
    
    
    
    


    
    //Set URL button text
    //[urlLabel setTitle:restaurantURL forState:UIControlStateNormal];
    
    //Set phone # to appear in text view
    //phoneNoTV.text = restaurantPhoneNo;
    
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
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
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
    
//    if ([segue.identifier isEqualToString:@"addCommentSegue"]) {
//        //Get string for Reviews URI
//        NSString *addressForReviews = currentRestaurant.reviewsURI;
//        
//        //Remove last character "s" from url string
//        NSString *partialURL = [addressForReviews substringToIndex:[addressForReviews length]-1];
//        
//        //Add on "_form"
//        NSString *writeReviewURL = [partialURL stringByAppendingString:@"_form"];
//        
//        //Launch web view with above URL
//        WebVC *webVC = segue.destinationViewController;
//        //Pass url to web view
//        webVC.websiteStr = writeReviewURL;
//    }
    
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
                    UIAlertView *duplicateFave = [[UIAlertView alloc]initWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of favorites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [duplicateFave show];
                    
                    
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
                    //    favoritePlace[@"state"] = restaurantState;
                    //    favoritePlace[@"zip"] = currentRestaurantZip;
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
                    UIAlertView *savedAlert = [[UIAlertView alloc]initWithTitle:@"Favorite saved" message:@"This restaurant has been saved to your favorites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [savedAlert show];
                    
                }
                
            }];
            
            
        } else {
            //Not logged in, alert user
            //User is not logged in, alert user
            UIAlertView *notLoggedIn = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must be logged in to your account in order to save this to your favorites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [notLoggedIn show];
            
            //Take user to login screen
            ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            //Instantiate view controller
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    } else {
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
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
                    UIAlertView *duplicatePlace = [[UIAlertView alloc]initWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of Places to Visit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [duplicatePlace show];
                    
                    
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
                    //    placeToVisit[@"state"] = restaurantState;
                    //    placeToVisit[@"zip"] = currentRestaurantZip;
                    
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
                    UIAlertView *savedAlert = [[UIAlertView alloc]initWithTitle:@"Place saved" message:@"This restaurant has been saved to your places to visit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [savedAlert show];
                    
                    
                    
                }
            }];
            
            
            
        } else {
            //User is not logged in, alert user
            UIAlertView *notLoggedIn = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must be logged in to your account in order to save this to your places to visit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [notLoggedIn show];
            
            //Take user to login screen
            ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            //Instantiate view controller
            [self.navigationController pushViewController:loginVC animated:YES];
        }

    } else {
        //Alert user
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"You must have a valid network connection in order to proceed. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noConnection show];
    }
    
}

//#pragma mark - Launch Map app
//-(IBAction)launchMapForDirections:(id)sender {
//    
//}

//#pragma mark - Launch Phone Dialer
//
//-(IBAction)launchPhoneDialer:(id)sender {
//    
//    //Create string for phone number
//    NSString *restaurantPhoneNo = [@"tel://" stringByAppendingString:restaurantPhoneNo];
//    //Launch phone dialer app
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:restaurantPhoneNo]];
//}

#pragma mark - Comments/Ratings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [restaurantReviewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (commentsCell != nil) {
        
        //Get current object out of array
        //RestaurantReview *currentReview = [restaurantReviewsArray objectAtIndex:indexPath.row];
        
        PFObject *currentReview = [restaurantReviewsArray objectAtIndex:indexPath.row];
        
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

////Method to add new comment
//-(IBAction)addNewComment:(id)sender {
//    
//    //Show alert with text input for user to enter their comment
//    UIAlertView *newComment = [[UIAlertView alloc]initWithTitle:@"Add new comment" message:@"Enter comment below" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//    //Set style to allow text input
//    newComment.alertViewStyle = UIAlertViewStylePlainTextInput;
//    //Show alert
//    [newComment show];
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    //User clicked submit button
//    if (buttonIndex == 1) {
////        //Gather the comment user entered
////        NSString *commentEntered = [[alertView textFieldAtIndex:0] text];
////        
////        //Get logged in user's username from Parse
////        NSString *currentUsername = [PFUser currentUser].username;
////        
////        //Add comment/username to mutable arrays
////        [usernames addObject:currentUsername];
////        [comments addObject:commentEntered];
//        
//        //Refresh tableview
//        [commentsTV reloadData];
//    }
//}

//#pragma mark - Review API calls
//
////Method to get restaurant reviews
//-(void)getRestaurantReviews {
//    
//    //Set up URL for API call
//    urlForReviews = [[NSURL alloc] initWithString:restaurantReviewURI];
//    //urlForReviews = [[NSURL alloc] initWithString:@"http://www.vegguide.org/4669/reviews"];
//    
//    //Set up request to send to server
//    reviewsRequest = [[NSMutableURLRequest alloc]initWithURL:urlForReviews];
//    
//    [reviewsRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [reviewsRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    if (reviewsRequest != nil) {
//       // [reviewsRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
//        
//        //Set up connection to get data from server
//        reviewsConnection = [[NSURLConnection alloc]initWithRequest:reviewsRequest delegate:self];
//        //Create mutableData object to store data
//        reviewData = [NSMutableData data];
//    }
//}
//
////Method called when data is received
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    //Check to make sure data is valid
//    if (data != nil) {
//        //Add this data to mutableData object
//        [reviewData appendData:data];
//        
//    }
//}
//
////Method called when all data from request has been retrieved
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    
//    NSString *strData = [[NSString alloc]initWithData:reviewData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"reviewData = %@", strData);
//    
//    //reviewsArray = [NSKeyedUnarchiver unarchiveObjectWithData:reviewData];
//    
//    //NSLog(@"reviewsArray = %@", reviewsArray);
//    
//    //https://www.vegguide.org/entry/4669/reviews
//    
//    NSError *error = nil;
//    
//    //NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:reviewData options:NSJSONReadingAllowFragments error:&error];
//    
//    
//    
//    //Serialize JSON data
//    reviewsArray = [NSJSONSerialization JSONObjectWithData:reviewData options:NSJSONReadingAllowFragments error:&error];
//    
//    if (error != nil) {
//        NSLog(@"Error parsing JSON");
//    } else {
//        NSLog(@"Array: %@", reviewsArray);
//        
//        
//        
//        //Loop through array
//        for (int i=0; i<[reviewsArray count]; i++) {
//            NSDictionary *currentDictionary = [reviewsArray objectAtIndex:i];
//            //Dictionary for comment
//            NSDictionary *dictionaryForComment = [currentDictionary objectForKey:@"body"];
//            NSString *commentStr = [dictionaryForComment valueForKey:@"text/vnd.vegguide.org-wikitext"];
//            NSLog(@"commentStr = %@", commentStr);
//            
//            //Rating
//            NSString *currentRating = [currentDictionary valueForKey:@"rating"];
//            NSLog(@"currentRating = %@", currentRating);
//            
//            //Dictionary for username
//            NSDictionary *dictionaryForUsername = [currentDictionary objectForKey:@"user"];
//            NSString *currentUsername = [dictionaryForUsername valueForKey:@"name"];
//            
//            //Call custom method to create object with information
//            [self createReviewObjects:commentStr authorOfReview:currentUsername ratingForReview:currentRating];
//            
//            //NSString *comment = [currentDictionary valueForKey:@"body"];
//            //NSLog(@"comment = %@", comment);
//        }
//        
//        //Refresh tableview
//        [commentsTV reloadData];
//        
//        //NSArray *comments = [reviewDictionary objectForKey:@"commen]
//    }

   // NSDictionary *commentsRetrieved = [reviewDictionary objectForKey:@"comments"];
   // reviewsArray = [reviewDictionary objectForKey:@"entries"];
    
    //reviewsArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:reviewData options:0 error:nil]];

    
    //NSLog(@"array count = %lu", (unsigned long)[reviewsArray count]);
    
    //NSArray *reviewsRetrieved = [reviewDictionary objectForKey:@""];
    //NSString *reviewComment = [reviewsArray valueForKey:@"body"];
    
    //NSString *dataString = [[NSString alloc]initWithData:reviewData encoding:NSASCIIStringEncoding];
    //NSLog(@"%@", dataString);
//}

////Method to create RestaurantReview objects and initialize each object
//-(RestaurantReview*)createReviewObjects:(NSString*)review authorOfReview:(NSString*)authorOfReview ratingForReview:(NSString*)ratingForReview {
//    
//    //Use object's custom init method to initialize object
//    RestaurantReview *newReview = [[RestaurantReview alloc]initWithReview:review whoWroteReview:authorOfReview ratingForRestaurant:ratingForReview];
//    
//    //Add review object to array
//    [restaurantReviewsArray addObject:newReview];
//    
//    return newReview;
//}

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
                
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    
                    //Add objects to eventReviewsArray
                    [restaurantReviewsArray addObject:object];
                }
                
                [commentsTV reloadData];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
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
        NSLog(@"Network connection is active");
        return TRUE;
    } else {
        //No network connection
        NSLog(@"Network connection is inactive");
        
        return FALSE;
    }
}


@end
