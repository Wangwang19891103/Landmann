//
//  MainScreenViewController.m
//  Landmann
//
//  Created by Wang on 16.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "MainScreenViewController.h"

@implementation MainScreenViewController


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {

        
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:false];
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:false];
}

@end
