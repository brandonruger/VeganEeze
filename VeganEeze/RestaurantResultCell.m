//
//  RestaurantResultCell.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/8/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantResultCell.h"

@implementation RestaurantResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithRestaurant:(NSString*)name description:(NSString*)description range:(NSString*)range imageURI:(NSString*)imageURI veganImage:(NSString*)veganImage {
    
    //Set items in cell to items passed into method
    restaurantName.text = name;
    shortDescription.text = description;
    priceRange.text = range;
    //restaurantImage.image = image;
    
    NSString *veganLevel = veganImage;
    
    NSInteger veganLevelInt = [veganLevel integerValue];
    
    //Change imageview for veganLevelImage depending on the veg level
    switch (veganLevelInt) {
        case 0:
            //Not veg
            veganLevelImage.image = [UIImage imageNamed:@"NotVeg"];
            break;
        case 1:
            //Vegetarian-friendly
            veganLevelImage.image = [UIImage imageNamed:@"Vegetarian"];
            break;
        case 2:
            //Vegan-Friendly
            veganLevelImage.image = [UIImage imageNamed:@"Vegan"];
            break;
        case 3:
            //Vegetarian, but not vegan-friendly
            veganLevelImage.image = [UIImage imageNamed:@"Vegetarian"];
            break;
        case 4:
            //Vegetarian
            veganLevelImage.image = [UIImage imageNamed:@"Vegetarian"];
            break;
        case 5:
            //Vegan
            veganLevelImage.image = [UIImage imageNamed:@"Vegan"];
            break;
            
        default:
            //Unknown
            veganLevelImage.image = [UIImage imageNamed:@"Question"];
            break;
    }
    
    if (imageURI != nil) {
        //Create URL to download restaurant image
        NSURL *restImageURL = [NSURL URLWithString:imageURI];
        NSData *restImgData = [NSData dataWithContentsOfURL:restImageURL];
        //Create image from data
        UIImage *imageForRest = [UIImage imageWithData:restImgData];
        //Set image view to restaurant image
        restaurantImage.image = imageForRest;
    } else {
        //No images found, set default image
        restaurantImage.image = [UIImage imageNamed:@"NoImage"];
    }
    
    
    
    
}

@end
