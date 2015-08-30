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

@interface RestaurantDetailVC ()

@end

@implementation RestaurantDetailVC
@synthesize currentRestaurant;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userAgent = @"VeganEeze App/v1.0";
    
    //Setup array for usernames
    usernames = [[NSMutableArray alloc]initWithObjects:@"brandon01", @"vegangirl83", @"animallover221", @"am1985", nil];
    
    //Setup array for comments
    comments = [[NSMutableArray alloc]initWithObjects:@"This place was one of my favorites!", @"I absolutely love this place", @"I wanna go back", @"I love it here!", nil];
    
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
    restaurantAddress = currentRestaurant.restaurantAddress;
    restaurantCity = currentRestaurant.restaurantCity;
    restaurantState = currentRestaurant.restaurantState;
    restaurantZip = currentRestaurant.restaurantZip;
    restaurantURL = currentRestaurant.restaurantURL;
    restaurantPhoneNo = currentRestaurant.restaurantPhone;
    
    //Get URI for restaurants reviews
    restaurantReviewURI = currentRestaurant.reviewsURI;
    NSLog(@"URI = %@", restaurantReviewURI);
    //Call method to get restaurant reviews from API
    [self getRestaurantReviews];
    
    //Set restaurant labels to display information passed over from segue
    nameLabel.text = restaurantName;
    addressTV.text = restaurantAddress;
    cityLabel.text = restaurantCity;
    stateLabel.text = restaurantState;
    zipLabel.text = restaurantZip;
    phoneLabel.text = restaurantPhoneNo;
    
    //Set URL button text
    [urlLabel setTitle:restaurantURL forState:UIControlStateNormal];
    
    //Set phone # to appear in text view
    phoneNoTV.text = restaurantPhoneNo;
    
}

#pragma mark - Twitter Sharing
-(IBAction)shareToTwitter:(id)sender {
    
    //Create view that allows user to post to Twitter
    SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterPrefixString = @"Checkout this restaurant: ";
    NSString *twitterFullString = [twitterPrefixString stringByAppendingString:restaurantURL];
    
    //Add in default text to share
    [slComposeVC setInitialText:twitterFullString];
    
    //Present view to user for posting
    [self presentViewController:slComposeVC animated:TRUE completion:nil];
}


#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass restaurant's URL to web view
    webVC.websiteStr = restaurantURL;
    
}

#pragma mark - Save Favorites

//Method to save favorite places to Parse
-(IBAction)saveFavoritePlace:(id)sender {
    //Gather data for current restaurant and save as a favoritePlace Parse object
    PFObject *favoritePlace = [PFObject objectWithClassName:@"FavoritePlace"];
    favoritePlace[@"name"] = restaurantName;
    favoritePlace[@"address"] = restaurantAddress;
    favoritePlace[@"city"] = restaurantCity;
    favoritePlace[@"state"] = restaurantState;
    favoritePlace[@"zip"] = restaurantZip;
    favoritePlace[@"phoneNo"] = restaurantPhoneNo;
    favoritePlace[@"url"] = restaurantURL;
    //Restrict data to this user only
    favoritePlace.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    //Save in background on Parse server
    [favoritePlace saveInBackground];
}


//Method to save places to visit to Parse
-(IBAction)savePlaceToVisit:(id)sender {
    //Gather data for current restaurant and save as a placeToVisit Parse object
    PFObject *placeToVisit = [PFObject objectWithClassName:@"PlaceToVisit"];
    placeToVisit[@"name"] = restaurantName;
    placeToVisit[@"address"] = restaurantAddress;
    placeToVisit[@"city"] = restaurantCity;
    placeToVisit[@"state"] = restaurantState;
    placeToVisit[@"zip"] = restaurantZip;
    placeToVisit[@"phoneNo"] = restaurantPhoneNo;
    placeToVisit[@"url"] = restaurantURL;
    //Restrict data to this user only
    placeToVisit.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

    
    //Save in background on Parse server
    [placeToVisit saveInBackground];
}

#pragma mark - Launch Map app
-(IBAction)launchMapForDirections:(id)sender {
    
}

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
    
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (commentsCell != nil) {
        
        //Get index of row and use index to get username/comments from array
        NSString *currentUsername = [usernames objectAtIndex:indexPath.row];
        NSString *currentComment = [comments objectAtIndex:indexPath.row];
        
        //Call cell's custom method to update cell
        [commentsCell updateCellWithComments:currentUsername userComment:currentComment];
        
        //commentsCell.textLabel.text = [comments objectAtIndex:indexPath.row];
        //commentsCell.detailTextLabel.text = [restaurantCityStates objectAtIndex:indexPath.row];
    }
    
    return commentsCell;
}

//Method to add new comment
-(IBAction)addNewComment:(id)sender {
    
    //Show alert with text input for user to enter their comment
    UIAlertView *newComment = [[UIAlertView alloc]initWithTitle:@"Add new comment" message:@"Enter comment below" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    //Set style to allow text input
    newComment.alertViewStyle = UIAlertViewStylePlainTextInput;
    //Show alert
    [newComment show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //User clicked submit button
    if (buttonIndex == 1) {
        //Gather the comment user entered
        NSString *commentEntered = [[alertView textFieldAtIndex:0] text];
        
        //Get logged in user's username from Parse
        NSString *currentUsername = [PFUser currentUser].username;
        
        //Add comment/username to mutable arrays
        [usernames addObject:currentUsername];
        [comments addObject:commentEntered];
        
        //Refresh tableview
        [commentsTV reloadData];
    }
}

#pragma mark - Review API calls

//Method to get restaurant reviews
-(void)getRestaurantReviews {
    
    //Set up URL for API call
    urlForReviews = [[NSURL alloc] initWithString:restaurantReviewURI];
    
    //Set up request to send to server
    reviewsRequest = [[NSMutableURLRequest alloc]initWithURL:urlForReviews];
    if (reviewsRequest != nil) {
        [reviewsRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        //Set up connection to get data from server
        reviewsConnection = [[NSURLConnection alloc]initWithRequest:reviewsRequest delegate:self];
        //Create mutableData object to store data
        reviewData = [NSMutableData data];
    }
}

//Method called when data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //Check to make sure data is valid
    if (data != nil) {
        //Add this data to mutableData object
        [reviewData appendData:data];
        
    }
}

//Method called when all data from request has been retrieved
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    reviewsArray = [NSKeyedUnarchiver unarchiveObjectWithData:reviewData];
    
    NSLog(@"reviewsArray = %@", reviewsArray);
    
    //Serialize JSON data
    //reviewDictionary = [NSJSONSerialization JSONObjectWithData:reviewData options:0 error:nil];
   // reviewsArray = [reviewDictionary objectForKey:@"entries"];
    
    //reviewsArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:reviewData options:0 error:nil]];

    
    //NSLog(@"array count = %lu", (unsigned long)[reviewsArray count]);
    
    //NSArray *reviewsRetrieved = [reviewDictionary objectForKey:@""];
    //NSString *reviewComment = [reviewsArray valueForKey:@"body"];
    
    //NSString *dataString = [[NSString alloc]initWithData:reviewData encoding:NSASCIIStringEncoding];
    //NSLog(@"%@", dataString);
}



@end
