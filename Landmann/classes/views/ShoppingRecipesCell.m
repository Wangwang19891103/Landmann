//
//  ShoppingRecipesCell.m
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingRecipesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SubviewIterator.h"


#define TEXTCOLOR [UIColor blackColor]
#define TEXTCOLOR_SELECTED [UIColor whiteColor]

#define CONTENTVIEW_EDITMODE_INDENTATION 40
#define DELETE_BUTTON_WIDTH 85 // depends on string length


@implementation ShoppingRecipesCell


@synthesize background;
@synthesize titleLabel;
@synthesize contentView2;


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
        [self.contentView addSubview:contentView2];
        
    }
}


- (void) prepareForReuse {
    
    [super prepareForReuse];
    
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


@end




@implementation ShoppingRecipesCellRecipe


@synthesize image;
@synthesize editView;
@synthesize delegate;
@synthesize recipeNumber;
@synthesize indexPath;


+ (id) cell {
    
    ShoppingRecipesCellRecipe* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingRecipesCell" owner:nil options:nil] objectAtIndex:0];
    
    return cell;
}


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _fromState = UITableViewCellStateDefaultMask;
    }
    
    return self;
}


- (void) awakeFromNib {
    
    [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"haha"];
    
//    self.autoresizesSubviews = false;
//    self.contentView.autoresizingMask = 0;

}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"change: %@", change);
    NSLog(@"animations: %@", [self.contentView.layer animationKeys]);
}

//- (void) setEditingMode:(BOOL)editing animated:(BOOL)animated {
//    
//    _editing = editing;
//    
//    float x = (editing) ? EDIT_VIEW_POSITION_IN : EDIT_VIEW_POSITION_OUT;
//
//    if (animated) {
//        [UIView animateWithDuration:0.3 animations:^(void) {
//            [editView setFrameX:x];
//        }];
//    }
//    else {
//        [editView setFrameX:x];
//    }
//}


//- (void) didMoveToSuperview {
//    
//    [super didMoveToSuperview];
//    
//    if (_editing) {
//        
//        [self setEditingMode:_editing animated:false];
//    }
//}


- (void) willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
    

    
    NSLog(@"(%d) will transition to state: %d", recipeNumber, state);
    
    _toState = state;
    _transitioning = TRUE;
    

}


- (void) layoutSubviews {
    
    [super layoutSubviews];
    
//    return;

    
    NSLog(@"(%d) layout subviews (from: %d, to: %d, trans: %d)", recipeNumber, _fromState, _toState, _transitioning);

    
    
//    if (_toState == 1 || _toState == 3) {
//        
//        SubviewIterator* iterator = [[SubviewIterator alloc] initWithView:self];
//        
//        UIView* subview = nil;
//        while ((subview = [iterator nextView])) {
//            
//            if ([NSStringFromClass(subview.class) isEqualToString:@"UITableViewCellEditControl"]) {
//                
//                NSLog(@"FOUND");
//                
//                NSLog(@"subview: %@", subview);
//                
//                [subview setFrameX:0];
//                [subview setFrameWidth:CONTENTVIEW_EDITMODE_INDENTATION];
//                subview.alpha = 1.0;
//            }
//        }
//    }
    
    
//    if (_toState == _fromState) return;
    
    if (_fromState == 3 && _toState == 1) {


    }
    
    
    float x;
    float width;
    
    if (_toState == UITableViewCellStateShowingEditControlMask) {
        
        x = CONTENTVIEW_EDITMODE_INDENTATION;
        width = 290 - x;
    }
    else if (_toState == 3) {
        
        x = CONTENTVIEW_EDITMODE_INDENTATION;
        width = 290 - 85 - x;
    }
    else {
        
        x = 0;
        width = 290 - x;
    }
    
    
    if (_transitioning) {

//        float x2;
//        
//        if (_fromState == UITableViewCellStateShowingEditControlMask || _fromState == 3) {
//            
//            x2 = CONTENTVIEW_EDITMODE_INDENTATION;
//        }
//        else {
//            
//            x2 = 0;
//        }
        
        NSLog(@"x: %f, width: %f", x, width);
        
//        [self.contentView setFrameX:x2];  // egal
        
        _x = x;
        
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void) {
                             [self.contentView setFrameX:x];
                             [self.contentView setFrameWidth:width];
                         }
                         completion:nil];

    }
    else {
        
        [self.contentView setFrameX:x];
    }
}


- (void) didTransitionToState:(UITableViewCellStateMask)state {
    
    [super didTransitionToState:state];

    
    NSLog(@"(%d) did transition to state: %d", recipeNumber, state);

    _fromState = state;
    _toState = state;
    _transitioning = FALSE;
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    
    if (editing)
        _toState = _fromState = UITableViewCellStateShowingEditControlMask;
    
    else
        _toState = _fromState = UITableViewCellStateDefaultMask;
}


//- (void) setEditingMode:(BOOL)editing animated:(BOOL)animated {
//    
////    [super setEditing:editing animated:animated];
//    
//    if (_editing != editing) {
//    
//        float x = (editing) ? CONTENTVIEW_EDITMODE_INDENTATION : 0;
//
//        NSLog(@"cell editing: %d, x: %f", editing, x);
//        
//        if (animated) {
//            
//            [UIView animateWithDuration:0.3 animations:^(void) {
//            } ];
//            
//            [UIView animateWithDuration:0.3
//                                  delay:0.0
//                                options:UIViewAnimationOptionBeginFromCurrentState
//                             animations:^(void) {
//                                 [self.contentView setFrameX:x];
//                             }
//                             completion:nil];
//        }
//        else {
//
//            [self.contentView setFrameX:x];
//        }
//
//        _editing = editing;
//    }
//}


- (IBAction) actionDelete {
    
    NSLog(@"delete");
    
    if ([delegate respondsToSelector:@selector(shoppingRecipesCellRequestsDeletion:)]) {
        
        [delegate shoppingRecipesCellRequestsDeletion:self];
    }
}


- (void) dealloc {
    
    [self.contentView removeObserver:self forKeyPath:@"frame"];
}


@end
