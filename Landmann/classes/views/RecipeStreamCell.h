//
//  RecipeStreamCell.h
//  Landmann
//
//  Created by Wang on 31.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeStreamCell : UICollectionViewCell {
    
    UIImageView* _containerView;
    UILabel* _titleLabel;
    UIView* _highlightView;
}


@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) NSString* titleText;

@end
