//
//  EventResultCell.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/10/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "EventResultCell.h"

@implementation EventResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)updateCellWithEvent:(NSString*)name location:(NSString*)location imageURL:(NSString*)imageURL date:(NSString *)date {
    
    //Set items in cell to items passed into method
    eventName.text = name;
    
    eventLocation.text = location;
    
    
    if (date != nil) {
        
        NSLog(@"date = %@", date);
        
        //Trim off time from string
        date = [date substringToIndex:10];
        NSLog(@"date = %@", date);
        
        NSDateFormatter *formatForDate = [[NSDateFormatter alloc]init];
        [formatForDate setDateFormat: @"yyyy-MM-dd"];
        NSDate *currentEventDate = [formatForDate dateFromString:date];
        NSLog(@"currentEventDate = %@", currentEventDate);
        
        [formatForDate setDateFormat:@"MM-dd-yyyy"];
        
        NSString *dateString = [formatForDate stringFromDate:currentEventDate];
        NSLog(@"dateString = %@", dateString);
        
        //Set date label to date above
        eventDateLabel.text = dateString;
    } else {
        eventDateLabel.text = @"No date information available";
    }
    
    if ([imageURL isEqualToString:@""]) {
        //No images, set default image
        eventImage.image = [UIImage imageNamed:@"VeganEeze-Logo"];
    } else {
        //Create URL to download event image
        NSURL *eventImageURL = [NSURL URLWithString:imageURL];
        NSData *eventImgData = [NSData dataWithContentsOfURL:eventImageURL];
        //Create image from data
        UIImage *imageForEvent = [UIImage imageWithData:eventImgData];
        //Set image view to image
        eventImage.image = imageForEvent;
    }
}

@end
