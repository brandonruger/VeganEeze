//
//  VeganResource.h
//  VeganEeze
//
//  Created by Brandon Ruger on 9/12/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VeganResource : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;


-(id)initWithResource:(NSString*)resourceName resourceURL:(NSString*)resourceURL;

@end
