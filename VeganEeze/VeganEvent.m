//
//  VeganEvent.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/30/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganEvent.h"

@implementation VeganEvent
@synthesize eventName, eventAddress, eventCity, eventState, eventZip, eventURL, eventID, eventDesc, eventImageURL, eventPrice, eventStartTime, eventVenue, latitude, longitude;

-(id)initWithEvent:(NSString*)nameOfEvent addressForEvent:(NSString*)addressForEvent cityOfEvent:(NSString*)cityOfEvent stateOfEvent:(NSString*)stateOfEvent zipOfEvent:(NSString*)zipOfEvent websiteForEvent:(NSString*)websiteForEvent idForEvent:(NSString*)idForEvent descOfEvent:(NSString *)descOfEvent startTime:(NSString *)startTime venue:(NSString *)venue price:(NSString *)price imageURL:(NSString *)imageURL eventLatitude:(Float32)eventLatitude eventLongitude:(Float32)eventLongitude{
    
    //Initalize object
    if (self = [super init]) {
        eventName = [nameOfEvent copy];
        eventAddress = [addressForEvent copy];
        eventCity = [cityOfEvent copy];
        eventState = [stateOfEvent copy];
        eventZip = [zipOfEvent copy];
        eventURL = [websiteForEvent copy];
        eventID = [idForEvent copy];
        eventDesc = [descOfEvent copy];
        eventImageURL = [imageURL copy];
        eventPrice = [price copy];
        eventStartTime = [startTime copy];
        eventVenue = [venue copy];
        latitude = eventLatitude;
        longitude = eventLongitude;
    }
    
    return self;
}

@end
