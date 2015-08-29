//
//  AlcoholBeverage.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/29/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlcoholBeverage : NSObject

@property (nonatomic, strong) NSString *alcoholName;
@property (nonatomic, strong) NSString *alcoholBrand;
@property (nonatomic, strong) NSString *veganOrNot;

-(id)initWithBeverage:(NSString*)nameOfAlcohol brandDesc:(NSString*)brandDesc veganStatus:(NSString*)veganStatus;

@end
