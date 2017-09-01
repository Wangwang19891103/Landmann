//
//  HTML2String.m
//  Landmann
//
//  Created by Wang on 23.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "HTML2StringScanner.h"


#define TAG_BR      @"br/"


@implementation HTML2StringScanner

@synthesize outputString;


- (id) initWithHTMLString:(NSString *)string {
    
    if (self = [super init]) {
        
        _HTMLString = string;
        outputString = [NSMutableString string];
    }
    
    return self;
}

- (void) scan {
    
    _scanner = [NSScanner scannerWithString:_HTMLString];
    
    NSString* token = nil;
    
    while (!_scanner.isAtEnd) {
        
        // text between TAGS, cut off whitespace infront or after text
        
        token = [self scanStringUpToNextTag];
        
        [outputString appendString:token];
        
        token =  [self scanTag];

        if ([token.lowercaseString isEqualToString:TAG_BR.lowercaseString]) {
            
            [outputString appendString:@"\n"];
        }
        
        
//        token = [_scanner scanStringUpToWhitespace];
//        
//        if ([token isEqualToString:@"#"]) {   // comment
//            
//            // skip comment
//            [_scanner skipToNextLine];
//        }
//        else if ([token isEqualToString:@"mtllib"]) {   // mtllib
//            
//            // handle material
//            [_scanner skipToNextLine];
//        }
//        else if ([token isEqualToString:@"o"]) {   // object
//            
//            NSString* name = [self scanString];
//            [delegate scannerDidScanObjectName:name];
//        }
//        else if ([token isEqualToString:@"v"]) {   // vertex coords
//            
//            
//            //            struct GLOBJScannerVector3 coords;
//            float vector[3];
//            [self scanVector3:vector];
//            [delegate scannerDidScanVertexCoords:vector];
//        }
//        else if ([token isEqualToString:@"vn"]) {   // normal coords
//            
//            float vector[3];
//            [self scanVector3:vector];
//            [delegate scannerDidScanNormalCoords:vector];
//        }
//        else if ([token isEqualToString:@"vt"]) {   // texture coords
//            
//            float vector[3];
//            [self scanVector3:vector];
//            [delegate scannerDidScanTextureCoords:vector];
//        }
//        else if ([token isEqualToString:@"usemtl"]) {   // usemtl
//            
//            // handle material
//            [_scanner skipToNextLine];
//        }
//        else if ([token isEqualToString:@"s"]) {   // s
//            
//            // handle s
//            [_scanner skipToNextLine];
//        }
//        else if ([token isEqualToString:@"f"]) {   // face
//            
//            struct GLOBJScannerFace face;
//            [self scanFace:&face];
//            [delegate scannerDidScanFace:face];
//        }
    }

    [self removeExcessiveLineBreaks];
    
//    [delegate scannerDidFinishScanning];
}


- (NSString*) scanStringUpToNextTag {
    
    NSString* string = @"";
    [_scanner scanUpToString:@"<" intoString:&string];
    
    return [string copy];
}


- (NSString*) scanTag {
    
    NSString* string = @"";

    [_scanner scanString:@"<" intoString:NULL];
    [_scanner scanUpToString:@">" intoString:&string];
    [_scanner scanString:@">" intoString:NULL];

    return [string copy];
}


- (void) removeExcessiveLineBreaks {
    
    BOOL found = true;
    
    while (found) {
        
        found = false;
        
        NSRange range = [outputString rangeOfString:@"\n\n\n"];
        
        if (range.location != NSNotFound) {
            
            found = true;
            
            [outputString setString:[outputString stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n" options:NULL range:range]];
        }
    }
}

@end
