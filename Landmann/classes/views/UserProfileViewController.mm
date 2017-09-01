//
//  UserProfileViewController.m
//  Landmann
//
//  Created by Wang on 20.04.13.
//  Copyright (c) 2013 Wang. All rights reserved.
//

#import "UserProfileViewController.h"
#import "SettingsManager.h"


#define MARGIN_TOP      95
#define PADDINGS        {-3, 1, 15, 15, 18, 15, 18, 12, 0}
#define LEFT_MARGINS    {15, 15, 19, 19, 19, 19, 19, 19, 0}

#define TAG_GRILLTYPE_GAS           1001
#define TAG_GRILLTYPE_HOLZKOHLE     1002
#define TAG_GRILLTYPE2_OFFEN        1003
#define TAG_GRILLTYPE2_GESCHLOSSEN  1004
#define TAG_GRILLTYPE2_SCHWENKGRILL 1005
#define TAG_GRILLTYPE2_SMOKER       1006
#define TAG_GRILLLOC_GARTEN         1007
#define TAG_GRILLLOC_BALKON         1008
#define TAG_GRILLPROF_AMATEUR       1009
#define TAG_GRILLPROF_AMBITIONIERT  1010
#define TAG_GRILLPROF_PROFI         1011
#define TAG_GRILLPERSON_MANN        1012
#define TAG_GRILLPERSON_FRAU        1013


@implementation UserProfileViewController


@synthesize scrollview;
@synthesize contentview;
@synthesize subviews;
@synthesize knob;


- (id) init {
    
    if (self = [super initWithNibName:@"UserProfileViewController" bundle:[NSBundle mainBundle]]) {
        
        _paddings = new float[9] PADDINGS;
        
        _leftMargins = new float[9] LEFT_MARGINS;
        
        [self.navigationItem setTitle:@"Einstellungen"];
    }
    
    return self;
}


- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    
    // IDIOM
    
    if (!is_ipad) {
    
        float posY = MARGIN_TOP;
        
        for (uint i = 0; i < subviews.count; ++i) {
            
            UIView* subview = [subviews objectAtIndex:i];
            
            [contentview addSubview:subview];
            [subview setFrameY:posY];
            [subview setFrameX:_leftMargins[i]];
            
            posY += subview.bounds.size.height + _paddings[i];
        }
        
        //    [contentview setFrameHeight:posY];
        [scrollview setContentSize:contentview.bounds.size];
    }
    
    [self loadSettings];
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // IDIOM
    
    if (is_ipad) {
        [self.navigationController setNavigationBarHidden:false animated:false];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // IDIOM
    
    if (is_ipad) {
        [self.navigationController setNavigationBarHidden:true animated:false];
    }
}



#pragma mark Actions

- (IBAction) actionSelectGrillType:(UIButton *)sender {
    
    // reset both
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE_GAS] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE_HOLZKOHLE] setSelected:false];
    
    // select sender
    [sender setSelected:true];
    
    if (is_ipad) return;  // do not save settings immediately but use submit button instead
    
    // handle action
    switch (sender.tag) {

        case TAG_GRILLTYPE_GAS:
            NSLog(@"Gas");
            [SettingsManager sharedInstance].grillType1 = GrillType1Gas;
            break;
            
        case TAG_GRILLTYPE_HOLZKOHLE:
            NSLog(@"Holzkohle");
            [SettingsManager sharedInstance].grillType1 = GrillType1Kohle;
            break;
            
        default:
            break;
    }
}


- (IBAction) actionSelectGrillType2:(UIButton *)sender {
    
    // reset both
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_OFFEN] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_GESCHLOSSEN] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_SCHWENKGRILL] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_SMOKER] setSelected:false];
    
    // select sender
    [sender setSelected:true];
    
    if (is_ipad) return;  // do not save settings immediately but use submit button instead

    // handle action
    switch (sender.tag) {
            
        case TAG_GRILLTYPE2_OFFEN:
            NSLog(@"Offen");
            [SettingsManager sharedInstance].grillType2 = GrillType2Offen;
            break;
            
        case TAG_GRILLTYPE2_GESCHLOSSEN:
            NSLog(@"Geschlossen");
            [SettingsManager sharedInstance].grillType2 = GrillType2Geschlossen;
            break;

        case TAG_GRILLTYPE2_SCHWENKGRILL:
            NSLog(@"Schwenkgrill");
            [SettingsManager sharedInstance].grillType2 = GrillType2Schwenk;
            break;

        case TAG_GRILLTYPE2_SMOKER:
            NSLog(@"Smoker");
            [SettingsManager sharedInstance].grillType2 = GrillType2Smoker;
            break;

        default:
            break;
    }
}


- (IBAction) actionSelectGrillLocation:(UIButton *)sender {
    
    // reset both
    [(UIButton*)[self.view viewWithTag:TAG_GRILLLOC_GARTEN] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLLOC_BALKON] setSelected:false];
    
    // select sender
    [sender setSelected:true];
    
    if (is_ipad) return;  // do not save settings immediately but use submit button instead

    // handle action
    switch (sender.tag) {
            
        case TAG_GRILLLOC_GARTEN:
            NSLog(@"Garten");
            [SettingsManager sharedInstance].grillLocation = GrillLocationGarten;
            break;
            
        case TAG_GRILLLOC_BALKON:
            NSLog(@"Balkon");
            [SettingsManager sharedInstance].grillLocation = GrillLocationBalkon;
            break;
            
        default:
            break;
    }
}


- (IBAction) actionSelectGrillProfile:(UIButton *)sender {
    
    // reset both
    [(UIButton*)[self.view viewWithTag:TAG_GRILLPROF_AMATEUR] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLPROF_AMBITIONIERT] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLPROF_PROFI] setSelected:false];
    
    // select sender
    [sender setSelected:true];
    
    if (is_ipad) return;  // do not save settings immediately but use submit button instead

    // handle action
    switch (sender.tag) {
            
        case TAG_GRILLPROF_AMATEUR:
            NSLog(@"Amateur");
            [SettingsManager sharedInstance].grillProfile = GrillProfileAmateur;
            break;
            
        case TAG_GRILLPROF_AMBITIONIERT:
            NSLog(@"Ambitioniert");
            [SettingsManager sharedInstance].grillProfile = GrillProfileAmbitioniert;
            break;

        case TAG_GRILLPROF_PROFI:
            NSLog(@"Profi");
            [SettingsManager sharedInstance].grillProfile = GrillProfileProfi;
            break;
            
        default:
            break;
    }
}


- (IBAction) actionSelectGrillPerson:(UIButton *)sender {

    // reset both
    [(UIButton*)[self.view viewWithTag:TAG_GRILLPERSON_MANN] setSelected:false];
    [(UIButton*)[self.view viewWithTag:TAG_GRILLPERSON_FRAU] setSelected:false];
    
    // select sender
    [sender setSelected:true];
    
    if (is_ipad) return;  // do not save settings immediately but use submit button instead

    // handle action
    switch (sender.tag) {
            
        case TAG_GRILLPERSON_MANN:
            NSLog(@"Mann");
            [SettingsManager sharedInstance].grillPerson = GrillPersonMann;
            break;
            
        case TAG_GRILLPERSON_FRAU:
            NSLog(@"Frau");
            [SettingsManager sharedInstance].grillPerson = GrillPersonFrau;
            break;
            
        default:
            break;
    }
}


#pragma mark Private Methods

- (void) loadSettings {

    uint tag = INT_MAX;

    // grillType1
    
    switch ([SettingsManager sharedInstance].grillType1) {

        case GrillType1Gas:
            tag = TAG_GRILLTYPE_GAS;
            break;
            
        case GrillType1Kohle:
            tag = TAG_GRILLTYPE_HOLZKOHLE;
            break;
            
        default:
            break;
    }
    
    [(UIButton*)[self.view viewWithTag:tag] setSelected:true];


    // grillType2
    
    switch ([SettingsManager sharedInstance].grillType2) {
            
        case GrillType2Offen:
            tag = TAG_GRILLTYPE2_OFFEN;
            break;
            
        case GrillType2Geschlossen:
            tag = TAG_GRILLTYPE2_GESCHLOSSEN;
            break;

        case GrillType2Schwenk:
            tag = TAG_GRILLTYPE2_SCHWENKGRILL;
            break;
            
        case GrillType2Smoker:
            tag = TAG_GRILLTYPE2_SMOKER;
            break;
            
        default:
            break;
    }
    
    [(UIButton*)[self.view viewWithTag:tag] setSelected:true];

    
    // grillLocation
    
    switch ([SettingsManager sharedInstance].grillLocation) {
            
        case GrillLocationGarten:
            tag = TAG_GRILLLOC_GARTEN;
            break;
            
        case GrillLocationBalkon:
            tag = TAG_GRILLLOC_BALKON;
            break;
            
        default:
            break;
    }
    
    [(UIButton*)[self.view viewWithTag:tag] setSelected:true];

    
    // grillProfile
    
    switch ([SettingsManager sharedInstance].grillProfile) {
            
        case GrillProfileAmateur:
            tag = TAG_GRILLPROF_AMATEUR;
            break;
            
        case GrillProfileAmbitioniert:
            tag = TAG_GRILLPROF_AMBITIONIERT;
            break;
            
        case GrillProfileProfi:
            tag = TAG_GRILLPROF_PROFI;
            break;
            
        default:
            break;
    }
    
    [(UIButton*)[self.view viewWithTag:tag] setSelected:true];

    
    // grillPerson
    
    switch ([SettingsManager sharedInstance].grillPerson) {
            
        case GrillPersonMann:
            tag = TAG_GRILLPERSON_MANN;
            break;
            
        case GrillPersonFrau:
            tag = TAG_GRILLPERSON_FRAU;
            break;

        default:
            break;
    }
    
    [(UIButton*)[self.view viewWithTag:tag] setSelected:true];

    
    // userAgeCategory
    
    [knob setAge:[SettingsManager sharedInstance].userAgeCategory];
}


- (IBAction) actionHomeIpad {
    
    [self.navigationController popToRootViewControllerAnimated:false];
}


- (IBAction) actionSubmitIpad {
    
    [self saveSettingsIpad];
    
    [[AlertManager instance] okAlertWithTitle:@"Danke!" message:@"Ihre Einstellungen wurden gespeichert."];
}


- (void) saveSettingsIpad {
    
    
    /*
#define TAG_GRILLTYPE_GAS           1001
#define TAG_GRILLTYPE_HOLZKOHLE     1002
#define TAG_GRILLTYPE2_OFFEN        1003
#define TAG_GRILLTYPE2_GESCHLOSSEN  1004
#define TAG_GRILLTYPE2_SCHWENKGRILL 1005
#define TAG_GRILLTYPE2_SMOKER       1006
#define TAG_GRILLLOC_GARTEN         1007
#define TAG_GRILLLOC_BALKON         1008
#define TAG_GRILLPROF_AMATEUR       1009
#define TAG_GRILLPROF_AMBITIONIERT  1010
#define TAG_GRILLPROF_PROFI         1011
#define TAG_GRILLPERSON_MANN        1012
#define TAG_GRILLPERSON_FRAU        1013
*/

    // grill type

    if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE_GAS]).selected) {
        
        [SettingsManager sharedInstance].grillType1 = GrillType1Gas;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE_HOLZKOHLE]).selected) {
        
        [SettingsManager sharedInstance].grillType1 = GrillType1Kohle;
    }

    
    // grill type 2
    
    if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_OFFEN]).selected) {
        
        [SettingsManager sharedInstance].grillType2 = GrillType2Offen;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_GESCHLOSSEN]).selected) {
        
        [SettingsManager sharedInstance].grillType2 = GrillType2Geschlossen;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_SCHWENKGRILL]).selected) {
        
        [SettingsManager sharedInstance].grillType2 = GrillType2Schwenk;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLTYPE2_SMOKER]).selected) {
        
        [SettingsManager sharedInstance].grillType2 = GrillType2Smoker;
    }
    
    
    // grill location
    
    if (((UIButton*)[self.view viewWithTag:TAG_GRILLLOC_GARTEN]).selected) {
        
        [SettingsManager sharedInstance].grillLocation = GrillLocationGarten;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLLOC_BALKON]).selected) {
        
        [SettingsManager sharedInstance].grillLocation = GrillLocationBalkon;
    }
    
    
    // grill profile
    
    if (((UIButton*)[self.view viewWithTag:TAG_GRILLPROF_AMATEUR]).selected) {
        
        [SettingsManager sharedInstance].grillProfile = GrillProfileAmateur;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLPROF_AMBITIONIERT]).selected) {
        
        [SettingsManager sharedInstance].grillProfile = GrillProfileAmbitioniert;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLPROF_PROFI]).selected) {
        
        [SettingsManager sharedInstance].grillProfile = GrillProfileProfi;
    }

    
    // grill person
    
    if (((UIButton*)[self.view viewWithTag:TAG_GRILLPERSON_MANN]).selected) {
        
        [SettingsManager sharedInstance].grillPerson = GrillPersonMann;
    }
    else if (((UIButton*)[self.view viewWithTag:TAG_GRILLPERSON_FRAU]).selected) {
        
        [SettingsManager sharedInstance].grillPerson = GrillPersonFrau;
    }

    
    // alter
    
    [SettingsManager sharedInstance].userAgeCategory = knob.value;


}



#pragma mark Delegate Methods

- (void) rotaryKnob:(RotaryKnob *)knob didChangeToValue:(uint)value {
    
    NSLog(@"value: %d", value);
    
    if (!is_ipad)
        [SettingsManager sharedInstance].userAgeCategory = value;
}

@end
