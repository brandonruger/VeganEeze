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
#import "Reachability.h"


@interface EventDetailVC ()

@end

@implementation EventDetailVC
@synthesize currentEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //API App Key
    appKey = @"&app_key=VrdtgSDWhZCHjRcK";
    
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

#pragma mark - Twitter Sharing
-(IBAction)shareToTwitter:(id)sender {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        //Create view that allows user to post to Twitter
        SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //Format tweet post
        NSString *twitterPrefixString = @"Checkout this event: ";
        NSString *twitterFullString = [twitterPrefixString stringByAppendingString:eventURL];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set strings to values from current event object
    eventName = currentEvent.eventName;
    if (eventName != nil) {
        eventNameLabel.text = eventName;
    }
    
    
    eventURL = currentEvent.eventURL;
    if (eventURL == nil) {
        //Disable website button
        [eventURLButton setEnabled:NO];
    }
    
    eventDesc = currentEvent.eventDesc;
    if (eventDesc != nil) {
        
        eventDescTV.text = eventDesc;
    }
    
    eventVenue = currentEvent.eventVenue;
    
    //Date
    eventDate = currentEvent.eventStartTime;
    
    if (eventDate != nil) {
        
        //Trim off time from string
        eventDate = [eventDate substringToIndex:10];
        
        //Format date
        NSDateFormatter *formatForDate = [[NSDateFormatter alloc]init];
        [formatForDate setDateFormat: @"yyyy-MM-dd"];
        NSDate *currentEventDate = [formatForDate dateFromString:eventDate];
        
        [formatForDate setDateFormat:@"MM-dd-yyyy"];
        
        NSString *dateString = [formatForDate stringFromDate:currentEventDate];
        
        //Set date label to date above
        dateLabel.text = [NSString stringWithFormat:@"Date of Event: %@", dateString];
    } else {
        dateLabel.text = @"Date unknown";
    }
    
    //Get object ID for retrieving reviews
    eventID = currentEvent.eventID;
    if (eventID != nil) {
        //Call method to get event reviews from Parse
        [self retrieveReviews];
    }
    
    //Latitude/Longitude
    currentEventLat = currentEvent.latitude;
    currentEventLong = currentEvent.longitude;
    
    if (isnan(currentEventLat) && isnan(currentEventLong)) {
        
        //Do nothing
    } else {
        
        //Call method to focus map view
        [self focusMapView];
    }
    
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
    
    if (eventVenue != nil) {
        
        //Title for pin
        venuePin.title = eventVenue;
        //Add pin to map
        [eventMapView addAnnotation:venuePin];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //Check if annotation already exists
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
    
    //Check to make sure device has ios6 or higher
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        //Create an MKMapItem to pass to the Maps app
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
        ratingsVC.currentEventsID = eventID;
    }
    
}

#pragma mark - Save Favorites

//Method to save favorite places to Parse
-(IBAction)saveFavoritePlace:(id)sender {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
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
                    UIAlertController *duplicateFave = [UIAlertController alertControllerWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of favorites." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [duplicateFave addAction:defaultOk];
                    //Show alert
                    [self presentViewController:duplicateFave animated:YES completion:nil];
                    
                    
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
                    UIAlertController *savedAlert = [UIAlertController alertControllerWithTitle:@"Favorite Saved" message:@"This event has been saved to your favorites." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [savedAlert addAction:defaultOk];
                    //Show alert
                    [self presentViewController:savedAlert animated:YES completion:nil];
                    
                    
                }
            }];
            
        } else {
            //Not logged in, alert user
            UIAlertController *notLoggedIn = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must be logged in to your account in order to save this to your favorites. Please login." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //Instantiate login view controller
                ViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //Push view controller onto the screen
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
    //Check for active network connection
    if ([self isNetworkConnected]) {
        
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
                    UIAlertController *duplicatePlace = [UIAlertController alertControllerWithTitle:@"Duplicate" message:@"You have already bookmarked this place to your list of Places to Visit." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *defaultOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                    }];
                    //Add action to alert controller
                    [duplicatePlace addAction:defaultOk];
                    //Show alert
                    [self presentViewController:duplicatePlace animated:YES completion:nil];
                    
                    
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
                    UIAlertController *savedAlert = [UIAlertController alertControllerWithTitle:@"Place Saved" message:@"This event has been saved to your places to visit." preferredStyle:UIAlertControllerStyleAlert];
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
    
    return [eventReviewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Create custom comment cell
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (commentsCell != nil) {
        
        PFObject *eventReviewObj = [eventReviewsArray objectAtIndex:indexPath.row];
        NSString *cellUsername = eventReviewObj[@"username"];
        NSString *cellRating = eventReviewObj[@"stars"];
        NSString *cellReview = eventReviewObj[@"review"];
        
        //Call cell's custom method to update cell
        [commentsCell updateCellWithComments:cellUsername userComment:cellReview usersRating:cellRating];
        
    }
    
    return commentsCell;
}



//Method to retrieve current event's comments from Parse
-(void)retrieveReviews {
    
    //Check for active network connection
    if ([self isNetworkConnected]) {
        
        PFQuery *reviewQuery = [PFQuery queryWithClassName:@"UserRating"];
        [reviewQuery whereKey:@"itemID" equalTo:eventID];
        
        [reviewQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                
                //Loop through the objects retrieved from the query
                for (PFObject *object in objects) {
                    
                    //Add objects to eventReviewsArray
                    [eventReviewsArray addObject:object];
                }
                
                //Refresh the tableview
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
