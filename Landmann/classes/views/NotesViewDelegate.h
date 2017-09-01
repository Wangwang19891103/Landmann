//
//  NotesViewDelegate.h
//  Landmann
//
//  Created by Wang on 26.02.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NotesView;


@protocol NotesViewDelegate <NSObject>

- (void) notesViewDidBeginEditing:(NotesView*) view;
- (void) notesViewDidEndEditing:(NotesView*) view;
- (void) notesView:(NotesView*) view willMoveToPosition:(CGPoint) point withDuration:(float) duration;

@end
