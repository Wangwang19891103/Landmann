//
//  ObjectDictionaryManager.m
//  PDFViewer
//
//  Created by Wang on 26.01.12.
//  Copyright (c) 2012 Wang. All rights reserved.
//

#import "ObjectDictionaryManager.h"

static ObjectDictionaryManager* _objectDictionaryInstance;


@implementation ObjectDictionaryManager

@synthesize nameDict, objectDict;


- (id) init {
    
    if ((self = [super init])) {
        
        self.nameDict = [[NSMutableDictionary alloc] init];
        self.objectDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


+ (void) initialize {
    
    if (!_objectDictionaryInstance) {
        
        _objectDictionaryInstance = [[ObjectDictionaryManager alloc] init];
    }
}

+ (id) objectForName:(NSString *)name {

    [self initialize];
    
    return [_objectDictionaryInstance.objectDict objectForKey:name];
}


+ (NSString*) nameForObject:(id)object {
    
    [self initialize];
    
    return [_objectDictionaryInstance.objectDict objectForKey:[NSValue valueWithPointer:(__bridge const void *)(object)]];
}


+ (void) setName:(NSString *)name forObject:(id)object {
    
    [self initialize];
    
    [_objectDictionaryInstance.nameDict setObject:object forKey:name];
    [_objectDictionaryInstance.objectDict setObject:name forKey:[NSValue valueWithPointer:(__bridge const void *)(object)]];
}

@end
