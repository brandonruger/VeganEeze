//
//  AlcoholBeverage.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlcoholBeverage : NSObject

{
    //Strings for data that need to save for each object
    NSString *alcoholName;
    NSString *alcoholBrand;
    NSString *veganOrNot;
}

-(id)initWithBeverage:(NSString*)nameOfAlcohol brandDesc:(NSString*)brandDesc veganStatus:(NSString*)veganStatus;

@end
