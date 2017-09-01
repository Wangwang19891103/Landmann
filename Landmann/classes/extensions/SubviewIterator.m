//
//  SubviewIterator.m
//  Sprachenraetsel
//
//  Created by Wang on 12.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubviewIterator.h"


@implementation SubviewIterator

@synthesize currentLevel = _currentLevel, cycles = _cycles;


#pragma mark Initializers


// am besten für Print Ausgabe
- (id) initWithView:(UIView *)theView {
    
    if ((self = [self initWithView:theView strategy:SubviewIteratorStrategyDepth])) {
        
        
    }
    
    return self;
}

- (id) initWithView:(UIView *)theView strategy:(SubviewIteratorStrategy)theStrategy {
    
    if ((self = [self init])) {
        
        _topView = theView;
        _currentLevel = 0;
        _maxLevel = 1000;
        _strategy = theStrategy;
        _toBeVisited = [[NSMutableArray alloc] init];
        _toBeVisitedLevel = [[NSMutableArray alloc] init];
        _cycles = 0;
        
        [self addSubviewsFromView:_topView];
    }
    
    return self;
}

- (id) initWithView:(UIView *)theView maxLevel:(int)theMaxLevel {
    
    if ((self = [self initWithView:theView strategy:SubviewIteratorStrategyBreadth])) {
        
        _maxLevel = theMaxLevel;
    }
        
    return self;
}

- (id) initWithView:(UIView *)theView targetLevel:(int)theTargetLevel {
    
    if ((self = [self initWithView:theView strategy:SubviewIteratorStrategyBreadth])) {
        
        _maxLevel = theTargetLevel;
    }
    
    return self;
}


#pragma mark Methods

- (void) addSubviewsFromView:(UIView *)view {
    
    if (_maxLevel == _currentLevel) {
        return;
    }
    
    switch (_strategy) {
        case SubviewIteratorStrategyDepth:
            for (int i = [[view subviews] count] - 1; i >= 0; --i) {
                [_toBeVisited addObject:[[view subviews] objectAtIndex:i]];
                [_toBeVisitedLevel addObject:[NSNumber numberWithInt:_currentLevel + 1]];
            }
            break;
            
        default:
            for (UIView* subview in [view subviews]) {
                [_toBeVisited addObject:subview];
                [_toBeVisitedLevel addObject:[NSNumber numberWithInt:_currentLevel + 1]];
            }
            break;
    }
}

- (id) getObject {
    
    UIView* view;
    
    switch (_strategy) {
        case SubviewIteratorStrategyDepth:
            view = [_toBeVisited lastObject];
            _currentLevel = [[_toBeVisitedLevel lastObject] intValue];
            [_toBeVisited removeLastObject];
            [_toBeVisitedLevel removeLastObject]; 
            break;

        case SubviewIteratorStrategyBreadth:
            view = [_toBeVisited objectAtIndex:0];
            _currentLevel = [[_toBeVisitedLevel objectAtIndex:0] intValue];
            [_toBeVisited removeObjectAtIndex:0];
            [_toBeVisitedLevel removeObjectAtIndex:0];
            break;
            
        default:
            break;
    }
    
    return view;
}


- (UIView*) nextView {
    
    ++_cycles;
    
    if ([_toBeVisited count] != 0) {
        
        UIView* currentView = [self getObject];
        [self addSubviewsFromView:currentView];
        
        return currentView;
    }
    else {
        
        return nil;
    }
}


- (void) print {
    
    UIView* subview;
    
    NSLog(@"========== printing subview hierarchy for view (%@) ==========", [_topView class]);
    
    while ((subview = [self nextView])) {
        
        NSString* line = @"";
        
        for (int i = 0; i < _currentLevel - 1; ++i) {
            
            line = [line stringByAppendingString:@" "];
        }
        
        line = [line stringByAppendingFormat:@"%d: %@", _currentLevel, [subview class]];
        
        NSLog(@"%@", line);
    }
    
    NSLog(@"===============================================================");
}


#pragma mark Memory Management

- (void) dealloc {

    [_toBeVisited release];
    [_toBeVisitedLevel release];
    [super dealloc];
}

@end
