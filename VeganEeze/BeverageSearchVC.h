//
//  BeverageSearchVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeverageSearchVC : UIViewController <UISearchBarDelegate, NSURLConnectionDataDelegate>

{
    IBOutlet UISearchBar *beverageName;
    //IBOutlet UIButton *cancelButton;
    
    NSURLRequest *requestForData;
    NSURL *urlForAPICall;
    NSURLConnection *apiConnection;
    NSMutableData *dataRetrieved;
    NSString *searchKeyword;
    NSArray *arrayOfJSONData;
    
    NSMutableArray *alcoholBeverageObjects;
    
    //BOOL dataRetrievalComplete;
}

@end
