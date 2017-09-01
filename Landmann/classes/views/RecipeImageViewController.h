//
//  RecipeImageViewController.h
//  Landmann
//
//  Created by Wang on 24.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeImageViewControllerDelegate.h"


@interface RecipeImageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray* _sectionData;
    UIImageView* _overlayView;

}


@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, assign) id<RecipeImageViewControllerDelegate> delegate;

@end
