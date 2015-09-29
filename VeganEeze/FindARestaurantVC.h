//
//  FindARestaurantVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FindARestaurantVC : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSURLSessionDataDelegate> //NSURLConnectionDataDelegate>

{
    IBOutlet UISearchBar *location;
    IBOutlet UISegmentedControl *searchSegmentedControl;
    
    CLLocationManager *locationMgr;
    
    IBOutlet UIPickerView *veganChoicePicker;
    NSArray *pickerChoices;
    
    NSMutableURLRequest *requestForData;
    NSURL *urlForAPICall;
    NSURLConnection *apiConnection;
    NSMutableData *dataRetrieved;

    NSDictionary *dictOfJSONData;
    
    NSMutableArray *restaurantObjects;
    
    NSString *latitudeCoord;
    NSString *longitudeCoord;
    
    BOOL searchCurrentLocation;
    
    NSString *partialURL;
    NSString *completeURL;
    NSString *filterURL;
    
    NSString *userAgent;
    
    NSString *pickerChoiceSelected;
}


@end
