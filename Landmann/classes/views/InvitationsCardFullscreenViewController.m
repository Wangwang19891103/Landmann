//
//  InvitationsCardFullscreenViewController.m
//  Landmann
//
//  Created by Wang on 03.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationsCardFullscreenViewController.h"

@implementation InvitationsCardFullscreenViewController


@synthesize imageView;
@synthesize delegate;
@synthesize scrollView;


- (id) initWithImage:(UIImage *)image {
    
    if (self = [super initWithNibName:@"InvitationsCardFullscreenViewController" bundle:[NSBundle mainBundle]]) {
        
        if (is_ipad) {
            _image = [UIImage imageWithCGImage:image.CGImage scale:0.0f orientation:UIImageOrientationRight];
        }
        else {
            _image = image;
        }
        
        UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.view addGestureRecognizer:recognizer];
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    imageView.image = _image;
    [imageView setFrameSize:_image.size];
    [scrollView setContentSize:_image.size];
    
    float ratio = ((is_ipad) ? 1024 : 320) / _image.size.width;
    [scrollView setMinimumZoomScale:ratio];
    [scrollView setMaximumZoomScale:1.0];
    [scrollView setZoomScale:ratio];
}


- (void) handleTapGesture:(UIGestureRecognizer*) recognizer {
    
    if ([delegate respondsToSelector:@selector(invitationsCardFullScreenViewControllerDidRequestClosing:)]) {
        
        [delegate invitationsCardFullScreenViewControllerDidRequestClosing:self];
    }
}


- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return imageView;
}

@end
