//
//  MainMenuViewController.h
//  Landmann
//
//  Created by Wang on 14.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface MainMenuViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
 
    CGImageRef _image;
    CGImageRef _imageSelected;
}


- (void) pushInvitations;
- (void) pushShopping;

@end
