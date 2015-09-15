//
//  RatingsVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/14/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingsVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

{
    IBOutlet UIPickerView *ratingsPicker;
    IBOutlet UITextView *commentTextBox;
    NSArray *ratingPickerChoices;
    NSString *pickerChoiceSelected;
    
    NSNumber *starRating;
    
    
    
}

@property (nonatomic, strong) NSString *currentEventsID;

@end
