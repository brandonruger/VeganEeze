//
//  VeganEvent.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/30/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganEvent.h"

@implementation VeganEvent
@synthesize eventName, eventAddress, eventCity, eventState, eventZip, eventURL, eventID;

-(id)initWithEvent:(NSString*)nameOfEvent addressForEvent:(NSString*)addressForEvent cityOfEvent:(NSString*)cityOfEvent stateOfEvent:(NSString*)stateOfEvent zipOfEvent:(NSString*)zipOfEvent websiteForEvent:(NSString*)websiteForEvent idForEvent:(NSString*)idForEvent {
    
    //Initalize object
    if (self = [super init]) {
        eventName = [nameOfEvent copy];
        eventAddress = [addressForEvent copy];
        eventCity = [cityOfEvent copy];
        eventState = [stateOfEvent copy];
        eventZip = [zipOfEvent copy];
        //eventPhone = [stateOfEvent copy];
        eventURL = [websiteForEvent copy];
        eventID = [idForEvent copy];
    }
    
    return self;
}

@end
