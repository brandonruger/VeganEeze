//
//  RestaurantResultCell.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/8/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantResultCell : UITableViewCell

{
    IBOutlet UILabel *restaurantName;
    IBOutlet UILabel *shortDescription;
    IBOutlet UILabel *priceRange;
    IBOutlet UIImageView *restaurantImage;
    IBOutlet UIImageView *veganLevelImage;
}

- (void)updateCellWithRestaurant:(NSString*)name description:(NSString*)description range:(NSString*)range imageURI:(NSString*)imageURI veganImage:(NSString*)veganImage;


@end
