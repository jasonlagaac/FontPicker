//
//  Settings.m
//  FontPicker
//
//  Created by Jason Lagaac on 9/10/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

/** Application state */
@property (nonatomic, strong) NSMutableDictionary *applicationState;

@end

@implementation Settings

- (id)init
{
    self = [super init];
    
    if (self) {
        // Load the plist file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FontPicker.plist"];
        self.applicationState = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
        
        if (!_applicationState) {
            [self reset];
        } else {
            [self loadState];
        }
    }
    
    return self;
}

- (void)loadState
{
    for(id key in self.applicationState) {
        id value = [self.applicationState objectForKey:key];
        
        // Load the active sorting and layout cells
        if ([key isEqualToString:@"layout"] || [key isEqualToString:@"sorting"]) {
            NSInteger section = [[value objectForKey:@"section"] intValue];
            NSInteger row = [[value objectForKey:@"row"] intValue];
            
            if (section == kSettingsViewLayout) {
                self.layoutState = row;
            } else {
                self.sortState = row;
            }
            
        } else if ([key isEqualToString:@"backwards"] || [key isEqualToString:@"reverse"]) {
            // Set the active toggle cells
            if ([value boolValue]) {
                NSIndexPath *path;
                if ([key isEqualToString:@"backwards"]) {
                    path = [NSIndexPath indexPathForItem:kSettingsLayoutBackwards
                                               inSection:kSettingsViewLayout];
                    DebugLog(@"Backwards Loaded: %@", path);
                    self.fontsReversed = YES;
                } else {
                    path = [NSIndexPath indexPathForItem:kSettingsSortingReverse
                                               inSection:kSettingsViewSorting];
                    self.fontSortReversed = YES;
                }
            }
        }
    }
}

- (void)saveState
{
    NSDictionary *layoutState = @{ @"section" : [NSNumber numberWithInteger:kSettingsViewLayout],
                                   @"row" : [NSNumber numberWithInteger:self.layoutState] };
    [self.applicationState setObject:layoutState forKey:@"layout"];
    
    NSDictionary *sortingState = @{ @"section" : [NSNumber numberWithInteger:kSettingsViewSorting],
                                   @"row" : [NSNumber numberWithInteger:self.sortState] };
    [self.applicationState setObject:sortingState forKey:@"sorting"];
    [self.applicationState setObject:[NSNumber numberWithBool:self.fontsReversed] forKey:@"backwards"];
    [self.applicationState setObject:[NSNumber numberWithBool:self.fontSortReversed] forKey:@"reversed"];
    
    // Save to Plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FontPicker.plist"];
    DebugLog(@"Path %@", plistFile);
    DebugLog(@"Saving %d", [self.applicationState writeToFile:plistFile atomically:YES]);
    DebugLog(@"Saving %@", self.applicationState);

    
    //Error Check
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.applicationState
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    // check is plistData exists
    if(plistData) {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistFile atomically:YES];
    }
    else {
        DebugLog(@"Error in saveData: %@ %@", error, self.applicationState);
    }
}

- (void)reset
{
    self.fontSortReversed = NO;
    self.fontSortReversed = NO;
    self.layoutState = kSettingsLayoutLeft;
    self.sortState = kSettingsSortingAlpha;
    self.applicationState = [NSMutableDictionary new];
    
    NSDictionary *layoutState = @{ @"section" : [NSNumber numberWithInteger:kSettingsViewLayout],
                                   @"row" : [NSNumber numberWithInteger:kSettingsLayoutLeft] };
    [self.applicationState setObject:layoutState forKey:@"layout"];
    
    NSDictionary *sortingState = @{ @"section" : [NSNumber numberWithInteger:kSettingsViewSorting],
                                    @"row" : [NSNumber numberWithInteger:kSettingsSortingAlpha] };
    
    [self.applicationState setObject:sortingState forKey:@"sorting"];
    [self.applicationState setObject:[NSNumber numberWithBool:self.fontsReversed] forKey:@"backwards"];
    [self.applicationState setObject:[NSNumber numberWithBool:self.fontSortReversed] forKey:@"reversed"];
    
    [self saveState];
}

@end
