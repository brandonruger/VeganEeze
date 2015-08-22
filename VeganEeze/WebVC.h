//
//  WebVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/21/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController
{
    IBOutlet UIWebView *webView;
}

@property (nonatomic, strong) NSString *websiteStr;

@end
