//
//  RestaurantDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "VeganRestaurant.h"
#import "RestaurantReview.h"

@interface RestaurantDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSURLConnectionDataDelegate>

{
  
    IBOutlet UILabel *nameLabel;
    //IBOutlet UILabel *addressLabel;
    //IBOutlet UILabel *cityLabel;
    //IBOutlet UILabel *stateLabel;
    //IBOutlet UILabel *zipLabel;
    IBOutlet UIButton *urlLabel;
    IBOutlet UILabel *phoneLabel;
    
    //IBOutlet UITextView *phoneNoTV;
    IBOutlet UITextView *addressTV;
    
    IBOutlet UILabel *ratingLabel;
    
    IBOutlet UITableView *commentsTV;
    
    IBOutlet UILabel *priceRangeLabel;
    //IBOutlet UILabel *vegLevelLabel;
    //IBOutlet UILabel *restDescLabel;
    IBOutlet UITextView *restDescTV;
    IBOutlet UIImageView *restImage;
    IBOutlet UIImageView *vegLevelImg;
    
//    NSMutableArray *usernames;
//    NSMutableArray *comments;
    NSMutableArray *restaurantReviewsArray;
    
    //IBOutlet UIButton *addNewComment;
    PFUser *currentUser;
    
    NSString *restaurantName;
    NSString *restaurantAddress;
    NSString *restaurantCity;
    NSString *restaurantState;
    NSString *completeAddress;
    //NSString *restaurantZip;
    NSString *currentRestaurantZip;
    NSString *restaurantURL;
    NSString *restaurantPhoneNo;
    NSString *restaurantReviewURI;
    NSString *restaurantRating;
    
    NSString *restPriceRange;
    NSString *restVegLevel;
    NSString *restDesc;
    NSString *restImageURI;
    
    NSURL *urlForReviews;
    NSMutableURLRequest *reviewsRequest;
    NSURLConnection *reviewsConnection;
    NSMutableData *reviewData;
    NSDictionary *reviewDictionary;
    NSArray *reviewsArray;
    NSString *userAgent;
    
}

//@property (nonatomic, strong) NSString *restaurantName;
//@property (nonatomic, strong) NSString *restaurantAddress;
//@property (nonatomic, strong) NSString *restaurantCityState;
//@property (nonatomic, strong) NSString *restaurantURL;
//@property (nonatomic, strong) NSString *restaurantPhoneNo;

@property (nonatomic, strong) VeganRestaurant *currentRestaurant;






@end
