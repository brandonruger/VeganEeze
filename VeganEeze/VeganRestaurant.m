//
//  VeganRestaurant.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganRestaurant.h"

@implementation VeganRestaurant
@synthesize restaurantName, restaurantAddress, restaurantCity, restaurantState, restaurantZip, restaurantPhone, restaurantURL, reviewsURI;

-(id)initWithRestaurant:(NSString*)nameOfRestaurant addressOfRestaurant:(NSString*)addressOfRestaurant cityOfRestaurant:(NSString*)cityOfRestaurant stateOfRestaurant:(NSString*)stateOfRestaurant zipOfRestaurant:(NSString*)zipOfRestaurant phoneNo:(NSString*)phoneNo urlOfRestaurant:(NSString*)urlOfRestaurant reviewsOfRestaurant:(NSString *)reviewsOfRestaurant {
    
    //Initialize object
    if (self = [super init]) {
        restaurantName = [nameOfRestaurant copy];
        restaurantAddress = [addressOfRestaurant copy];
        restaurantCity = [cityOfRestaurant copy];
        restaurantState = [stateOfRestaurant copy];
        restaurantZip = [zipOfRestaurant copy];
        restaurantPhone = [phoneNo copy];
        restaurantURL = [urlOfRestaurant copy];
        reviewsURI = [reviewsOfRestaurant copy];
    }
    
    return self;
}

@end
