//
//  RecipeDetailsFullscreenViewController.h
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeDetailsFullscreenViewControllerDelegate.h"

@interface RecipeDetailsFullscreenViewController : UIViewController {
    
    UIImage* _image;
    
}

@property (nonatomic, strong) IBOutlet UIImageView* imageView;


@property (nonatomic, assign) id<RecipeDetailsFullscreenViewControllerDelegate> delegate;


- (id) initWithImage:(UIImage*) image;

@end
