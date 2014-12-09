//
//  AppDelegate.m
//  BusOperator
//
//  Created by Macbook Pro on 5/8/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AppDelegate.h"
#import "UIStoryboard+MultipleStoryboards.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
//    [self setupTabBarController];
    //LoginVC
    
    
    UIStoryboard* sb = [UIStoryboard getReportTabStoryboard];
    
//    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SelectTicketTypeVC"];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];// //
    self.window.rootViewController = nav;
    
    
    
    return YES;
}

- (void)setupTabBarController
{
    UIStoryboard *sb = [UIStoryboard getReportTabStoryboard];
    UIViewController *reportVC= [sb instantiateInitialViewController];
    reportVC.tabBarItem.title = @"REPORTS";
    
    sb = [UIStoryboard getManageTabStoryboard];
    UIViewController *manageVC = [sb instantiateInitialViewController];
    manageVC.tabBarItem.title = @"ကားထြက္ခ်ိန္ စီမံရန္";
    
    sb = [UIStoryboard getTripListTabStoryboard];
    UIViewController *tripListVC = [sb instantiateInitialViewController];
    tripListVC.tabBarItem.title = @"ခရီးစဥ္မ်ား";
    
    sb = [UIStoryboard getAgentTabStoryboard];
    UIViewController *agentVC = [sb instantiateInitialViewController];
    agentVC.tabBarItem.title = @"၀န္ေဆာင္မႈလုုပ္ငန္းမ်ား";
    
    sb = [UIStoryboard getCustomerListStoryboard];
    UIViewController *customerListVC = [sb instantiateInitialViewController];
    customerListVC.tabBarItem.title = @"၀ယ္သူမ်ား";
    
//    sb = [UIStoryboard getManagePriceTabStoryboard];
//    UIViewController *managePricevc = [sb instantiateInitialViewController];
//    managePricevc.tabBarItem.title = @"MANAGE PRICE";
    
    sb = [UIStoryboard getSeatPlanStoryboard];
    UIViewController *seatplanvc = [sb instantiateInitialViewController];
    seatplanvc.tabBarItem.title = @"ထိုုင္ခံုု စီစဥ္ရန္";
    
    sb = [UIStoryboard getAddNewStoryboard];
    UIViewController *addnewvc = [sb instantiateInitialViewController];
    addnewvc.tabBarItem.title = @"စီမံရန္";

    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString* usertype = userinfo[@"type"];
    if ([usertype isEqualToString:@"operator"]) {
        tabBarController.viewControllers = @[tripListVC, agentVC, customerListVC,reportVC, manageVC];
    }
    else {
        tabBarController.viewControllers = @[tripListVC, agentVC, customerListVC,reportVC, manageVC, seatplanvc, addnewvc];
    }
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Zawgyi-One" size:14.0], NSFontAttributeName, nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor purpleColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Zawgyi-One" size:14.0], NSFontAttributeName, nil]
                                             forState:UIControlStateSelected];
    
   

    self.window.rootViewController = tabBarController;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
