//
//  Font.h
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Font : NSObject

/** Return a list of all fonts */
- (NSArray *)allFonts;

/** Return a list of all fonts sorted alphanumerically */
- (NSArray *)allFontsSortedAlphanumerically;

/** Return a list of all fonts sorted by length */
- (NSArray *)allFontsSortedByLength;


@end
