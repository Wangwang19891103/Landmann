//
//  GrilltipsMenuCell.m
//  Landmann
//
//  Created by Wang on 17.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "GrilltipsMenuCell.h"


#define TEXTCOLOR [UIColor blackColor]
#define TEXTCOLOR_SELECTED [UIColor whiteColor]


@implementation GrilltipsMenuCell

@synthesize background;
@synthesize titleLabel;


+ (id) cell {
    
    GrilltipsMenuCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"GrilltipsMenuCell" owner:nil options:nil] objectAtIndex:0];
    
    return cell;
}


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _background = [resource(@"Images.RecipeMenu.Cells.Background") resizableImageWithCapInsets:UIEdgeInsetsZero];
        
        _backgorundSelected = [resource(@"Images.RecipeMenu.Cells.BackgroundSelected") resizableImageWithCapInsets:UIEdgeInsetsZero];
    }
    
    return self;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        self.background.image = _background;
        self.titleLabel.textColor = TEXTCOLOR;
    }
}


- (void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.selected = false;
    self.background.image = _background;
    self.titleLabel.textColor = TEXTCOLOR;
}


- (void) setHighlighted:(BOOL)highlighted {
    
    [self setHighlighted:highlighted animated:false];
}


- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    self.background.image = (highlighted) ? _backgorundSelected : _background;
    self.titleLabel.textColor = (highlighted) ? TEXTCOLOR_SELECTED : TEXTCOLOR;
    
    [super setHighlighted:highlighted animated:animated];
}


- (void) setSelected:(BOOL)selected {
    
    [self setSelected:selected animated:false];
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.background.image = (selected) ? _backgorundSelected : _background;
    self.titleLabel.textColor = (selected) ? TEXTCOLOR_SELECTED : TEXTCOLOR;
    
    [super setSelected:selected animated:animated];
}

//- (void) setSelected:(BOOL)selected {
//    
//    self.background.image = (selected) ? _backgorundSelected : _background;
//    self.titleLabel.textColor = (selected) ? TEXTCOLOR_SELECTED : TEXTCOLOR;
//}

@end
