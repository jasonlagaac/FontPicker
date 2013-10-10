//
//  FontData.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "FontData.h"


@implementation FontData

@dynamic name;
@dynamic rating;


#pragma mark - Font Reset Actions
////////////////////////////////////////////////////////////////////////////////

- (void)flushStoredFontData
{
    // Flush the stored rating information from core data
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FontData"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for(NSManagedObject *font in data) {
        [context deleteObject:font];
    }
    
    if (![context save:&error]) {
    	DebugLog(@"Error deleting %@", error);
    }
}


@end
