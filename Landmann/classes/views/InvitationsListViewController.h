//
//  InvitationsListViewController.h
//  Landmann
//
//  Created by Wang on 28.03.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationsCardList.h"
#import "InvitationsCardListDelegate.h"


@interface InvitationsListViewController : UIViewController <InvitationsCardListDelegate> {
    
    NSArray* _invitationData;
    uint _selectedIndex;
}


@property (nonatomic, strong) IBOutlet UIImageView* shadowImage;

@property (nonatomic, strong) IBOutlet UIImageView* largeImage;

@property (nonatomic, strong) IBOutlet InvitationsCardList* cardList;


- (IBAction) actionNext;


@end
