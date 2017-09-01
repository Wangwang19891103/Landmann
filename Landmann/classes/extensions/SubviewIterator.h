//
//  SubviewIterator.h
//  Sprachenraetsel
//
//  Created by Wang on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {  SubviewIteratorStrategyDepth,
                SubviewIteratorStrategyBreadth

                } SubviewIteratorStrategy;


@interface SubviewIterator : NSObject {
    UIView* _topView;
    int _currentLevel;
    int _maxLevel;
    NSMutableArray* _toBeVisited;
    NSMutableArray* _toBeVisitedLevel;
    SubviewIteratorStrategy _strategy;
    int _cycles;
}

@property (nonatomic, readonly) int currentLevel;
@property (nonatomic, readonly) int cycles;

- (id) initWithView:(UIView*) theView;

- (id) initWithView:(UIView*) theView
           strategy:(SubviewIteratorStrategy) theStrategy;

- (id) initWithView:(UIView*) theView
           maxLevel:(int) theMaxLevel;

- (void) addSubviewsFromView:(UIView*) view;
- (id) getObject;
- (UIView*) nextView;
- (void) print;

@end
