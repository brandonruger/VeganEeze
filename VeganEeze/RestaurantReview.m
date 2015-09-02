//
//  RestaurantReview.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/2/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "RestaurantReview.h"

@implementation RestaurantReview

@synthesize username, comment;

-(id)initWithReview:(NSString*)reviewComment whoWroteReview:(NSString*)whoWroteReview {
    //Initialize object
    if (self = [super init]) {
        username = [whoWroteReview copy];
        comment = [reviewComment copy];
    }
    
    return self;
}

@end
