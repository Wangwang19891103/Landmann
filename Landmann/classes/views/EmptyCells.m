//
//  EmptyCells.m
//  Landmann
//
//  Created by Wang on 23.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "EmptyCells.h"

@implementation EmptyRecipeCell


@synthesize background;
@synthesize titleLabel;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _background = [resource(@"Images.RecipeMenu.Cells.Background") resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
    
    return self;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        self.background.image = _background;
    }
}



+ (id) cell {
    
    EmptyRecipeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"EmptyCells" owner:nil options:nil] objectAtIndex:0];
    
    return cell;
}


@end




@implementation EmptyIngredientsCell



- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
    }
}



+ (id) cell {
    
    EmptyIngredientsCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"EmptyCells" owner:nil options:nil] objectAtIndex:1];
    
    return cell;
}


@end
