//
//  ShoppingIngredientsSectionHeader.m
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingIngredientsSectionHeader.h"

@implementation ShoppingIngredientsSectionHeader


@synthesize background;
@synthesize titleLabel;


+ (id) sectionHeader {

    ShoppingIngredientsSectionHeader* header = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingIngredientsSectionHeader" owner:nil options:nil] firstElement];
    
    return header;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        self.background.image = [resource(@"Images.Shopping.SectionHeader.Background") resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
}


@end
