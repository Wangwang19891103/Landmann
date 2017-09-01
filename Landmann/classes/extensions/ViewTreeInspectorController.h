//
//  ViewHierarchyViewer.h
//  PDFViewer
//
//  Created by Wang on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Node;
@class TreeView;


@protocol NodeDelegate

@property (nonatomic, assign) Node* selectedNode;

- (void) nodeDidGetSelected:(Node*) node;
- (void) nodeDidGetDeselected:(Node*) node;

@end



@interface TreeInspectorInvoker : NSObject {

    UIViewController* _viewController;
    UIView* _view;
    BOOL _invoked;
}

+ (void) addInvokeForViewController:(UIViewController*) viewController onView:(UIView*) view;

+ (void) addInvokerToWindow;

- (id) initWithViewController:(UIViewController*) viewController onView:(UIView*) view;

- (void) handleTapGesture:(UIGestureRecognizer*) recognizer;

@end



@interface ViewTreeInspectorController : UIViewController <UIScrollViewDelegate, NodeDelegate> {
    
    UIView* _rootView;
    CGPoint _currentPosition;
    CGPoint _minPosition;
    CGPoint _maxPosition;
    
    BOOL _isCollapseAll;
}

@property (nonatomic, retain) IBOutlet UIScrollView* mainScrollView;
@property (nonatomic, retain) IBOutlet UIView* detailView;
@property (nonatomic, retain) IBOutlet TreeView* treeView;
@property (nonatomic, retain) IBOutlet UITextView* detailTextView;
@property (nonatomic, retain) IBOutlet UIScrollView* detailScrollView;
@property (nonatomic, retain) IBOutlet UILabel* viewCountLabel;
@property (nonatomic, retain) IBOutlet UIButton* collapseButton;


- (id) initWithRootView:(UIView*) rootView;

- (void) createView;

- (Node*) addView:(UIView*) view ToHierarchy:(TreeView*) hierarchyView atDepth:(int) depth subviewsFound:(int*) found currentPosition:(CGPoint*) position numberOfViews:(int*) numberOfViews;

- (void) handleTapGesture:(UIGestureRecognizer*) recognizer;

- (IBAction) handleCollapse:(id)sender;

@end






@interface Node : UIView {

    BOOL _selected;
//    BOOL _closed;
}

@property (nonatomic, assign) UIView* viewReference;
@property (nonatomic, retain) Node* parentNode;
@property (nonatomic, assign) id<NodeDelegate> delegate;
@property (nonatomic, readonly) BOOL selected;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) BOOL closed;
@property (nonatomic, retain) NSMutableArray* childNodes;

- (id) initWithView:(UIView*) view;

- (void) handleTapGesture:(UIGestureRecognizer*) recognizer;
- (void) handleLongPressGesture:(UIGestureRecognizer*) recognizer;

- (void) setSelected;
- (void) setNormal;
- (void) setOpen;
- (void) setClosed;

@end



@interface TreeView : UIView {

    BOOL _isCollapseAll;
}

@property (nonatomic, retain) NSMutableArray* nodeArray;

- (void) switchCollapseAll;

@end
