//
//  HTML2String.h
//  Landmann
//
//  Created by Wang on 23.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTML2StringScanner : NSObject {
    
    NSString* _HTMLString;
    
    NSScanner* _scanner;
}

@property (nonatomic, readonly) NSMutableString* outputString;


- (id) initWithHTMLString:(NSString*) string;

- (void) scan;

@end
