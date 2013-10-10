//
//  FontData.h
//  FontPicker
//
//  Created by Jason Lagaac on 11/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FontData : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;

/** Flush all stored font information */
- (void)flushStoredFontData;

@end
