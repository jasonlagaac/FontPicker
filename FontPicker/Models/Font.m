//
//  Font.m
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "Font.h"

@interface Font ()

/** Font family names */
@property (nonatomic, strong) NSMutableArray *fontFamilyNames;

@end

@implementation Font

- (id)init
{
    self = [super init];
    
    if (self) {
        self.fontFamilyNames = [[UIFont familyNames] mutableCopy];
    }
    
    return self;
}


- (NSArray *)allFonts
{
    return self.fontFamilyNames;
}

- (NSArray *)allFontsSortedAlphanumerically
{
    return [self.fontFamilyNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

- (NSArray *)allFontsSortedByLength
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    return [self.fontFamilyNames sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}


@end
