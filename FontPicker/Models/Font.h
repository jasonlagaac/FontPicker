//
//  Font.h
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Font : NSObject

@property (nonatomic, strong) NSMutableArray *fontFamilyNames;

/** Return a list of all fonts sorted alphanumerically */
- (NSArray *)sortAlphanumericallyInReverse:(BOOL)reverse;

/** Return a list of all fonts sorted by length */
- (NSArray *)sortByLengthInReverse:(BOOL)reverse;

/** Sort by display size */
- (NSMutableArray *)sortByDisplaySizeInReverse:(BOOL)reverse;

/** Sort fonts in reverse */
- (NSMutableArray *)sortInReverse;

/** Reset fonts */
- (void)reset;

@end
