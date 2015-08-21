//
//  CreateNewAcctVC.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "CreateNewAcctVC.h"
#import "MainMenuTVC.h"

@interface CreateNewAcctVC ()

@end

@implementation CreateNewAcctVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//Segue to main menu
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    if (createAcctAlert != nil) {
        [createAcctAlert show];
    }
}


//- (IBAction)createNewAccount:(id)sender
//{
//    
//    //Create an alert to let user know account has been created
//    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    if (createAcctAlert != nil) {
//        [createAcctAlert show];
//    }
//    
//}

@end
