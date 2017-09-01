//
//  ShoppingIngredientsSectionHeader.h
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingIngredientsSectionHeader : UIView

@property (nonatomic, strong) IBOutlet UIImageView* background;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;


+ (id) sectionHeader;


@end
