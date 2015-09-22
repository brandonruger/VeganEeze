//
//  CreateNewAcctVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Reachability.h"

@interface CreateNewAcctVC : UIViewController <UITextFieldDelegate>


{
    IBOutlet UITextField *selectUsername;
    IBOutlet UITextField *selectPassword;
    IBOutlet UITextField *confirmPassword;
    IBOutlet UITextField *enterEmail;
    
    NSString *username;
    NSString *password;
    NSString *secondPassword;
    NSString *emailAddress;
    
    PFUser *loggedInUser;
}

@end
