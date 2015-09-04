//
//  AppDelegate.m
//  VeganEeze
//
//  Created by Brandon Ruger on 8/18/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MainMenuTVC.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"v8eJm6knh4HnHxTHcus6DqCSi9FMAnRgwpdMtSrO"
                  clientKey:@"pBnwvQ4nV83dEUlgpdJTTG8f70ysBETFLn8noEEx"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
<<<<<<< HEAD
<<<<<<< HEAD
    
=======
<<<<<<< HEAD
=======
>>>>>>> origin/master
//    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    UIStoryboard *veganEezeSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    
//    //Check if user is currently logged in
//    PFUser *loggedInUser = [PFUser currentUser];
//    if (loggedInUser) {
//        //User is logged in, make Main Menu the root view controller
//        UIViewController *mainMenuVC = [veganEezeSB instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
//        self.window.rootViewController = mainMenuVC;
//        [self.window makeKeyAndVisible];
//        
//    } else {
//        //User is not logged in, make login screen the root view controller
//        UIViewController *loginVC = [veganEezeSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        self.window.rootViewController = loginVC;
//        [self.window makeKeyAndVisible];
//    }
    
    
=======
>>>>>>> parent of 2d9f34f... Trying to change initial view controller
<<<<<<< HEAD
>>>>>>> origin/master
=======
>>>>>>> origin/master
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
