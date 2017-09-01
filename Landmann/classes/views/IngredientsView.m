//
//  IngredientsView.m
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "IngredientsView.h"
#import "FloatFormatter.h"


#define TOUCH_RECT CGRectMake(0, 308, 277, 38)
//#define POSITION_IN CGPointMake(43, -108)
//#define POSITION_OUT CGPointMake(43, 193)
#define ANIMATION_DURATION 0.5
#define INFO_BAR_BOTTOM_BORDER ((is_ipad) ? 343 : 200)
#define POSITION_IN_BOTOM_MARGIN 38

#define MARGIN_TOP 0
#define COL1_RIGHT 65
#define COL2_LEFT 72
#define COL2_RIGHT 10
#define PADDING 10
#define LINE_SPACING 5
#define FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]


@implementation IngredientsView


@synthesize delegate;
//@synthesize scrollView;
@synthesize textField;
@synthesize contentView;
@synthesize addButton;
@synthesize background;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        _isOut = false;
        _scale = 1;
        _baseScale = 1;
        
//        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:recognizer];
        
//        [self setFrameOrigin:POSITION_IN];
        
        [self setFrameY:INFO_BAR_BOTTOM_BORDER + POSITION_IN_BOTOM_MARGIN - self.bounds.size.height];
        
    }
    
    return self;
}


- (void) awakeFromNib {
    
    background.image = [background.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 40, 0) resizingMode:UIImageResizingModeStretch];
}


- (IBAction) handleTap {
    
    [self toggle];
}


- (void) toggle {
    
//    CGPoint newPosition;
    float newY;
    
    if (_isOut) {
        
//        newPosition = POSITION_IN;
        newY = INFO_BAR_BOTTOM_BORDER + POSITION_IN_BOTOM_MARGIN - self.bounds.size.height;

        addButton.userInteractionEnabled = false;
        textField.userInteractionEnabled = false;
        _isOut = false;
    }
    else {
        
//        newPosition = POSITION_OUT;
        newY = INFO_BAR_BOTTOM_BORDER;
        addButton.userInteractionEnabled = true;
        textField.userInteractionEnabled = true;
        _isOut = true;
    }
    
    
    
    [delegate ingredientsView:self willMoveToPosition:CGPointMake(self.frame.origin.x, newY) withDuration:ANIMATION_DURATION];

    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         
                         [self setFrameY:newY];
                     }
                     completion:nil];
}


- (void) setIngredients:(NSArray *)array withBaseScale:(uint) scale {
    
    _ingredients = array;
    _scale = scale;
    _baseScale = scale;
    
    [self updateIngredients];
    
    textField.text = [NSString stringWithFormat:@"%d", _scale];
}


- (void) updateIngredients {
    
    float contentHeightBefore = contentView.bounds.size.height;
    float viewHeightBefore = self.bounds.size.height;
    
    
    float posY = MARGIN_TOP;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float scaleRatio = (float)_scale / _baseScale;
    
    for (NSArray* ingArray in _ingredients) {
        
        NSString* title = [ingArray objectAtIndex:0];
        float amount = [[ingArray objectAtIndex:1] floatValue] * scaleRatio;
        NSString* unit = [ingArray objectAtIndex:2];
        
        // COL 1
//        BOOL amountIsFloat = amount - (int)amount > 0;
        
        NSString* string1 = nil;
        if (amount == 0) {
            string1 = @"";
        }
        else {
            string1 = [NSString stringWithFormat:@"%@%@", [FloatFormatter stringForFloat:amount], (unit.length > 0) ? [NSString stringWithFormat:@" %@", unit] : @""];
        }
        
//        else if (amountIsFloat) {
//            string1 = [NSString stringWithFormat:@"%f %@", amount, unit];
//        }
//        else {
//            string1 = [NSString stringWithFormat:@"%d %@", (int)amount, unit];
//        }

        CGSize textSize = [string1 sizeWithFont:FONT];
        
        float posX = COL1_RIGHT - textSize.width;
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, textSize.width, textSize.height)];
        [label1 setText:string1];
        [label1 setFont:FONT];
        [label1 setTextColor:[UIColor blackColor]];
        label1.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:label1];
        
        
        // COL2
        textSize = [title sizeWithFont:FONT constrainedToSize:CGSizeMake(self.contentView.bounds.size.width - COL2_RIGHT - COL2_LEFT, 200) lineBreakMode:NSLineBreakByWordWrapping];
        posX = COL2_LEFT;
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, textSize.width, textSize.height)];
        [label2 setText:title];
        label2.numberOfLines = 0;
        label2.lineBreakMode = UILineBreakModeWordWrap;
        [label2 setFont:FONT];
        [label2 setTextColor:[UIColor blackColor]];
        label2.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:label2];
        
        
        posY += textSize.height + PADDING;
    }
    
    [self.contentView setFrameHeight:posY];
//    [self.scrollView setContentSize:self.contentView.bounds.size];
    
    [self setFrameHeight:(viewHeightBefore - contentHeightBefore) + posY];
    
    if (!_isOut) {
    
        [self setFrameY:INFO_BAR_BOTTOM_BORDER + POSITION_IN_BOTOM_MARGIN - self.bounds.size.height];
    }
    else {
        
        [self setFrameY:INFO_BAR_BOTTOM_BORDER];
    }

}


- (IBAction) actionShopping:(UIButton *)sender {

    if ([delegate respondsToSelector:@selector(ingredientsView:addToShoppingListWithScale:)]) {
        
        [delegate ingredientsView:self addToShoppingListWithScale:_scale];
    }
    
//    sender.enabled = false;
}


//- (void) setAdded {
//    
//    addButton.enabled = false;
//}



#pragma mark Delegate Methode

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [delegate ingredientsViewDidBeginEditing:self];
    
    if (textField.text.length > 0) {
        
        [textField selectAll:self];
    }
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    _scale = [textField.text integerValue];
    [self updateIngredients];
    
    [delegate ingredientsViewDidEndEditing:self];
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    return true;
}


- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
    
    return true;
}


- (void) touchViewDidReceiveTouchOutside:(TouchView *)view {
    
    NSLog(@"touch");
    
    if ([self.textField isFirstResponder]) {
        
        [self.textField resignFirstResponder];
    }
}


- (void) resign {
    
    if ([self.textField isFirstResponder]) {
        
        [self.textField resignFirstResponder];
    }
}

@end
