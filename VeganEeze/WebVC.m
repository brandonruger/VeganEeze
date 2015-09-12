//
//  WebVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/21/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC
@synthesize websiteStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"URL = %@", websiteStr);
    
    //NSString *urlPrefix = @"http://";
    //Concatenate string with http:// prefix
    //NSString *completeURL = [urlPrefix stringByAppendingString:websiteStr];
    
    //Create URL object
    NSURL *restaurantURL = [[NSURL alloc]initWithString:websiteStr];
    if (restaurantURL != nil) {
        //Create NSURLRequest for launching website
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:restaurantURL];
        if (urlRequest != nil) {
            //Launch web page in web view
            [webView loadRequest:urlRequest];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
