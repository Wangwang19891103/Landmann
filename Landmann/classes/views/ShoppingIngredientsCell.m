//
//  ShoppingIngredientsCell.m
//  Landmann
//
//  Created by Wang on 19.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "ShoppingIngredientsCell.h"

@implementation ShoppingIngredientsCell


@synthesize checkbox;
@synthesize titleLabel;
@synthesize shoppingEntries;
@synthesize contentView2;


+ (id) cell {
    
    ShoppingIngredientsCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingIngredientsCell" owner:nil options:nil] firstElement];
    
    return cell;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
    
//        [self.contentView addSubview:contentView2];
        
        BOOL allChecked = true;
        
        for (UserShoppingEntry* entry in shoppingEntries) {
            
            if (!entry.checked) {
                allChecked = false;
                break;
            }
        }
        
        checkbox.selected = allChecked;
    }
}


- (IBAction) actionCheck:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    for (UserShoppingEntry* entry in shoppingEntries) {
        
        entry.checked = sender.selected;
    }
    
    [[DataManager instanceNamed:@"user"] save];
}


- (void) prepareForReuse {
    
    [super prepareForReuse];
    
    titleLabel.text = nil;
    shoppingEntries = nil;
    checkbox.selected = false;
}


@end



@implementation ShoppingIngredientsCellEdit


@synthesize textView;
@synthesize delegate;


+ (id) cell {
    
    ShoppingIngredientsCellEdit* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingIngredientsCell" owner:nil options:nil] objectAtIndex:1];
    
    return cell;
}


- (void) resign {

    [textView resignFirstResponder];
}


- (void) prepareForReuse {
    
    [super prepareForReuse];

    textView.text = nil;
}



#pragma mark Delegate methods

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    if ([delegate respondsToSelector:@selector(shoppingIngredientsCellDidBeginEditing:)]) {
        
        [delegate shoppingIngredientsCellDidBeginEditing:self];
    }
    
    if (textView.text.length > 0) {
        
        [textView performSelector:@selector(selectAll:) withObject:self afterDelay:0.1];
    }
}


- (void) textViewDidEndEditing:(UITextView *)textView {
    
    // save text
    
    UserShoppingEntry* entry = [self.shoppingEntries firstElement];
    entry.text = textView.text;
    
    [[DataManager instanceNamed:@"user"] save];
    
    if ([delegate respondsToSelector:@selector(shoppingIngredientsCellDidEndEditing:)]) {
        
        [delegate shoppingIngredientsCellDidEndEditing:self];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];

        return NO;
    }

    return YES;
}


@end
