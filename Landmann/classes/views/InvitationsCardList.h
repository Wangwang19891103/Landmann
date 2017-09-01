//
//  InvitationsCardList.h
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationsCardListDelegate.h"


@interface InvitationsCardList : UIView {
    
}

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, assign) IBOutlet id<InvitationsCardListDelegate> delegate;


- (id) initWithImages:(NSArray*) images;


- (void) setImages:(NSArray*) images;

@end
