//
//  AppDelegate.h
//  Landmann
//
//  Created by Wang on 19.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate, UINavigationControllerDelegate> {
    
    UITabBarItem* _lastItem;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UITabBar* tabBar;

@property (nonatomic, strong) IBOutlet UINavigationController* navigationController;

@property (nonatomic, strong) IBOutlet MainMenuViewController* mainMenuController;

@property (nonatomic, strong) IBOutlet UIView* view2;

@end
