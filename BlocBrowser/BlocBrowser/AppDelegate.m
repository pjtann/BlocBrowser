//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by PT on 12/3/15.
//  Copyright (c) 2015 PeterTanner. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // create a UI window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // set ViewController as the rootViewController of the navigation controller; using a
    // UINavigationController because it will provide a navigation bar to use for the web
    // page titles
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];
                                      
    [self.window makeKeyAndVisible];



    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // obtains a reference to the navigation controller; in our case the rootViewController
    UINavigationController *navigaionVC = (UINavigationController *) self.window.rootViewController;
    // obtain a reference to make it the first view controller
    ViewController *browserVC = [[navigaionVC viewControllers] firstObject];
    // send the reset message
    [browserVC resetWebView];
    
    
    
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
