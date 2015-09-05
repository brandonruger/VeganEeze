//
//  RestaurantReview.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/2/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantReview : NSObject

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *rating;

-(id)initWithReview:(NSString*)reviewComment whoWroteReview:(NSString*)whoWroteReview ratingForRestaurant:(NSString*)ratingForRestaurant;

@end
