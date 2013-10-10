//
//  Settings.h
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kSettingsViewLayout,
    kSettingsViewSorting,
    kSettingsViewReset
} SettingsViewSections;

typedef enum {
    kSettingsLayoutLeft,
    kSettingsLayoutRight,
    kSettingsLayoutBackwards
} LayoutSettings;

typedef enum {
    kSettingsSortingAlpha,
    kSettingsSortingCount,
    kSettingsSortingSize,
    kSettingsSortingReverse
} SortingSettings;

@interface Settings : NSObject

/** Sorting state */
@property (nonatomic) SortingSettings sortState;

/** Layout State */
@property (nonatomic) LayoutSettings layoutState;

/** Font reverse state */
@property (nonatomic) BOOL fontsReversed;

/** Main table sort state */
@property (nonatomic) BOOL fontSortReversed;

/** Save state */
- (void)saveState;

/** Reset the settings to default */
- (void)reset;


@end
