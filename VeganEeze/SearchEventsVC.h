//
//  SearchEventsVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchEventsVC : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, NSURLConnectionDataDelegate>

{
    IBOutlet UISearchBar *keyword;
    IBOutlet UISearchBar *location;
    //IBOutlet UIButton *cancelButton;
    IBOutlet UISegmentedControl *searchSegmentedControl;
    
    CLLocationManager *locationMgr;
    
    IBOutlet UIPickerView *veganChoicePicker;
    NSArray *pickerChoices;
    
    NSMutableURLRequest *requestForData;
    NSURL *urlForAPICall;
    NSURLConnection *apiConnection;
    NSMutableData *dataRetrieved;
    NSString *searchKeyword;
    //NSArray *arrayOfJSONData;
    NSDictionary *dictOfJSONData;
    
    NSMutableArray *eventObjects;
    
    NSString *latitudeCoord;
    NSString *longitudeCoord;
    
    BOOL searchCurrentLocation;
    
    NSString *partialURL;
    NSString *completeURL;
    NSString *filterURL;
    
    NSString *appKey;
    
    NSString *pickerChoiceSelected;
    
    
}

@end
