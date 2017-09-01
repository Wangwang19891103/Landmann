//
//  SettingsManager.h
//  Sprachenraetsel
//
//  Created by Wang on 19.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    GrillType1Undef,
    GrillType1Gas,
    GrillType1Kohle
} GrillType1;

typedef enum {
    GrillType2Undef,
    GrillType2Offen,
    GrillType2Geschlossen,
    GrillType2Schwenk,
    GrillType2Smoker
} GrillType2;

typedef enum {
    GrillLocationUndef,
    GrillLocationGarten,
    GrillLocationBalkon
} GrillLocation;

typedef enum {
    GrillProfileUndef,
    GrillProfileAmateur,
    GrillProfileAmbitioniert,
    GrillProfileProfi
} GrillProfile;

typedef enum {
    GrillPersonUndef,
    GrillPersonMann,
    GrillPersonFrau
} GrillPerson;

typedef enum {
    
    UserFontsizeSmall = 0,
    UserFontsizeMedium = 1,
    UserFontsizeLarge = 2
    
} UserFontsize;



@interface SettingsManager : NSObject {
    
    BOOL _showInstructions;
}

@property (nonatomic, assign) BOOL firstRun;

@property (nonatomic, assign) short grillType1;

@property (nonatomic, assign) short grillType2;

@property (nonatomic, assign) short grillLocation;

@property (nonatomic, assign) short grillProfile;

@property (nonatomic, assign) short grillPerson;

@property (nonatomic, assign) short userAgeCategory;

@property (nonatomic, assign) UserFontsize fontSize;


+ (SettingsManager*) sharedInstance;


@end
