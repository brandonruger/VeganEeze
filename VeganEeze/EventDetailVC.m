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
#import "CommentCell.h"
#import "RatingsVC.h"
#import "ViewController.h"


@interface EventDetailVC ()

@end

@implementation EventDetailVC
@synthesize currentEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appKey = @"&app_key=VrdtgSDWhZCHjRcK";
    
    //Setup array for usernames
    //usernames = [[NSMutableArray alloc]initWithObjects:@"brandon01", @"vegangirl83", @"animallover221", @"am1985", nil];
    
    //Setup array for comments
    //comments = [[NSMutableArray alloc]initWithObjects:@"This place was one of my favorites!", @"I absolutely love this place", @"I wanna go back", @"I love it here!", nil];
    
    //Initialize array for reviews
    eventReviewsArray = [[NSMutableArray alloc]init];
    
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
    
    //Set strings to values from current event object
    eventName = currentEvent.eventName;
    eventURL = currentEvent.eventURL;
    
    eventAddress = currentEvent.eventAddress;
    eventCity = currentEvent.eventCity;
    eventState = currentEvent.eventState;
    eventZip = currentEvent.eventZip;
    
    eventDesc = currentEvent.eventDesc;
    eventVenue = currentEvent.eventVenue;
    eventPrice = currentEvent.eventPrice;
    eventID = currentEvent.eventID;
    
    
    
    
    //Date
    eventDate = currentEvent.eventStartTime;
    
    if (eventDate != nil) {
        
        NSLog(@"date = %@", eventDate);
        
        //Trim off time from string
        eventDate = [eventDate substringToIndex:10];
        NSLog(@"date = %@", eventDate);
        
        NSDateFormatter *formatForDate = [[NSDateFormatter alloc]init];
        [formatForDate setDateFormat: @"yyyy-MM-dd"];
        NSDate *currentEventDate = [formatForDate dateFromString:eventDate];
        NSLog(@"currentEventDate = %@", currentEventDate);
        
        [formatForDate setDateFormat:@"MM-dd-yyyy"];
        
        NSString *dateString = [formatForDate stringFromDate:currentEventDate];
        NSLog(@"dateString = %@", dateString);
        
        //Set date label to date above
        dateLabel.text = [NSString stringWithFormat:@"Date of Event: %@", dateString];
    } else {
        dateLabel.text = @"Date unknown";
    }
    
//    //Image
//    NSString *imageURL = currentEvent.eventImageURL;
//    if ([imageURL isEqualToString:@""]) {
//        //No images, set default image
//        eventImage.image = [UIImage imageNamed:@"VeganEeze-Logo"];
//    } else {
//        //Create URL to download event image
//        NSURL *eventImageURL = [NSURL URLWithString:imageURL];
//        NSData *eventImgData = [NSData dataWithContentsOfURL:eventImageURL];
//        //Create image from data
//        UIImage *imageForEvent = [UIImage imageWithData:eventImgData];
//        //Set image view to image
//        eventImage.image = imageForEvent;
//    }
//    
//    //Format address
//    NSString *completeAddress = [NSString stringWithFormat:@"%@ \n%@, %@ %@", eventAddress, eventCity, eventState, eventZip];
    
    //NSString *ratingLabelStr = @"Rating: ";
    
    
    
    //Get object ID for retrieving reviews
    eventID = currentEvent.eventID;
    //Call method to get event reviews from Parse
    [self retrieveReviews];
    
    //Set labels to display information
    eventNameLabel.text = eventName;
    //addressTV.text = completeAddress;
    priceLabel.text = eventPrice;
    venueLabel.text = eventVenue;
    
    if (eventDesc != nil) {
        
        eventDescTV.text = eventDesc;
//        //Format event description text to remove HTML tags
//        NSAttributedString *eventDescFormatted =[[NSAttributedString alloc] initWithData:[eventDesc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//        
//        NSString *descriptionStrFinal = [eventDescFormatted string];
//        
//        eventDescTV.text = descriptionStrFinal;
    }
    
    
    //Latitude/Longitude
    currentEventLat = currentEvent.latitude;
    currentEventLong = currentEvent.longitude;
    
    NSLog(@"lat= %f, long= %f", currentEventLat, currentEventLong);
    
    //Call method to focus map view
    [self focusMapView];
    
//    eventCityLabel.text = eventCity;
//    eventStateLabel.text = eventState;
//    eventZipLabel.text = eventZip;
    
    //eventCityStateLabel.text = eventCityState;
    //eventPhoneLabel.text = eventPhoneNo;
    
    //Set URL button text
    //[eventUrlLabel setTitle:eventURL forState:UIControlStateNormal];
    
    //Set phone # to appear in text view
    //phoneNoTV.text = eventPhoneNo;
    
}

#pragma mark - Map View
-(void)focusMapView {
    
    //Set coordinates where map should focus
    CLLocationCoordinate2D eventVenueFocus = CLLocationCoordinate2DMake(currentEventLat, currentEventLong);
    
    //Set zoom span for each direction
    MKCoordinateSpan zoomSpanForMap;
    zoomSpanForMap.latitudeDelta = 1.0f;
    zoomSpanForMap.longitudeDelta = 1.0f;
    //Set these spans on map view
    eventMapView.region = MKCoordinateRegionMake(eventVenueFocus, zoomSpanForMap);
    
    //Add pin to map for venue
    MKPointAnnotation *venuePin = [[MKPointAnnotation alloc]init];
    //Set coordinate
    venuePin.coordinate = CLLocationCoordinate2DMake(currentEventLat, currentEventLong);
    //Title for pin
    venuePin.title = eventVenue;
    //Add pin to map
    [eventMapView addAnnotation:venuePin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    //Add callout button to pin
    MKAnnotationView *annotationPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationPin.canShowCallout = YES;
    annotationPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationPin;
}

//Method called when callout disclosure button is tapped
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    //Open Apple maps app with above address so user can get directions
//    NSString *mapAppStrPrefix = @"http://maps.apple.com/?ll=";
//    
//    NSString *latLongStr = [NSString stringWithFormat:@"%f,%f", currentEventLat, currentEventLong];
//    
//    //Append above strings - This is the string to use to launch the maps app
//    NSString *mapAppURL = [mapAppStrPrefix stringByAppendingString:latLongStr];
//
    
    //Check to make sure device has ios6 or higher
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D eventCoordinates =
        CLLocationCoordinate2DMake(currentEventLat, currentEventLong);
        MKPlacemark *mapPlacemark = [[MKPlacemark alloc] initWithCoordinate:eventCoordinates
                                                       addressDictionary:nil];
        MKMapItem *mapAppItem = [[MKMapItem alloc] initWithPlacemark:mapPlacemark];
        [mapAppItem setName:eventVenue];
        // Pass the map item to the Maps app
        [mapAppItem openInMapsWithLaunchOptions:nil];
    }
    
}

#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"WebSegue"]) {
        //Access the web view
        WebVC *webVC = segue.destinationViewController;
        //Pass restaurant's URL to web view
        webVC.websiteStr = eventURL;
    }
    
    if ([segue.identifier isEqualToString:@"RatingsSegue"]) {
        RatingsVC *ratingsVC = segue.destinationViewController;
        //Pass the event's ID to ratings view
        NSLog(@"eventID = %@", eventID);
        
        ratingsVC.currentEventsID = eventID;
    }
    
}

#pragma mark - Save Favorites

//Method to save favorite places to Parse
-(IBAction)saveFavoritePlace:(id)sender {
    //    //Gather data for current restaurant and save as a favoritePlace Parse object
    //    PFObject *favoritePlace = [PFObject objectWithClassName:@"FavoritePlace"];
    //    favoritePlace[@"name"] = eventName;
    //    favoritePlace[@"address"] = eventAddress;
    //    favoritePlace[@"city"] = eventCity;
    //    favoritePlace[@"state"] = eventState;
    //    favoritePlace[@"zip"] = eventZip;
    //    //favoritePlace[@"phoneNo"] = eventPhoneNo;
    //    favoritePlace[@"url"] = eventURL;
    //    favoritePlace[@"description"] = eventDesc;
    //    //Restrict data to this user only
    //    favoritePlace.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //
    //
    //    //Save in background on Parse server
    //    [favoritePlace saveInBackground];
    
    //Check if user is logged in
    PFUser *loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        //User is logged in
        
        //Run a query to see if item already exists in Parse
        PFQuery *favoritesQuery = [PFQuery queryWithClassName:@"FavoritePlace"];
        [favoritesQuery whereKey:@"itemID" equalTo:eventID];
        
        [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count >= 1) {
                // The find succeeded.
                
                //Alert user that they've already saved this place
                UIAlertView *duplicateFave = [[UIAlertView alloc]initWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of favorites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [duplicateFave show];
                
                
            } else {
                
                
                
                
                //Gather data for current restaurant and save as a favoritePlace Parse object
                PFObject *favoritePlace = [PFObject objectWithClassName:@"FavoritePlace"];
                
                if (eventName != nil) {
                    favoritePlace[@"name"] = eventName;
                    
                }
                if (eventAddress != nil) {
                    favoritePlace[@"address"] = eventAddress;
                    
                }
                if (eventCity != nil) {
                    favoritePlace[@"city"] = eventCity;
                    
                }
                //    favoritePlace[@"state"] = restaurantState;
                //    favoritePlace[@"zip"] = currentRestaurantZip;
                if (eventURL != nil) {
                    favoritePlace[@"url"] = eventURL;
                    
                }
                
                if (eventDesc != nil) {
                    favoritePlace[@"description"] = eventDesc;
                    
                }
                
                if (eventID != nil) {
                    favoritePlace[@"itemID"] = eventID;
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
    
}


//Method to save places to visit to Parse
-(IBAction)savePlaceToVisit:(id)sender {
    //    //Gather data for current restaurant and save as a placeToVisit Parse object
    //    PFObject *placeToVisit = [PFObject objectWithClassName:@"PlaceToVisit"];
    //    placeToVisit[@"name"] = eventName;
    //    placeToVisit[@"address"] = eventAddress;
    //    placeToVisit[@"city"] = eventCity;
    //    placeToVisit[@"state"] = eventState;
    //    placeToVisit[@"zip"] = eventZip;
    //    //placeToVisit[@"cityState"] = eventCityState;
    //    //placeToVisit[@"phoneNo"] = eventPhoneNo;
    //    placeToVisit[@"url"] = eventURL;
    //    placeToVisit[@"description"] = eventDesc;
    //    //Restrict data to this user only
    //    placeToVisit.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //
    //
    //    //Save in background on Parse server
    //    [placeToVisit saveInBackground];
    
    //Make sure user is logged in
    PFUser *loggedInUser = [PFUser currentUser];
    if (loggedInUser) {
        
        //Run a query to see if item already exists in Parse
        PFQuery *placesQuery = [PFQuery queryWithClassName:@"PlaceToVisit"];
        [placesQuery whereKey:@"itemID" equalTo:eventID];
        
        [placesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count >= 1) {
                // The find succeeded.
                
                //Alert user that they've already saved this place
                UIAlertView *duplicatePlace = [[UIAlertView alloc]initWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of Places to Visit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [duplicatePlace show];
                
                
            } else {
                
                
                //User is logged in
                //Gather data for current restaurant and save as a placeToVisit Parse object
                PFObject *placeToVisit = [PFObject objectWithClassName:@"PlaceToVisit"];
                
                if (eventName != nil) {
                    placeToVisit[@"name"] = eventName;
                }
                if (eventAddress != nil) {
                    placeToVisit[@"address"] = eventAddress;
                    
                }
                if (eventCity != nil) {
                    placeToVisit[@"city"] = eventCity;
                    
                }
                //    placeToVisit[@"state"] = restaurantState;
                //    placeToVisit[@"zip"] = currentRestaurantZip;
                
                if (eventURL != nil) {
                    placeToVisit[@"url"] = eventURL;
                    
                }
                if (eventDesc != nil) {
                    placeToVisit[@"description"] = eventDesc;
                    
                }
                
                if (eventID != nil) {
                    placeToVisit[@"itemID"] = eventID;
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
    
}

#pragma mark - Comments/Ratings

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [eventReviewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (commentsCell != nil) {
        
        //Get current object out of array
        //EventReview *eventForCell = [eventReviewsArray objectAtIndex:indexPath.row];
        //Get strings from current object for username/review
        //NSString *cellUsername = eventForCell.username;
        //NSString *cellComment = eventForCell.comment;
        
        PFObject *eventReviewObj = [eventReviewsArray objectAtIndex:indexPath.row];
        NSString *cellUsername = eventReviewObj[@"username"];
        NSString *cellRating = eventReviewObj[@"stars"];
        NSString *cellReview = eventReviewObj[@"review"];
        
        //Call cell's custom method to update cell
        [commentsCell updateCellWithComments:cellUsername userComment:cellReview usersRating:cellRating];
        
        //commentsCell.textLabel.text = [comments objectAtIndex:indexPath.row];
        //commentsCell.detailTextLabel.text = [restaurantCityStates objectAtIndex:indexPath.row];
    }
    
    return commentsCell;
}

////Method to add new comment
//-(IBAction)addNewComment:(id)sender {
//    
//    //Check if user is logged in
//    PFUser *loggedInUser = [PFUser currentUser];
//    if (loggedInUser) {
//        //User is logged in
//        //Show alert with text input for user to enter their comment
////        UIAlertView *newComment = [[UIAlertView alloc]initWithTitle:@"Add new comment" message:@"Enter comment below" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
////        //Set style to allow text input
////        newComment.alertViewStyle = UIAlertViewStylePlainTextInput;
////        //Show alert
////        [newComment show];
//        
//        UIAlertController *newComment = [UIAlertController alertControllerWithTitle:@"Add new comment" message:@"Please enter comment and rating below." preferredStyle:UIAlertControllerStyleAlert];
//       
//        [newComment addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = NSLocalizedString(@"RatingPlaceholder", @"Add rating");
//        }];
//        [newComment addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = NSLocalizedString(@"CommentPlaceholder", @"Add comment");
//        }];
//        
//        UIAlertAction *submitRating = [UIAlertAction actionWithTitle:@"Save Comment" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            //Retrieve values from text fields
//            UITextField *ratingTextField = newComment.textFields.firstObject;
//            UITextField *commentTextField = newComment.textFields.lastObject;
//            
//            //Set string values to the text retrieved from the text fields
//            rating = ratingTextField.text;
//            review = commentTextField.text;
//            
////            //Call method to add rating to Parse
////            [self addUsersRating];
//        }];
//        
//        //Add action to alert controller
//        [newComment addAction:submitRating];
//        
//        
//        
//        //Show alert
//        [self presentViewController:newComment animated:YES completion:nil];
//        
//    } else {
//        //User is not logged in
//        
//    }
//    
//    
//    
//    
//}

//Method to retrieve current event's comments from Parse
-(void)retrieveReviews {
    
    //NSPredicate *eventIDPredicate = [NSPredicate predicateWithFormat:@"itemID = '%@'", eventID];
    //PFQuery *reviewQuery = [PFQuery queryWithClassName:@"UserRating" predicate:eventIDPredicate];
    PFQuery *reviewQuery = [PFQuery queryWithClassName:@"UserRating"];
    [reviewQuery whereKey:@"itemID" equalTo:eventID];
    
    [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.

            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                //Add objects to eventReviewsArray
                [eventReviewsArray addObject:object];
            }
            
            [commentsTV reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

////Method to store rating on Parse
//-(void)addUsersRating {
//    
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    //User clicked submit button
//    if (buttonIndex == 1) {
//        //Gather the comment user entered
//        NSString *commentEntered = [[alertView textFieldAtIndex:0] text];
//        //Add necessary parameters to comment for URL
//        NSString *addCommentToURL = [NSString stringWithFormat:@"&comment=%@", commentEntered]; //Need to encoede this for URL
//        //Encode string for URL
//        NSString *encodedCommentForURL = [addCommentToURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //This is the string to add to the URL
//        
//        //Create URL for adding comments to an event
//        NSString *urlPrefix = @"http://api.eventful.com/rest/events/comments/new?id=";
//        //Append event ID# to url
//        NSString *urlWithID = [urlPrefix stringByAppendingString:eventID];
//        
//        //Append comment string to url with ID
//        NSString *urlWithIDandComment = [urlWithID stringByAppendingString:encodedCommentForURL];
//        
//        //Add appkey for authorization
//        NSString *finalURLforComment = [urlWithIDandComment stringByAppendingString:appKey];
//        NSLog(@"finalURLForComment = %@", finalURLforComment);
//        
//        //Create URL for API call
//        NSURL *urlToAddReview = [[NSURL alloc]initWithString:finalURLforComment];
//        //Set up request to send to server
//        NSMutableURLRequest *addCommentRequest = [[NSMutableURLRequest alloc]initWithURL:urlToAddReview];
//        if (addCommentRequest != nil) {
//            //Set up connection to send data to server
//            NSURLConnection *addCommentConnection = [[NSURLConnection alloc]initWithRequest:addCommentRequest delegate:self];
//        }
//        
//        
//        //Get logged in user's username from Parse
//       // NSString *currentUsername = [PFUser currentUser].username;
//        
////        //Add comment/username to mutable arrays
////        [usernames addObject:currentUsername];
////        [comments addObject:commentEntered];
//        
//        //Refresh tableview
//        [commentsTV reloadData];
//    }
//}

//#pragma mark - Reviews API calls
//
////Method to get event reviews
//-(void)getEventReviews {
//    
//    NSString *getReviewByID = @"http://api.eventful.com/json/events/get?id=";
//    //Add event ID to above URL
//    NSString *eventIDURL = [getReviewByID stringByAppendingString:eventID];
//    //Add app key to URL
//    NSString *reviewsURLStr = [eventIDURL stringByAppendingString:appKey];
//    
//    //Set up URL for API call
//    urlForReviews = [[NSURL alloc]initWithString:reviewsURLStr];
//    
//    //Set up request to send to server
//    reviewsRequest = [[NSMutableURLRequest alloc] initWithURL:urlForReviews];
//    if (reviewsRequest != nil) {
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
//    
//    //Check if this connection request came from the reviews request so data can be appended
//    if ([connection.originalRequest isEqual:reviewsRequest]) {
//        //Check to make sure data is valid
//        NSLog(@"connection request check worked");
//        if (data != nil) {
//            //Add this data to mutableData object
//            [reviewData appendData:data];
//            
//        }
//    } else {
//        NSLog(@"nope didn't work");
//    }
//    
//}
//
////Method called when all data from request has been retrieved
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    
//    reviewDictionary = [NSJSONSerialization JSONObjectWithData:reviewData options:0 error:nil];
//    NSArray *commentsRetrieved = [reviewDictionary objectForKey:@"comments"];
//    
//    if ([commentsRetrieved isEqual:[NSNull null]]) {
//        
//        //Do nothing
//        
//        
//    } else {
//        
//        //Loop through objects retrieved
//        for (int i=0; i<[commentsRetrieved count]; i++) {
//            //Use custom method to grab each object and add object to the array
//            EventReview *currentReview = [self createEventObjects:[commentsRetrieved objectAtIndex:i]];
//            if (currentReview != nil) {
//                //Add object to array
//                [eventReviewsArray addObject:currentReview];
//            }
//        }
//    }
//    
//    //Refresh table view with current data
//    [commentsTV reloadData];
//    
//    
//}
//
////Method to create custom EventReview objects and initalize each object
//-(EventReview*)createEventObjects:(NSDictionary*)eventReviewDictionary {
//    
//    NSString *reviewAuthor = [eventReviewDictionary valueForKey:@"username"];
//    NSString *review = [eventReviewDictionary valueForKey:@"text"];
//    
//    //Use object's custom init method to initialize object
//    EventReview *newEvent = [[EventReview alloc]initWithReview:review whoWroteReview:reviewAuthor];
//    
//    return newEvent;
//}

//Method to 



@end
