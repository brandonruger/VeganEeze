//
//  EventDetailVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/19/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailVC : UIViewController

{
    IBOutlet UILabel *eventNameLabel;
    IBOutlet UILabel *eventAddressLabel;
}

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventAddress;

@end
