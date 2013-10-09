//
//  Font.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "Font.h"

@interface Font ()

/** Font family names */
@property (nonatomic, strong) NSMutableArray *fontFamilyNames;

@end

@implementation Font

@dynamic rating;

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

@end
