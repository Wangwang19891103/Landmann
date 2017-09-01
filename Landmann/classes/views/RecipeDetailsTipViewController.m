//
//  RecipeDetailsTipViewController.m
//  Landmann
//
//  Created by Wang on 10.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeDetailsTipViewController.h"

@implementation RecipeDetailsTipViewController


@synthesize tipImage;
@synthesize tipTextView;
@synthesize delegate;
@synthesize background;


- (id) initWithText:(NSString*) text {

    if (self = [super initWithNibName:@"RecipeDetailsTipViewController" bundle:[NSBundle mainBundle]]) {
        
        _text = text;
    }
    
    return self;
}


- (void) viewDidLoad {

    [super viewDidLoad];
    
    
    NSString* newlineChar = @"\n";
    NSString* dummyNewLineChar= @"\\n";
    NSString* text = [_text stringByReplacingOccurrencesOfString:dummyNewLineChar withString:newlineChar];

    tipTextView.text = text;
    
    tipImage.image = [tipImage.image resizableImageWithCapInsets:UIEdgeInsetsMake(252, 0, 20, 0) resizingMode:UIImageResizingModeStretch];
}


- (void) getReady {

    if ([delegate respondsToSelector:@selector(tipViewControllerRequestsBackgroundImage:)]) {
        
        _backgroundImage = [delegate tipViewControllerRequestsBackgroundImage:self];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    background.image = _backgroundImage;
    background.hidden = false;
}


//- (void) viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//    
//}


//- (void) viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    
//    background.hidden = true;
//}


- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    background.hidden = true;
}


- (IBAction) actionClose {

    if ([delegate respondsToSelector:@selector(tipViewControllerRequestsClosing:)]) {
        
        [delegate tipViewControllerRequestsClosing:self];
    }
}

@end
