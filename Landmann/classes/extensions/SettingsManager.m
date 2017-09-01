//
//  SettingsManager.m
//  Sprachenraetsel
//
//  Created by Wang on 19.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsManager.h"



@implementation SettingsManager

@synthesize firstRun;
@synthesize grillType1;
@synthesize grillType2;
@synthesize grillLocation;
@synthesize grillPerson;
@synthesize grillProfile;
@synthesize userAgeCategory;
@synthesize fontSize;



#pragma mark Initializers

- (id) init {
    
    if ((self = [super init])) {
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* userDict = [userDefaults dictionaryForKey:@"UserSettings"];
        
        if (!userDict) {
            
            [userDefaults setObject:[NSDictionary dictionary] forKey:@"UserSettings"];
        }
        
        [self loadUserSettings];
    }
    
    return self;
}

#pragma mark Class methods

+ (SettingsManager*) sharedInstance {
    
    static SettingsManager* _instance;
    
    @synchronized(self) {
        
        if (!_instance) {
            _instance = [[SettingsManager alloc] init];
        }
    }
    
    return _instance;
}

#pragma mark Load and Save


- (void) saveSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:@"UserSettings"]];

    [userDict setObject:[NSNumber numberWithShort:firstRun] forKey:@"firstRun"];
    [userDict setObject:[NSNumber numberWithShort:grillType1] forKey:@"grillType1"];
    [userDict setObject:[NSNumber numberWithShort:grillType2] forKey:@"grillType2"];
    [userDict setObject:[NSNumber numberWithShort:grillLocation] forKey:@"grillLocation"];
    [userDict setObject:[NSNumber numberWithShort:grillProfile] forKey:@"grillProfile"];
    [userDict setObject:[NSNumber numberWithShort:grillPerson] forKey:@"grillPerson"];
    [userDict setObject:[NSNumber numberWithShort:userAgeCategory] forKey:@"userAgeCategory"];
    [userDict setObject:@(fontSize) forKey:@"userFontsize"];

    [userDefaults setObject:userDict forKey:@"UserSettings"];
    
    [userDefaults synchronize];
    
    [self print];
}

- (BOOL) isUserInitialized {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDict = [userDefaults dictionaryForKey:@"UserSettings"];
    
    if (userDict && [userDict objectForKey:@"grillType1"]) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void) initializeUser {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self defaultSettings] forKey:@"UserSettings"];
    [userDefaults synchronize];
}

- (NSDictionary*) defaultSettings {
    
    return @{
             @"firstRun": [NSNumber numberWithBool:true],
             @"grillType1": [NSNumber numberWithShort:GrillType1Undef],
             @"grillType2": [NSNumber numberWithShort:GrillType2Undef],
             @"grillLocation": [NSNumber numberWithShort:GrillLocationUndef],
             @"grillProfile": [NSNumber numberWithShort:GrillProfileUndef],
             @"grillPerson": [NSNumber numberWithShort:GrillPersonUndef],
             @"userAgeCategory": [NSNumber numberWithShort:7],
             @"userFontsize": @(UserFontsizeSmall)
             };
}

- (void) loadUserSettings {
    
    if (![self isUserInitialized]) {
        [self initializeUser];
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDict = [userDefaults dictionaryForKey:@"UserSettings"];
    
    firstRun = [[userDict objectForKey:@"firstRun"] boolValue];
    grillType1 = [[userDict objectForKey:@"grillType1"] shortValue];
    grillType2 = [[userDict objectForKey:@"grillType2"] shortValue];
    grillLocation = [[userDict objectForKey:@"grillLocation"] shortValue];
    grillProfile = [[userDict objectForKey:@"grillProfile"] shortValue];
    grillPerson = [[userDict objectForKey:@"grillPerson"] shortValue];
    userAgeCategory = [[userDict objectForKey:@"userAgeCategory"] shortValue];
    fontSize = [[userDict objectForKey:@"userFontsize"] integerValue];
    
    [self print];
}


- (void) print {
    
    NSLog(@"--------- USER SETTINGS ---------");
    NSLog(@"firstRun: %d", firstRun);
    NSLog(@"grillType1: %d", grillType1);
    NSLog(@"grillType2: %d", grillType2);
    NSLog(@"grillLocation: %d", grillLocation);
    NSLog(@"grillProfile: %d", grillProfile);
    NSLog(@"grillPerson: %d", grillPerson);
    NSLog(@"userAgeCategory: %d", userAgeCategory);
    NSLog(@"userFontsize: %d", fontSize);
}


#pragma mark Getter and Setter

- (void) setFirstRun:(BOOL)p_firstRun {
    
    firstRun = p_firstRun;
    
    [self saveSettings];
}


- (void) setGrillType1:(short)p_grillType1 {
    
    grillType1 = p_grillType1;
    
    [self saveSettings];
}


- (void) setGrillType2:(short)p_grillType2 {
    
    grillType2 = p_grillType2;
    
    [self saveSettings];
}


- (void) setGrillLocation:(short)p_grillLocation {
    
    grillLocation = p_grillLocation;

    [self saveSettings];
}


- (void) setGrillProfile:(short)p_grillProfile {
    
    grillProfile = p_grillProfile;
    
    [self saveSettings];
}


- (void) setGrillPerson:(short)p_grillPerson {
    
    grillPerson = p_grillPerson;
    
    [self saveSettings];
}


- (void) setUserAgeCategory:(short)p_userAgeCategory {
    
    userAgeCategory = p_userAgeCategory;
    
    [self saveSettings];
}


- (void) setFontSize:(UserFontsize)p_fontSize {
    
    fontSize = p_fontSize;
    
    [self saveSettings];
}




@end
