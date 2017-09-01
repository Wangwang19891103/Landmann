//
//  RecipeMenuCell.m
//  Landmann
//
//  Created by Wang on 18.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeMenuCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Extensions.h"


#define TEXTCOLOR [UIColor blackColor]
#define TEXTCOLOR_SELECTED [UIColor whiteColor]


@implementation RecipeMenuCell


@synthesize background;
@synthesize image;
@synthesize titleLabel;
@synthesize difficultyImage;


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
    
    self.background.image = _background;
    self.titleLabel.textColor = TEXTCOLOR;
}


+ (id) cell {
    
    RecipeMenuCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"RecipeMenuCell" owner:nil options:nil] objectAtIndex:0];
    
    return cell;
}


- (void) setDifficulty:(uint)difficulty {
    
    _difficulty = difficulty;
    
    NSString* path = [NSString stringWithFormat:@"Images.RecipeMenu.Cells.Icons.Difficulty%d", difficulty];
    UIImage* image = resource(path);
    
    self.difficultyImage.image = image;
}


- (void) setRed:(BOOL)red {
    
    NSString* path = [NSString stringWithFormat:@"Images.RecipeMenu.Cells.Icons.Difficulty%d%@", _difficulty, (red) ? @"Red" : @""];
    UIImage* image = resource(path);
    
    self.difficultyImage.image = image;
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


@end
