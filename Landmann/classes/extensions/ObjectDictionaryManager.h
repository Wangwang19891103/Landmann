//
//  ObjectDictionaryManager.h
//  PDFViewer
//
//  Created by Wang on 26.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define setObjectName(object, name) [ObjectDictionaryManager setName:name forObject:object]

#define getNameForObject(object) [ObjectDictionaryManager nameForObject:object]

#define getObjectForName(name) [ObjectDictionaryManager objectForName:name]



@interface ObjectDictionaryManager : NSObject {
    
}

@property (nonatomic, retain) NSMutableDictionary* nameDict;
@property (nonatomic, retain) NSMutableDictionary* objectDict;

+ (void) initialize;

+ (id) objectForName:(NSString*) name;

+ (NSString*) nameForObject:(id) object;

+ (void) setName:(NSString*) name forObject:(id) object;

@end
