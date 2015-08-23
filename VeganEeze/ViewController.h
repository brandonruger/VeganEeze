//
//  ViewController.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIButton *cancelButton;
    
    NSString *usernameStr;
    NSString *passwordStr;
    
    PFUser *loggedInUser;
    
}


@end

