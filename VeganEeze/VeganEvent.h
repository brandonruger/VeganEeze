//
//  VeganEvent.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/30/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeganEvent : NSObject

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventAddress;
@property (nonatomic, strong) NSString *eventCity;
@property (nonatomic, strong) NSString *eventState;
@property (nonatomic, strong) NSString *eventZip;
//@property (nonatomic, strong) NSString *eventPhone;
@property (nonatomic, strong) NSString *eventURL;
//@property (nonatomic, strong) NSString *eventComments;
@property (nonatomic, strong) NSString *eventID;

@property (nonatomic, strong) NSString *eventDesc;
@property (nonatomic, strong) NSString *eventStartTime;
@property (nonatomic, strong) NSString *eventVenue;
@property (nonatomic, strong) NSString *eventPrice;
@property (nonatomic, strong) NSString *eventImageURL;


-(id)initWithEvent:(NSString*)nameOfEvent addressForEvent:(NSString*)addressForEvent cityOfEvent:(NSString*)cityOfEvent stateOfEvent:(NSString*)stateOfEvent zipOfEvent:(NSString*)zipOfEvent websiteForEvent:(NSString*)websiteForEvent idForEvent:(NSString*)idForEvent descOfEvent:(NSString*)descOfEvent startTime:(NSString*)startTime venue:(NSString*)venue price:(NSString*)price imageURL:(NSString*)imageURL;

@end
