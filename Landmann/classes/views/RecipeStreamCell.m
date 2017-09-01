//
//  RecipeStreamCell.m
//  Landmann
//
//  Created by Wang on 31.05.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "RecipeStreamCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Extensions.h"


#define ITEM_SIZE               CGSizeMake(220,220)
#define ITEM_INSETS             UIEdgeInsetsMake(2,2,2,2)
#define ITEM_MARGIN_LEFT        5
#define ITEM_MARGIN_TOP         10
#define ITEM_PADDING            8
#define ITEM_COUNT_X            3
#define ITEM_MARGIN_BOTTOM      10
#define ITEM_TITLE_VIEW_HEIGHT  47
#define ITEM_TITLE_TEXT_MARGIN  10
#define ITEM_TITLE_TEXT_FONT    [UIFont fontWithName:@"Helvetica-Light" size:16.0]
#define ITEM_TITLE_BACKGROUND   @"Images.RecipeStream.TitleBackground"
#define ITEM_BACKGROUND         @"Images.RecipeStream.ItemBackground"


@implementation RecipeStreamCell


@synthesize imageView;
@synthesize titleText;


- (id) initWithFrame:(CGRect)frame {
    
    static uint count = 0;
    count++;
    NSLog(@"COUNT: %d", count);
    
    
    if (self = [super initWithFrame:frame]) {
        
        _containerView = [[UIImageView alloc] initWithFrame:self.bounds];
        _containerView.image = [resource(ITEM_BACKGROUND) resizableImageWithCapInsets:UIEdgeInsetsZero];
        _containerView.layer.mask = [CALayer maskLayerWithSize:_containerView.bounds.size roundedCornersTop:YES bottom:YES left:YES right:YES radius:3.0];
        _containerView.layer.mask.frame = _containerView.bounds;
        _containerView.layer.masksToBounds = true;
        
//        // imageView
//        NSString* fileName = [NSString stringWithFormat:@"_%@_thumb.jpg", [recipe.imageFull stringByReplacingOccurrencesOfString:@" " withString:@""]];
//        NSString* imagePath = [RECIPE_IMAGES_THUMB_IPAD stringByAppendingPathComponent:fileName];
//        NSString* fullPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:nil];
//        UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
        imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGSizeInset(ITEM_SIZE, ITEM_INSETS);
        [_containerView addSubview:imageView];
        //        [contentView addSubview:containerView];
        
        // titleView
        UIImageView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(ITEM_INSETS.left,
                                                                               ITEM_INSETS.top,
                                                                               ITEM_SIZE.width - ITEM_INSETS.left - ITEM_INSETS.right,
                                                                               ITEM_TITLE_VIEW_HEIGHT)];
        titleView.alpha = 0.8;
        titleView.image = [resource(ITEM_TITLE_BACKGROUND) resizableImageWithCapInsets:UIEdgeInsetsZero];
        [_containerView addSubview:titleView];
        
        // titleLabel
        float textWidth = imageView.bounds.size.width - (2 * ITEM_TITLE_TEXT_MARGIN);
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textWidth, 10)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = ITEM_TITLE_TEXT_FONT;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        //        CGPoint centerPoint = CGPointMake(ITEM_SIZE.width * 0.5,
        //                                          ITEM_TITLE_VIEW_HEIGHT * 0.5 + ITEM_INSETS.top);
        //        [label centerOverPoint:centerPoint];
//        _titleLabel.backgroundColor = [UIColor whiteColor];
        [titleView addSubview:_titleLabel];
        [_titleLabel centerXInSuperview];
        [_titleLabel centerYInSuperview];
        
        _highlightView = [[UIView alloc] initWithFrame:imageView.frame];
        _highlightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _highlightView.hidden = true;
        [_containerView addSubview:_highlightView];
        
        [self.contentView addSubview:_containerView];
    }
    
    return self;
}


- (void) setTitleText:(NSString *)titleText {
    
    float textWidth = imageView.bounds.size.width - (2 * ITEM_TITLE_TEXT_MARGIN);
    
    CGSize textSize = [titleText sizeWithFont:ITEM_TITLE_TEXT_FONT constrainedToSize:CGSizeMake(textWidth, ITEM_TITLE_VIEW_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"text: %@ (size: %@, maxwidth: %f)", titleText, NSStringFromCGSize(textSize), textWidth);
    
//    textSize.width += 0;
//    textSize.height += 10;
    
    [_titleLabel setFrameHeight:textSize.height];
//    [_titleLabel setFrameSize:textSize];
    _titleLabel.text = titleText;
//    [_titleLabel centerXInSuperview];
    [_titleLabel centerYInSuperview];
}


- (void) prepareForReuse {
    
    [super prepareForReuse];
    
    imageView.image = nil;
    _titleLabel.text = nil;
}


- (void) setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    _highlightView.hidden = !highlighted;
}


- (void) setSelected:(BOOL)selected {
    
}

@end
