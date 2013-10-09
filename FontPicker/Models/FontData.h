//
//  Font.h
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FontData: NSManagedObject

/** Font Rating */
@property (nonatomic, strong) NSNumber *rating;

@end
