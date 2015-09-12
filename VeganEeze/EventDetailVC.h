//
//  EventDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "VeganEvent.h"
#import "EventReview.h"
#import <MapKit/MapKit.h>

@interface EventDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

{
    IBOutlet UILabel *eventNameLabel;
    //IBOutlet UILabel *eventAddressLabel;
//    IBOutlet UILabel *eventCityLabel;
//    IBOutlet UILabel *eventStateLabel;
//    IBOutlet UILabel *eventZipLabel;
    IBOutlet UIButton *eventUrlLabel;
    //IBOutlet UILabel *eventPhoneLabel;
    
    //IBOutlet UITextView *phoneNoTV;
    IBOutlet UITextView *addressTV;
    IBOutlet MKMapView *eventMapView;

    
    IBOutlet UITableView *commentsTV;
//    NSMutableArray *usernames;
//    NSMutableArray *comments;
    
    NSMutableArray *eventReviewsArray;
    
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextView *eventDescTV;
    IBOutlet UIImageView *eventImage;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *venueLabel;
    
    //IBOutlet UIButton *addNewComment;
    PFUser *currentUser;
    
    NSString *eventName;
    NSString *eventAddress;
    NSString *eventCity;
    NSString *eventState;
    NSString *eventZip;
    NSString *eventURL;
    NSString *eventID;
    NSString *eventDesc;
    NSString *eventDate;
    NSString *eventPrice;
    NSString *eventVenue;
    UIImage *eventImg;
    
    Float32 currentEventLat;
    Float32 currentEventLong;
    
    NSURL *urlForReviews;
    NSMutableURLRequest *reviewsRequest;
    NSURLConnection *reviewsConnection;
    NSMutableData *reviewData;
    NSDictionary *reviewDictionary;
    NSArray *reviewsArray;
    NSString *appKey;
    
}

@property (nonatomic, strong) VeganEvent *currentEvent;

//@property (nonatomic, strong) NSString *eventName;
//@property (nonatomic, strong) NSString *eventAddress;
//@property (nonatomic, strong) NSString *eventCityState;
//@property (nonatomic, strong) NSString *eventURL;
//@property (nonatomic, strong) NSString *eventPhoneNo;

@end
