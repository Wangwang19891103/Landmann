//
//  RecipeDetailsTipViewControllerIpad.h
//  Landmann
//
//  Created by Wang on 05.06.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeDetailsTipViewControllerDelegate.h"


@interface RecipeDetailsTipViewControllerIpad : UIViewController {
 
    NSString* _text;
}


@property (nonatomic, assign) id<RecipeDetailsTipViewControllerDelegate> delegate;


- (id) initWithText:(NSString*) text;

- (IBAction) actionClose;


@end



