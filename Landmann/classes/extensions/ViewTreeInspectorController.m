//
//  ViewHierarchyViewer.m
//  PDFViewer
//
//  Created by Wang on 20.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewTreeInspectorController.h"
#import "SubviewIterator.h"
#import "UIView+Extensions.h"
#import "CGExtensions.h"
#import "ObjectDictionaryManager.h"


#define NODE_SIZE CGSizeMake(140, 50)
#define NODE_PADDING_HORIZONZAL 0
#define NODE_PADDING_VERTICAL 20
#define MARGIN 20

#define TREEVIEW_MAXWIDTH 16000



@implementation TreeInspectorInvoker 


+ (void) addInvokeForViewController:(UIViewController *)viewController onView:(UIView *)view {

//    UIWindow* window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    TreeInspectorInvoker* invoker = [[TreeInspectorInvoker alloc] initWithViewController:viewController onView:view];
    
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:invoker action:@selector(handleTapGesture:)] autorelease];
    recognizer.numberOfTapsRequired = 3;
    recognizer.numberOfTouchesRequired = 2;
    
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addGestureRecognizer:recognizer];
}


+ (void) addInvokerToWindow {

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    UIViewController* rootViewController = window.rootViewController;
    
    TreeInspectorInvoker* invoker = [[TreeInspectorInvoker alloc] initWithViewController:rootViewController onView:rootViewController.view];
    
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:invoker action:@selector(handleTapGesture:)] autorelease];
    recognizer.numberOfTapsRequired = 3;
    recognizer.numberOfTouchesRequired = 2;
    
    [window addGestureRecognizer:recognizer];
    
//    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizer];
}


- (id) initWithViewController:(UIViewController *)viewController onView:(UIView *)view {
    
    if ((self = [super init])) {

        _viewController = viewController;
        _view = view;
        _invoked = false;
    }
    
    return self;
}


- (void) handleTapGesture:(UIGestureRecognizer *)recognizer {
    
    NSLog(@"handleTapGesture");
    
    if (!_invoked) {

        ViewTreeInspectorController* controller = [[[ViewTreeInspectorController alloc] initWithRootView:_view] autorelease];
        
        [_viewController presentModalViewController:controller animated:TRUE];
        
        _invoked = TRUE;
    }
    else {
        
        [_viewController dismissModalViewControllerAnimated:TRUE];
        
        _invoked = FALSE;
    }
    
}

@end






@implementation ViewTreeInspectorController

@synthesize mainScrollView, detailScrollView, treeView, detailTextView, detailView, viewCountLabel;
@synthesize  selectedNode;
@synthesize collapseButton;



- (id) initWithRootView:(UIView *)rootView {
    
    if ((self = [super initWithNibName:@"ViewTreeInspectorController" bundle:[NSBundle mainBundle]])) {
        
        _rootView = rootView;
        _currentPosition = CGPointZero;
        _maxPosition = CGPointZero;
        _minPosition = CGPointMake(INT_MAX, INT_MAX);
        _isCollapseAll = false;
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];

    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
    recognizer.numberOfTapsRequired = 2;
    [self.detailView addGestureRecognizer:recognizer];
    
    [self createView];
    
}


- (void) createView {
    
    [self.treeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int found = 0;
    int numberOfViews = 0;
    CGPoint origin = CGPointZero;
    [self addView:_rootView ToHierarchy:self.treeView atDepth:0 subviewsFound:&found currentPosition:&origin numberOfViews:&numberOfViews];
    
    self.viewCountLabel.text = [NSString stringWithFormat:@"%d views", numberOfViews];
    
    NSLog(@"min position: %@", NSStringFromCGPoint(_minPosition));
    NSLog(@"max position: %@", NSStringFromCGPoint(_maxPosition));
    
    // re-shift subviews to origin
    SubviewIterator* iterator = [[SubviewIterator alloc] initWithView:self.treeView];
    UIView* subview = nil;
    while ((subview = [iterator nextView])) {
        subview.frame = CGRectMake(subview.frame.origin.x - _minPosition.x, subview.frame.origin.y - _minPosition.y, subview.frame.size.width, subview.frame.size.height);
    }
    
    CGSize finalSize = CGSizeMake(_maxPosition.x - _minPosition.x + NODE_SIZE.width, _maxPosition.y - _minPosition.y + NODE_SIZE.height);
    
//    int MAXWIDTH = 1000;
//    
//    if (finalSize.width > MAXWIDTH) {
//        finalSize.width = MAXWIDTH;
//    }
    
    
    
    NSLog(@"final size: %@", NSStringFromCGSize(finalSize));

    self.treeView.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
    self.mainScrollView.contentSize = self.treeView.bounds.size;
}


- (Node*) addView:(UIView *)view ToHierarchy:(TreeView *)treeView2 atDepth:(int)depth subviewsFound:(int *)found currentPosition:(CGPoint*)position numberOfViews:(int *)numberOfViews {

//    if (*numberOfViews > 10000) {
//        return nil;
//    }
    
    CGPoint positionOnEnter = CGPointMake(position->x, position->y);

    NSMutableArray* childNodes = [[[NSMutableArray alloc] init] autorelease];
    
    int newFound = 0;
    
    if ([view.subviews count] == 0) {
        
        position->x += NODE_SIZE.width + NODE_PADDING_HORIZONZAL;

        ++*found;
    }
    else {


        int subviewCount = 0;
        
        for (UIView* subview in view.subviews) {
            
            *found = 0;

            position->y += NODE_PADDING_VERTICAL + NODE_SIZE.height;

            Node* childNode = [self addView:subview ToHierarchy:treeView2 atDepth:depth + 1 subviewsFound:found currentPosition:position numberOfViews:numberOfViews];

            if (childNode != nil) {
                [childNodes addObject:childNode];
            }
            
            position->y -= NODE_PADDING_VERTICAL + NODE_SIZE.height;
            
            newFound += *found;
            
            ++subviewCount;
        }
        
        
        *found = newFound;

    }

    int diffX = position->x - (position->x - positionOnEnter.x) / 2;
    
    CGPoint labelPosition = CGPointMake(diffX, position->y);

    
    NSLog(@"depth: %d, view: %@, found: %d", depth, [view class], newFound);
    
    CGRect labelRect = CGRectMake(labelPosition.x, labelPosition.y, NODE_SIZE.width, NODE_SIZE.height);
    
    Node* node = [[[Node alloc] initWithView:view] autorelease];
    node.delegate = self;
    node.frame = labelRect;
//    node.position = labelRect.origin;
    
    if (labelRect.origin.x < TREEVIEW_MAXWIDTH) {
        [treeView2 addSubview:node];
    
//    [treeView2.nodeArray addObject:node];
    
        if (labelPosition.x > _maxPosition.x) {
            
            _maxPosition.x = labelPosition.x;
        }
        if (labelPosition.x < _minPosition.x) {
            
            _minPosition.x = labelPosition.x;
        }
        
        if (labelPosition.y > _maxPosition.y) {
            
            _maxPosition.y = labelPosition.y;
        }
        if (labelPosition.y < _minPosition.y) {
            
            _minPosition.y = labelPosition.y;
        }

    }
    
    for (Node* childNode in childNodes) {
        
        [childNode setParentNode:node];
        [node.childNodes addObject:childNode];
    }
    
    ++*numberOfViews;
    
    return node;
}


- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    if ([scrollView.subviews count] == 0) {
        return nil;
    }
    else 
        return [scrollView.subviews objectAtIndex:0];
}


- (void) nodeDidGetSelected:(Node *)node {
    
    NSLog(@"nodeDidGetSelected");
    
    if (self.selectedNode) {
        [self.selectedNode setNormal];
    }
    
    self.selectedNode = node;
    UIView* view = node.viewReference;
    
    UIImage* screenshot = [view captureImage];
    UIImageView* screenView = [[[UIImageView alloc] initWithImage:screenshot] autorelease];
    
    [self.detailScrollView addSubview:screenView];
    [self.detailView setHidden:FALSE];
    
    // set starting zoomscale
    CGSize scaledSize = CGSizeScaleToSize(screenView.frame.size, self.detailScrollView.frame.size, false);
    float ratioW = scaledSize.width / screenView.frame.size.width;
    float ratioH = scaledSize.height / screenView.frame.size.height;
    self.detailScrollView.zoomScale = MIN(ratioW, ratioH);
    
//    self.detailScrollView.zoomScale = 0.5;
    
    NSString* detailString = [NSString stringWithFormat:@"origin.x: %f\norigin.y: %f\nsize.width: %f\nsize.height: %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height];
    
    self.detailTextView.text = detailString;
}

- (void) nodeDidGetDeselected:(Node *)node {
    
    NSLog(@"nodeDidGetDeselected");
    
    self.selectedNode = nil;
    
    [self.detailView setHidden:TRUE];
    [self.detailScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return true;
}


//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    
//    [self createView];
//}


- (void) handleTapGesture:(UIGestureRecognizer *)recognizer {
    
    if (recognizer.view == self.detailView) {
        
        [self.selectedNode setNormal];
        self.selectedNode = nil;
        
        [self.detailView setHidden:TRUE];
        [self.detailScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}


- (IBAction) handleCollapse:(id)sender {
    
    _isCollapseAll = !_isCollapseAll;
    
    [self.treeView switchCollapseAll];
    
    if (_isCollapseAll) {
        
        [self.collapseButton setTitle:@"uncollapse all" forState:UIControlStateNormal];
    }
    else {
        
        [self.collapseButton setTitle:@"collapse all" forState:UIControlStateNormal];
    }
}


- (void) dealloc {
    
    NSLog(@"ViewTreeInspectorController DEALLOC");

    [self.treeView release];
    [self.mainScrollView release];
    [self.detailView release];
    [self.detailScrollView release];
    [self.detailTextView release];
    [self.viewCountLabel release];
    
    [super dealloc];
}

@end


#pragma mark - Node

@implementation Node

@synthesize parentNode, delegate, viewReference, position;
@synthesize selected = _selected;
@synthesize closed;
@synthesize childNodes;


- (id) initWithView:(UIView *)view {
    
    if ((self = [super init])) {
        
        self.viewReference = view;
        self.childNodes = [[NSMutableArray alloc] init];
        _selected = false;
        self.closed = false;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)] autorelease];
        [self addGestureRecognizer:recognizer];
        
        UILongPressGestureRecognizer* recognizer2 = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)] autorelease];
        [self addGestureRecognizer:recognizer2];
    }
    
    return self;
}


- (void) didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.superview) {
        
        
    }
}


- (void) handleTapGesture:(UIGestureRecognizer *)recognizer {
    
    if (_selected) {

        [self setNormal];
    }
    else {

        [self setSelected];
    }
}


- (void) handleLongPressGesture:(UIGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.closed) {
            
            [self setOpen];
        }
        else {
            [self setClosed];
        }
    }
}



- (void) setSelected {

    _selected = true;
    [delegate nodeDidGetSelected:self];
    [self setNeedsDisplay];
}


- (void) setNormal {
    
    _selected = false;
    [delegate nodeDidGetDeselected:self];
    [self setNeedsDisplay];
}

- (void) setOpen {
    
    if ([self.childNodes count] != 0) 
        self.closed = false;
    [self setNeedsDisplay];
    [(TreeView*)self.superview setNeedsDisplay];
}

- (void) setClosed {
    
    if ([self.childNodes count] != 0) 
        self.closed = true;
    [self setNeedsDisplay];
    [(TreeView*)self.superview setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect circleRect = CGRectMake((rect.size.width - 20) / 2, 0, 20, 20);

    CGContextSetLineWidth(context, 2.0);
    
    if (_selected) {

        CGContextSetRGBFillColor(context, 255.0/255, 255.0/255, 0/255, 1.0);
    }
    else if (self.closed) {

        CGContextSetRGBFillColor(context, 125.0/255, 0.0/255, 0.0/255, 1.0);
    }
    else {

        CGContextSetRGBFillColor(context, 255.0/255, 255.0/255, 255.0/255, 1.0);
    }

    CGContextFillEllipseInRect(context, circleRect);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    NSString* text = [NSString stringWithFormat:@"%@", self.viewReference.class];
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
    CGRect textRect = CGRectMake((rect.size.width - textSize.width) / 2, 20, textSize.width, 20);

    [text drawInRect:textRect withFont:[UIFont fontWithName:@"Helvetica" size:10.0]];

    
    NSString* objectName = getNameForObject(self.viewReference);
    
//    NSLog(@"object name for object: %@ = %@", self.viewReference, objectName);
    
    if (objectName) {
        
        text = [NSString stringWithFormat:@"(%@)", objectName];
        textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
        textRect = CGRectMake((rect.size.width - textSize.width) / 2, 30, textSize.width, 10);
        
        [text drawInRect:textRect withFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
    }
    
    
    if ([self.viewReference isKindOfClass:[UIScrollView class]]) {
        
        NSLog(@"SCROLLVIEW: %f", [self.viewReference zoomScale]);
        NSLog(@"SCROLLVIEW: %@", NSStringFromCGSize([self.viewReference contentSize]));
    }
}


- (void) dealloc {
    
    NSLog(@"Node dealloc");
    
    [super dealloc];
}

@end




#pragma mark - TreeView

@implementation TreeView

@synthesize nodeArray;


- (id) initWithCoder:(NSCoder *)aDecoder {
    
    NSLog(@"initWithCoder");
    
    if ((self = [super initWithCoder:aDecoder])) {
        
        self.nodeArray = [[NSMutableArray alloc] init];
        _isCollapseAll = false;
    }
    
    return self;
}


- (void) drawRect:(CGRect)rect {
    
    NSLog(@"TreeView drawRect (rect: %@)", NSStringFromCGRect(rect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetRGBFillColor(context, 125.0/255, 125.0/255, 125.0/255, 1.0);
//    CGContextFillRect(context, rect);
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    int count = 0;
    int visibleCount = 0;

    // first pass: decide which nodes are being drawn
    for (int i = [self.subviews count] - 1; i >= 0; --i) {
        
        UIView* subview = [self.subviews objectAtIndex:i];
        
        if ([subview isKindOfClass:[Node class]]) {
            
            Node* node = (Node*)subview;
            
            // draw Edges
            
            if (node.closed || node.hidden) {

                for (Node* child in node.childNodes) {
                    
                    child.hidden = true;
                }
            }
            else {
                
                ++visibleCount;
                
                for (Node* child in node.childNodes) {
                    
                    child.hidden = false;
                }
            }
        }    
    }
    
    // second pass : draw edges between visible nodes
    for (UIView* subview in self.subviews) {
        
        if ([subview isKindOfClass:[Node class]]) {

            Node* node = (Node*)subview;
            
            ++count;
            
            // draw Edges
            
            if (node.parentNode && node.parentNode.frame.origin.x < TREEVIEW_MAXWIDTH && !node.hidden) {
                
                CGPoint parentPosition = CGPointMake(node.parentNode.center.x, node.parentNode.center.y - 10);
                CGPoint position = CGPointMake(node.center.x, node.center.y - 10);
                
                CGPathMoveToPoint(linePath, NULL, parentPosition.x, parentPosition.y);
                CGPathAddLineToPoint(linePath, NULL, position.x, position.y);
                
            }
        
        
//        // draw Nodes
//        
//        CGRect circleRect = CGRectMake(node.position.x + (rect.size.width - 20) / 2, node.position.y, 20, 20);
//        
//        CGContextSetLineWidth(context, 2.0);
//        
//        switch (node.selected) {
//            case false:
//                CGContextSetRGBFillColor(context, 255.0/255, 255.0/255, 255.0/255, 1.0);
//                break;
//                
//            case true:
//                CGContextSetRGBFillColor(context, 255.0/255, 255.0/255, 0/255, 1.0);
//                break;
//                
//            default:
//                break;
//        }
//        CGContextFillEllipseInRect(context, circleRect);
//        
//        CGContextSetLineWidth(context, 1.0);
//        CGContextSetTextDrawingMode(context, kCGTextFill);
//        
//        NSString* text = [NSString stringWithFormat:@"%@", node.viewReference.class];
//        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
//        CGRect textRect = CGRectMake((rect.size.width - textSize.width) / 2, 20, textSize.width, 20);
//        
//        [text drawInRect:textRect withFont:[UIFont fontWithName:@"Helvetica" size:10.0]];

        }
    }
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor(context, 0.0/255, 0.0/255, 0.0/255, 1.0);

    CGContextAddPath(context, linePath);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(linePath);

//    NSLog(@"done drawing (%d).", count);
    
}


- (void) switchCollapseAll {
    
    NSLog(@"un/collapse all");
    
    _isCollapseAll = !_isCollapseAll;
    
    for (UIView* subview in self.subviews) {
        
        if ([subview isKindOfClass:[Node class]]) {
            
            Node* node = (Node*) subview;
            
            if (_isCollapseAll) {
                
                [node setClosed];
            }
            else if (!_isCollapseAll) {
                
                [node setOpen];
            }
        }
    }
    
    
    [self setNeedsDisplay];
}


- (void) dealloc {
    
    [self.nodeArray release];
    
    [super dealloc];
}

@end
