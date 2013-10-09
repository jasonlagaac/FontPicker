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

- (void)flushStoredFontData
{
    // Flush the stored rating information from core data
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Font"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for(NSManagedObject *font in data) {
        [context deleteObject:font];
    }
    
    if (![context save:&error]) {
    	DebugLog(@"Error deleting %@", error);
    }
}

@end
