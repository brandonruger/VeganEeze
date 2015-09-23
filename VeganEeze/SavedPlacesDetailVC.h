//
//  SavedPlacesDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/22/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedPlacesDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextView *addressTV;
    IBOutlet UIButton *urlLabel;
    
    IBOutlet UITextView *descriptionTV;
    IBOutlet UIButton *phoneButton;
    IBOutlet UIButton *tweetButton;
    
    
    NSString *nameOfPlace;
    NSString *addressOfPlace;
    NSString *cityStateOfPlace;
    NSString *urlOfPlace;
    NSString *phoneNoOfPlace;
    NSString *description;
    NSString *completeAddress;
    
    IBOutlet UITableView *commentsTV;
    NSMutableArray *reviewsArray;
    NSString *itemID;
}

@property (nonatomic, strong) NSString *objectId;

@end
