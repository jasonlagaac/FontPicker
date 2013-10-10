//
//  FontData.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "FontData.h"
#import "AppDelegate.h"

@implementation FontData

@dynamic name;
@dynamic rating;

/** Load font data */
+ (FontData *)loadFontData:(NSString *)fontName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", fontName];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FontData"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSArray *filtered = [data filteredArrayUsingPredicate:predicate];
    
    if ([filtered count]) {
        return (FontData *)[[data filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    }
    
    return nil;
}


@end
