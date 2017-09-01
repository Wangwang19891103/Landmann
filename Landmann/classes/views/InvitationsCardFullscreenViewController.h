//
//  InvitationsCardFullscreenViewController.h
//  Landmann
//
//  Created by Wang on 03.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InvitationsCardFullscreenViewControllerDelegate.h"

@interface InvitationsCardFullscreenViewController : UIViewController <UIScrollViewDelegate> {
    
    UIImage* _image;
    
}

@property (nonatomic, strong) IBOutlet UIImageView* imageView;

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;


@property (nonatomic, assign) id<InvitationsCardFullscreenViewControllerDelegate> delegate;


- (id) initWithImage:(UIImage*) image;

@end
