//
//  Font.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "FontData.h"



@implementation FontData

@dynamic rating;


- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context

{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self != nil) {
        // Perform additional initialization.
    }
    
    return self;
    
}

@end
