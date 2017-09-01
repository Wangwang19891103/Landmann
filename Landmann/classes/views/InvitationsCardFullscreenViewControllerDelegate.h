//
//  InvitationsCardFullscreenViewControllerDelegate.h
//  Landmann
//
//  Created by Wang on 03.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InvitationsCardFullscreenViewController;


@protocol InvitationsCardFullscreenViewControllerDelegate <NSObject>


- (void) invitationsCardFullScreenViewControllerDidRequestClosing:(InvitationsCardFullscreenViewController*) controller;

@end
