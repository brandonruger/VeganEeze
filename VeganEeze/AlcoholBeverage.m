//
//  AlcoholBeverage.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "AlcoholBeverage.h"

@implementation AlcoholBeverage

//Method to initalize AlcoholBeverage objects
-(id)initWithBeverage:(NSString*)nameOfAlcohol brandDesc:(NSString*)brandDesc veganStatus:(NSString*)veganStatus {
    //Initialize object
    if (self = [super init]) {
        alcoholName = [nameOfAlcohol copy];
        alcoholBrand = [brandDesc copy];
        veganOrNot = [veganStatus copy];
    }
    return self;
}

@end
