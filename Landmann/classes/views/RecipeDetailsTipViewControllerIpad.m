//
//  RecipeDetailsTipViewControllerIpad.m
//  Landmann
//
//  Created by Wang on 05.06.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeDetailsTipViewControllerIpad.h"

@implementation RecipeDetailsTipViewControllerIpad


@synthesize delegate;


- (id) initWithText:(NSString*) text {

    if (self = [super initWithNibName:@"RecipeDetailsTipViewControllerIpad" bundle:[NSBundle mainBundle]]) {
        
        _text = [text copy];
        
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
}


- (IBAction) actionClose {
    
    if ([delegate respondsToSelector:@selector(tipViewControllerRequestsClosing:)]) {
        
        [delegate tipViewControllerRequestsClosing:self];
    }
}


@end
