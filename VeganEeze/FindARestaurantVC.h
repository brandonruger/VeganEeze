//
//  FindARestaurantVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindARestaurantVC : UIViewController <UISearchBarDelegate>

{
    IBOutlet UISearchBar *keyword;
    IBOutlet UISearchBar *location;
    IBOutlet UIButton *cancelButton;
    IBOutlet UISegmentedControl *searchSegmentedControl;
}

@end
