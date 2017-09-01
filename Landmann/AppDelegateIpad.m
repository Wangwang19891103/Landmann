//
//  AppDelegateIpad.m
//  Landmann
//
//  Created by Wang on 12.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "AppDelegateIpad.h"
#import "MainMenuViewController.h"
#import "UserProfileViewController.h"


@implementation AppDelegateIpad


@synthesize window;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if ([SettingsManager sharedInstance].firstRun) {
        
        [SettingsManager sharedInstance].firstRun = false;
        
        UserProfileViewController* controller = [[UserProfileViewController alloc] init];
        UIImage* backButtonImage = resource(@"Images.NavigationBar.BackButton");
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
        [backButton addTarget:self action:@selector(popViewController2) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        controller.navigationItem.leftBarButtonItem = backButtonItem;
        
        [self.customNavigationController pushViewController:controller animated:false];
    }

    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void) popViewController2 {
    
    [self.customNavigationController popViewControllerAnimated:false];
}


@end
