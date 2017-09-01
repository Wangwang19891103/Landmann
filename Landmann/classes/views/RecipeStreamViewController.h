//
//  RecipeStreamViewController.h
//  Landmann
//
//  Created by Wang on 15.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeStreamViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    NSArray* _data;
    
    NSArray* _images;
}


//@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
//
//@property (nonatomic, strong) IBOutlet UIView* contentView;

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;

@end
