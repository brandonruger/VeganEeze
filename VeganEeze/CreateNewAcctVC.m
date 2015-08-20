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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createNewAccount:(id)sender
{
    
    //Create an alert to let user know account has been created
    UIAlertView *createAcctAlert = [[UIAlertView alloc]initWithTitle:@"New Account" message:@"Your new account has been created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    if (createAcctAlert != nil) {
        [createAcctAlert show];
    }
    
}

@end
