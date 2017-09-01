//
//  AppDelegateIpad.h
//  Landmann
//
//  Created by Wang on 12.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeStreamViewController.h"
#import "CustomNavigationController.h"


@interface AppDelegateIpad : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate> {
    
}


@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet CustomNavigationController* customNavigationController;


@end
