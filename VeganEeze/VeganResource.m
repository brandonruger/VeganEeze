//
//  VeganResource.m
//  VeganEeze
//
//  Created by Brandon Ruger on 9/12/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "VeganResource.h"

@implementation VeganResource
@synthesize name, url;

-(id)initWithResource:(NSString*)resourceName resourceURL:(NSString*)resourceURL {
    
    if (self = [super init]) {
        name = [resourceName copy];
        url = [resourceURL copy];
    }
    
    return self;
}

@end
