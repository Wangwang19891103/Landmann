//
//  InvitationsCardListDelegate.h
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class InvitationsCardList;


@protocol InvitationsCardListDelegate <NSObject>

- (void) cardList:(InvitationsCardList*) cardList didSelectImageAtIndex:(uint) index;

@end
