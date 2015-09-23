//
//  EventResultCell.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/10/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventResultCell : UITableViewCell

{
    IBOutlet UILabel *eventName;
    IBOutlet UIImageView *eventImage;
    IBOutlet UILabel *eventLocation;
    IBOutlet UILabel *eventDateLabel;
}

-(void)updateCellWithEvent:(NSString*)name location:(NSString*)location imageURL:(NSString*)imageURL date:(NSString*)date;

@end
