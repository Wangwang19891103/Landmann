//
//  UserProfileViewController.h
//  Landmann
//
//  Created by Wang on 20.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RotaryKnobDelegate.h"
#import "RotaryKnob.h"


@interface UserProfileViewController : UIViewController <RotaryKnobDelegate> {
    
    float* _paddings;
    float* _leftMargins;
}

@property (nonatomic, strong) IBOutlet UIScrollView* scrollview;

@property (nonatomic, strong) IBOutlet UIView* contentview;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray* subviews;

@property (nonatomic, strong) IBOutlet RotaryKnob* knob;


- (IBAction) actionSelectGrillType:(UIButton*) sender;

- (IBAction) actionSelectGrillType2:(UIButton *)sender;

- (IBAction) actionSelectGrillLocation:(UIButton *)sender;

- (IBAction) actionSelectGrillProfile:(UIButton *)sender;

- (IBAction) actionSelectGrillPerson:(UIButton *)sender;


- (IBAction) actionHomeIpad;


- (IBAction) actionSubmitIpad;

@end
