//
//  RestaurantReview.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/2/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantReview.h"

@implementation RestaurantReview

@synthesize username, comment, rating;

-(id)initWithReview:(NSString*)reviewComment whoWroteReview:(NSString*)whoWroteReview ratingForRestaurant:(NSString*)ratingForRestaurant {
    //Initialize object
    if (self = [super init]) {
        username = [whoWroteReview copy];
        comment = [reviewComment copy];
        rating = [ratingForRestaurant copy];
    }
    
    return self;
}

@end
