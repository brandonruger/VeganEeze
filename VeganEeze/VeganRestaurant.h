//
//  VeganRestaurant.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeganRestaurant : NSObject

@property (nonatomic, strong) NSString *restaurantName;
@property (nonatomic, strong) NSString *restaurantAddress;
@property (nonatomic, strong) NSString *restaurantCity;
@property (nonatomic, strong) NSString *restaurantState;
@property (nonatomic, strong) NSString *restaurantZip;
@property (nonatomic, strong) NSString *restaurantPhone;
@property (nonatomic, strong) NSString *restaurantURL;


-(id)initWithRestaurant:(NSString*)nameOfRestaurant addressOfRestaurant:(NSString*)addressOfRestaurant cityOfRestaurant:(NSString*)cityOfRestaurant stateOfRestaurant:(NSString*)stateOfRestaurant zipOfRestaurant:(NSString*)zipOfRestaurant phoneNo:(NSString*)phoneNo urlOfRestaurant:(NSString*)urlOfRestaurant;

@end
