//
//  ViewController.h
//  FontPicker
//
//  Created by Jason Lagaac on 9/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <FlatUIKit/FlatUIKit.h>

@class FontViewController;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>
{
    /** Previously selected layout row path */
    NSIndexPath *_settingsLayoutPrevRow;
    
    /** Previously selected sorting row */
    NSIndexPath *_settingsSortPrevRow;
    
    /** Current text alignment state */
    NSTextAlignment _textAlignment;
    
    /** Font family names */
    NSMutableArray *_fontFamilyNames;
    
    /** Main view edit button */
    UIBarButtonItem *_editButton;
    
    /** Main view settings button */
    UIBarButtonItem *_settingsButton;
    
    /** Font reverse state */
    BOOL _fontsReversed;
    
    /** Main table sort state */
    BOOL _fontSortReversed;
    
    /** Loaded */
    BOOL _isLoaded;
    
    /** Current application state */
    NSMutableDictionary *_applicationState;
    
    /** Display fonts */
    FontViewController *_fontViewController;
}

/**
 Main view area
 */
@property (nonatomic, strong) IBOutlet UIView *mainViewArea;

/** 
 Settings table view 
 */
@property (nonatomic, strong) IBOutlet UITableView *settingsArea;

/** 
 Main table view 
 */
@property (nonatomic, strong) IBOutlet UITableView *mainTableArea;

/**
 Save the application state
 */
- (void)saveState;

@end
