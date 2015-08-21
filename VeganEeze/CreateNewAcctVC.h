//
//  CreateNewAcctVC.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewAcctVC : UIViewController <UITextFieldDelegate>

//- (IBAction)createNewAccount:(id)sender;

{
    IBOutlet UITextField *selectUsername;
    IBOutlet UITextField *selectPassword;
    IBOutlet UITextField *confirmPassword;
    IBOutlet UIButton *cancelButton;
}

@end
