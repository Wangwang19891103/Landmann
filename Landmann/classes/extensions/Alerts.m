//
//  Alerts.m
//  KlettAbiLernboxen
//
//  Created by Wang on 16.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Alerts.h"


void alert(NSString* text, ...) {

    return;
    
    va_list args;
    va_start(args, text);

    NSString* message = [[NSString alloc] initWithFormat:text arguments:args];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:FALSE];
}


void alerterror(NSError* error) {
    
    alert(error.localizedDescription);
}
