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

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UISearchBarDelegate, UITextFieldDelegate>

/**
 Main view area
 */
@property (nonatomic, strong) IBOutlet UIView *mainView;

/** 
 Settings table view 
 */
@property (nonatomic, strong) IBOutlet UITableView *settings;

/** 
 Main table view 
 */
@property (nonatomic, strong) IBOutlet UITableView *mainTable;


/**
 Search Bar
 */
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@end
