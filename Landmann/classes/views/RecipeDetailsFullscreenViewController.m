//
//  RecipeDetailsFullscreenViewController.m
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeDetailsFullscreenViewController.h"

@implementation RecipeDetailsFullscreenViewController


@synthesize imageView;
@synthesize delegate;


- (id) initWithImage:(UIImage *)image {

    if (self = [super initWithNibName:@"RecipeDetailsFullscreenViewController" bundle:[NSBundle mainBundle]]) {
     
//        UIImageOrientation orientation = (image.size.width > image.size.height) ? UIImageOrientationLeft : UIImageOrientationUp;
        
        UIImageOrientation orientation;
        
        if (image.size.width > image.size.height) {
            
            orientation = (is_ipad) ? UIImageOrientationUp : UIImageOrientationLeft;
        }
        else {
            
            orientation = (is_ipad) ? UIImageOrientationLeft : UIImageOrientationUp;
        }
        
        _image = [[UIImage alloc] initWithCGImage:image.CGImage scale:image.scale orientation:orientation];
        
        UIGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.view addGestureRecognizer:recognizer];
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    imageView.image = _image;
}


- (void) handleTapGesture:(UIGestureRecognizer*) recognizer {
    
    if ([delegate respondsToSelector:@selector(recipeDetailsFullScreenViewControllerDidRequestClosing:)]) {
        
        [delegate recipeDetailsFullScreenViewControllerDidRequestClosing:self];
    }
}


@end
