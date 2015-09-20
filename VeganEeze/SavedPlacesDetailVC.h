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
    //IBOutlet UILabel *cityStateLabel;
    IBOutlet UIButton *urlLabel;
    //IBOutlet UILabel *phoneLabel;
    
    IBOutlet UITextView *descriptionTV;
    IBOutlet UIButton *phoneButton;
    IBOutlet UIButton *shareButton;
    
    
    //IBOutlet UITextView *phoneNoTV;
    
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

//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *address;
//@property (nonatomic, strong) NSString *cityState;
//@property (nonatomic, strong) NSString *url;
//@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *objectId;

@end
