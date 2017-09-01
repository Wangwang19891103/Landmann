//
//  RecipeDetailsTipViewController.h
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeDetailsTipViewControllerDelegate.h"


@interface RecipeDetailsTipViewController : UIViewController {
    
    NSString* _text;
    UIImage* _backgroundImage;
}


@property (nonatomic, strong) IBOutlet UIImageView* tipImage;

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UITextView* tipTextView;

@property (nonatomic, assign) id<RecipeDetailsTipViewControllerDelegate> delegate;


- (id) initWithText:(NSString*) text;

- (IBAction) actionClose;

- (void) getReady;

@end
