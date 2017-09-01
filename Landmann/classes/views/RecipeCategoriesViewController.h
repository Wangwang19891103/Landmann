//
//  RecipeCategoriesViewController.h
//  Landmann
//
//  Created by Wang on 15.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeCategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    CGImageRef _image;
    CGImageRef _imageSelected;
    uint* _heights;
    NSString* __strong * _categories;
    
    UISearchBar* _searchBar;
}


@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UIImageView* penView;

@end
