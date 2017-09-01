//
//  RootViewController.m
//  Landmann
//
//  Created by Wang on 06.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController


- (NSUInteger) supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


- (BOOL) shouldAutorotate {
    
    return TRUE;
}

@end
