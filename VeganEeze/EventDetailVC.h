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
#import "RatingsVC.h"

@interface EventDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate, MKMapViewDelegate>

{
    IBOutlet UILabel *eventNameLabel;
    IBOutlet MKMapView *eventMapView;
    
    NSMutableArray *eventReviewsArray;
    
    IBOutlet UITableView *commentsTV;
    IBOutlet UITextView *eventDescTV;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIButton *tweetButton;
    IBOutlet UIButton *eventURLButton;
    
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
    
    NSString *rating;
    NSString *review;
    

    
}

@property (nonatomic, strong) VeganEvent *currentEvent;


@end
