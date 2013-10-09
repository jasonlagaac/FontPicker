//
//  Font.h
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Font : NSManagedObject

/** Font Rating */
@property (nonatomic, strong) NSNumber *rating;

/** Return a list of all fonts */
- (NSArray *)allFonts;

/** Return a list of all fonts sorted alphanumerically */
- (NSArray *)allFontsSortedAlphanumerically;


@end
