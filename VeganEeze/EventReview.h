//
//  EventReview.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/2/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventReview : NSObject

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *username;

-(id)initWithReview:(NSString*)reviewComment whoWroteReview:(NSString*)whoWroteReview;

@end
