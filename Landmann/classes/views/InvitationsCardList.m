//
//  InvitationsCardList.m
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "InvitationsCardList.h"


#define CARD_SIZE CGSizeMake(57,80)
#define CARD_HPADDING 8


@implementation InvitationsCardList


@synthesize scrollView;
@synthesize contentView;
@synthesize delegate;


- (void) setImages:(NSArray *)images {
    
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.superview) {
        
        UIImage* background = [resource(@"Images.Invitations.List.ListBackground") resizableImageWithCapInsets:UIEdgeInsetsZero];
        UIImageView* backgroundView = [[UIImageView alloc] initWithImage:background];
        [backgroundView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:backgroundView];
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        
        float contentWidth = images.count * CARD_SIZE.width + images.count * CARD_HPADDING;
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, self.bounds.size.height)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.opaque = false;
        [scrollView addSubview:contentView];
        scrollView.contentSize = contentView.bounds.size;
        
        float posY = ceil((self.bounds.size.height - CARD_SIZE.height) * 0.5);
        float posX = floor(CARD_HPADDING * 0.5);
        
        for (uint i = 0; i < images.count; ++i) {
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(posX, posY, CARD_SIZE.width, CARD_SIZE.height)];
            [button addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000 + i;
            [contentView addSubview:button];
            
            posX += CARD_SIZE.width + CARD_HPADDING;
        }
    }

}


- (void) actionButton:(UIButton*) button {

    uint buttonIndex = button.tag - 1000;
    
    NSLog(@"button pressed: %d", buttonIndex);
    
    if ([delegate respondsToSelector:@selector(cardList:didSelectImageAtIndex:)]) {
        
        [delegate cardList:self didSelectImageAtIndex:buttonIndex];
    }
}

@end
