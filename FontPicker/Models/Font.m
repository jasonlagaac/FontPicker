//
//  Font.m
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "Font.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FlatUIKit/FlatUIKit.h>


@interface Font ()

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

- (void)reset
{
    self.fontFamilyNames = [[UIFont familyNames] mutableCopy];
}

- (NSMutableArray *)sortAlphanumericallyInReverse:(BOOL)reverse
{
    self.fontFamilyNames = [[self.fontFamilyNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)] mutableCopy];
    
    if (reverse) {
        [self sortInReverse];
    }
    
    return self.fontFamilyNames;
}

- (NSMutableArray *)sortByLengthInReverse:(BOOL)reverse
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    self.fontFamilyNames = [[self.fontFamilyNames sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
   
    if (reverse) {
        [self sortInReverse];
    }
    
    return self.fontFamilyNames;
}

- (NSMutableArray *)sortByDisplaySizeInReverse:(BOOL)reverse
{
    NSArray *sortedArray = [_fontFamilyNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        UILabel *font1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        UILabel *font2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        
        [font1 setText:a];
        [font2 setText:b];
        
        CGSize textSize1 = [[font1 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        CGSize textSize2 = [[font2 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        
        NSNumber *size1 = [NSNumber numberWithFloat:textSize1.width];
        NSNumber *size2 = [NSNumber numberWithFloat:textSize2.width];;
        
        return [size1 compare:size2];
    }];
    
    self.fontFamilyNames = [sortedArray mutableCopy];
    
    if (reverse) {
        [self sortInReverse];
    }
    
    return self.fontFamilyNames;
}

- (NSMutableArray *)sortInReverse
{
    self.fontFamilyNames = [[[self.fontFamilyNames reverseObjectEnumerator] allObjects] mutableCopy];
    return self.fontFamilyNames;
}




@end
