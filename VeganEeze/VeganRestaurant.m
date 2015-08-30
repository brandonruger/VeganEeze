//
//  VeganRestaurant.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganRestaurant.h"

@implementation VeganRestaurant
@synthesize restaurantName, restaurantAddress, restaurantCity, restaurantState, restaurantZip, restaurantPhone, restaurantURL;

-(id)initWithRestaurant:(NSString*)nameOfRestaurant addressOfRestaurant:(NSString*)addressOfRestaurant cityOfRestaurant:(NSString*)cityOfRestaurant stateOfRestaurant:(NSString*)stateOfRestaurant zipOfRestaurant:(NSString*)zipOfRestaurant phoneNo:(NSString*)phoneNo urlOfRestaurant:(NSString*)urlOfRestaurant {
    
    //Initialize object
    if (self = [super init]) {
        restaurantName = [nameOfRestaurant copy];
        restaurantAddress = [addressOfRestaurant copy];
        restaurantCity = [cityOfRestaurant copy];
        restaurantZip = [zipOfRestaurant copy];
        restaurantPhone = [phoneNo copy];
        restaurantURL = [urlOfRestaurant copy];
    }
    
    return self;
}

@end
