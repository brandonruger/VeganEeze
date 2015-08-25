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
@synthesize restaurantName, restaurantAddress, restaurantCityState, restaurantPhoneNo, restaurantURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    //Set restaurant labels to display information passed over from segue
    nameLabel.text = restaurantName;
    addressLabel.text = restaurantAddress;
    cityStateLabel.text = restaurantCityState;
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
    favoritePlace[@"cityState"] = restaurantCityState;
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
    placeToVisit[@"cityState"] = restaurantCityState;
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

@end
