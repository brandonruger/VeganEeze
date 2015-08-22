//
//  SavedPlacesDetailVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/22/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "SavedPlacesDetailVC.h"
#import "WebVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface SavedPlacesDetailVC ()

@end

@implementation SavedPlacesDetailVC
@synthesize name, address, cityState, phoneNo, url;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Access user's Twitter account on device
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    if (accountStore != nil) {
        //Tell what type of account need to access
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (accountType != nil) {
            //Ask account store for direct access to Twitter account
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    //Success, we have access
                    NSArray *userTwitterAccts = [accountStore accountsWithAccountType:accountType];
                    if (userTwitterAccts != nil) {
                        //Access single account
                        ACAccount *currentAcct = [userTwitterAccts objectAtIndex:0];
                        if (currentAcct != nil) {
                            NSLog(@"currentAccount=%@", currentAcct);
                        }
                        NSLog(@"twitter accounts = %@", userTwitterAccts);
                    }
                }
                else {
                    //User did not approve accessing Twitter account
                    
                    //***NEED TO HANDLE THIS***
                }
            }];
        }
    }

}

#pragma mark - Twitter Sharing
-(IBAction)shareToTwitter:(id)sender {
    
    //Create view that allows user to post to Twitter
    SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *twitterPrefixString = @"Check this place out: ";
    NSString *twitterFullString = [twitterPrefixString stringByAppendingString:url];
    
    //Add in default text to share
    [slComposeVC setInitialText:twitterFullString];
    
    //Present view to user for posting
    [self presentViewController:slComposeVC animated:TRUE completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    
    //Set event labels to display information passed over from segue
    nameLabel.text = name;
    addressLabel.text = address;
    cityStateLabel.text = cityState;
    phoneLabel.text = phoneNo;
    
    //Set URL button text
    [urlLabel setTitle:url forState:UIControlStateNormal];
    
}

#pragma mark - Navigation

//Segue method to pass information to detail view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Access the web view
    WebVC *webVC = segue.destinationViewController;
    //Pass restaurant's URL to web view
    webVC.websiteStr = url;
    
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
