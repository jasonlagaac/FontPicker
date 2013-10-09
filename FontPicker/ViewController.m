//
//  ViewController.m
//  FontPicker
//
//  Created by Jason Lagaac on 9/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "ViewController.h"
#import "FontTableCell.h"
#import "FontViewController.h"
#import "SettingsToggleCell.h"
#import "SettingsResetCell.h"
#import "AppDelegate.h"
#import "Font.h"
#import "Settings.h"


@interface ViewController ()

@property (nonatomic, strong) Font *fonts;

/** Previously selected layout row path */
@property (nonatomic, strong) NSIndexPath *settingsLayoutPrevRow;

/** Previously selected sorting row */
@property (nonatomic, strong) NSIndexPath *settingsSortPrevRow;

/** Current text alignment state */
@property (nonatomic) NSTextAlignment textAlignment;

/** Filtered font family names */
@property (nonatomic, strong) NSMutableArray *filteredResults;

/** Main view edit button */
@property (nonatomic, strong) UIBarButtonItem *editButton;

/** Main view settings button */
@property (nonatomic, strong) UIBarButtonItem *settingsButton;

/** Loaded */
@property (nonatomic) BOOL isLoaded;

/** Searching */
@property (nonatomic) BOOL isSearching;

/** Current application state */
@property (nonatomic, strong)  Settings *appSettings;

/** Display fonts */
@property (nonatomic, strong) FontViewController *fontViewController;

// Load Actions
- (void)loadNavigationBar;
- (void)loadmainView;

// Main View Actions
- (void)presentSettings;
- (void)toggleEdit;

// Layout Actions
- (void)alignTextLeft;
- (void)alignTextRight;
- (void)reverseFontNames:(id)sender;
- (NSString *)reverseString:(NSString *)originalString;

// Sorting Actions
- (void)sortFontNamesAlphanumerically;
- (void)sortFontNamesByLength;
- (void)sortFontNamesByDisplaySize;
- (void)sortFontNamesInReverse:(id)sender;

// Reset Actions
- (void)resetToDefault;
- (void)resetSortSettings;
- (void)flushStoredFontData;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.fontViewController = [[FontViewController alloc] initWithNibName:@"FontViewController"
                                                                   bundle:nil];
        self.fontViewController.view.alpha = 0.0f;
        self.fonts = [[Font alloc] init];
        self.appSettings = [Settings init];
        
        self.isLoaded = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadmainView];
    [self loadNavigationBar];
    [self loadSearchBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self loadSettingsState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Actions
/////////////////////////////////////////////////////////////////////////////////

- (void)loadmainView
{
    // Configure Main View border shadow
    self.mainView.layer.masksToBounds = NO;
    self.mainView.layer.cornerRadius = 8; // if you like rounded corners
    self.mainView.layer.shadowOffset = CGSizeMake(-5, 0);
    self.mainView.layer.shadowRadius = 5;
    self.mainView.layer.shadowOpacity = 0.5;
    self.mainView.layer.shouldRasterize = NO;
    self.mainView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.mainView.backgroundColor = [UIColor clearColor];
    
    // Prevent the UITableView from activating the delete action from a right swipe
    // and dismiss the settings view with a swipe gesture
    UISwipeGestureRecognizer *dismissSettingsSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(presentSettings)];
    dismissSettingsSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    dismissSettingsSwipe.numberOfTouchesRequired = 1;
    [self.mainTable addGestureRecognizer:dismissSettingsSwipe];
}

- (void)loadNavigationBar
{
    // Configure navigation bar items
    UINavigationItem *navigationItems = [[UINavigationItem alloc] initWithTitle:@"Font Picker"];
    
    // Navigation settings button
    self.settingsButton =  [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(presentSettings)];
    [self.settingsButton configureFlatButtonWithColor:[UIColor amethystColor]
                                     highlightedColor:[UIColor wisteriaColor]
                                         cornerRadius:3];
    
    [navigationItems setLeftBarButtonItem:_settingsButton];
    
    
    self.editButton =  [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(toggleEdit)];
    [self.editButton configureFlatButtonWithColor:[UIColor amethystColor]
                                 highlightedColor:[UIColor wisteriaColor]
                                     cornerRadius:3];
    
    [navigationItems setRightBarButtonItem:_editButton];
    
    // Add navigation bar to the top of the main view area
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    [navBar pushNavigationItem:navigationItems animated:NO];
    [navBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    [navBar setDelegate: self];
    [self.mainView addSubview:navBar];

}

- (void)loadSearchBar
{
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.backgroundColor = [UIColor asbestosColor];
    
    // Find the UITextField view in the searchBar
    // and set this view as its delegate.
    for (UIView *view in self.searchBar.subviews){
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }
}

#pragma mark - Data storage actions
////////////////////////////////////////////////////////////////////////////////

- (void)loadSettingsState
{
    NSIndexPath *path = nil;
    
    if (self.appSettings.layoutState != kSettingsLayoutNone) {
        
        switch (self.appSettings.layoutState) {
            case kSettingsLayoutLeft:
                [self alignTextLeft];
                break;
            case kSettingsLayoutRight:
                [self alignTextRight];
                break;
            default:
                break;
        }
        
        path = [NSIndexPath indexPathForItem:self.appSettings.layoutState
                                   inSection:kSettingsViewLayout];
        
        [self.settings selectRowAtIndexPath:path
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        
        [[self.settings cellForRowAtIndexPath:path] setBackgroundColor:[UIColor wisteriaColor]];
    }
    
    if (self.appSettings.sortState != kSettingsSortingNone) {
        switch (self.appSettings.sortState) {
            case kSettingsSortingAlpha:
                //[self alignTextLeft];
                break;
                
            case kSettingsSortingReverse:
                //[self alignTextRight];
                break;
                
            case kSettingsSortingCount:
                //[self alignTextRight];
                break;
                
            case kSettingsSortingSize:
                //[self alignTextRight];
                break;
                
            default:
                break;
        }
        
        path = [NSIndexPath indexPathForItem:self.appSettings.layoutState
                                   inSection:kSettingsViewSorting];
        [self.settings selectRowAtIndexPath:path
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
        [[self.settings cellForRowAtIndexPath:path] setBackgroundColor:[UIColor wisteriaColor]];
    }
    
    if (self.appSettings.fontsReversed) {
        path = [NSIndexPath indexPathForItem:kSettingsLayoutBackwards
                                   inSection:kSettingsViewLayout];
        SettingsToggleCell *cell = (SettingsToggleCell *)[self.settings cellForRowAtIndexPath:path];
        [[cell toggleSwitch] setOn:YES];
    }
    
    if (self.appSettings.fontSortReversed) {
        path = [NSIndexPath indexPathForItem:kSettingsSortingReverse
                                   inSection:kSettingsViewSorting];
        SettingsToggleCell *cell = (SettingsToggleCell *)[self.settings cellForRowAtIndexPath:path];
        [[cell toggleSwitch] setOn:YES];
    }
    
    self.isLoaded = YES;
    
    [self.settings reloadData];
    [self.mainTable reloadData];
}


#pragma mark - UITableView Data Source
////////////////////////////////////////////////////////////////////////////////

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.settings]) {

        NSString *sectionName;
        switch (section) {
            case kSettingsViewLayout:
                sectionName = NSLocalizedString(@"Layout", @"Layout");
                break;
            case kSettingsViewSorting:
                sectionName = NSLocalizedString(@"Sort", @"Sort");
                break;
                // ...
            default:
                sectionName = @"";
                break;
        }
        
        return sectionName;
    }
    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Initialise the custom table section headers
    if ([tableView isEqual:self.settings]) {
        if (section == kSettingsViewLayout || section == kSettingsViewSorting) {
            UIView *settingsSectionHeaders = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20.0f)];
            settingsSectionHeaders.backgroundColor = [UIColor midnightBlueColor];

            UILabel *sectionHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 12.0f, settingsSectionHeaders.frame.size.width, 18.0f)];
            sectionHeaderTitle.backgroundColor = [UIColor clearColor];
            sectionHeaderTitle.text = [self tableView:self.settings titleForHeaderInSection:section];
            sectionHeaderTitle.textAlignment = NSTextAlignmentLeft;
            sectionHeaderTitle.textColor = [UIColor cloudsColor];
            sectionHeaderTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
            [settingsSectionHeaders addSubview:sectionHeaderTitle];
            
            return settingsSectionHeaders;
        }
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if ([tableView isEqual:self.mainTable]) {
        // Set the main table view cells
        static NSString *CellIdentifier = @"FontCell";
        FontTableCell *cell = (FontTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FontTableCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (FontTableCell *)currentObject;
                    break;
                }
            }
        }
        
        [cell.textLabel setFont:[UIFont boldFlatFontOfSize:18.0f]];
        
        if (_isSearching) {
            cell.textLabel.text = [_filteredResults objectAtIndex:indexPath.row];
        } else {
            NSString *fontFamilyName = [self.fontFamilyNames objectAtIndex:indexPath.row];
            [cell.textLabel setTextAlignment:_textAlignment];
  
            if (self.appSettings.fontsReversed) {
                cell.textLabel.text = [self reverseString:fontFamilyName];
            } else {
                cell.textLabel.text = fontFamilyName;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
        
    } else {
        // Set the default settings cells
        static NSString *CellIdentifier = @"SettingsCell";
        
        if ((indexPath.section == kSettingsViewLayout && indexPath.row < kSettingsLayoutBackwards) ||
            (indexPath.section == kSettingsViewSorting && indexPath.row < kSettingsSortingReverse)) {

            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                if ((indexPath.section == kSettingsViewLayout && indexPath.row < kSettingsLayoutBackwards) ||
                    (indexPath.section == kSettingsViewSorting && indexPath.row < kSettingsSortingReverse)) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:CellIdentifier];
                }
            }
            
            NSString *action;
            if (indexPath.section == 0) {
                
                // Settings for cell layout options
                switch (indexPath.row) {
                    case kSettingsLayoutLeft:
                        action = @"Left";
                        break;
                    case kSettingsLayoutRight:
                        action = @"Right";
                        break;
                    default:
                        break;
                }
                
                cell.textLabel.text = action;
                [cell.textLabel setFont:[UIFont boldFlatFontOfSize:14.0f]];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else {
                
                // Settings for table row sorting options
                switch (indexPath.row) {
                    case kSettingsSortingAlpha:
                        action = @"Alpha Numerically";
                        break;
                    case kSettingsSortingCount:
                        action = @"Character Count";
                        break;
                    case kSettingsSortingSize:
                        action = @"Display Size";
                        break;
                    default:
                        break;
                }
                
                cell.textLabel.text = action;
                [cell.textLabel setFont:[UIFont boldFlatFontOfSize:14.0f]];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;

        } else if ((indexPath.section == kSettingsViewLayout && indexPath.row == kSettingsLayoutBackwards) ||
                   (indexPath.section == kSettingsViewSorting && indexPath.row == kSettingsSortingReverse)) {
           
            // Set the toggle cells in the settings table
            SettingsToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingsToggleCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (SettingsToggleCell *)currentObject;
                        break;
                    }
                }
                
            }
            
            if (indexPath.row == kSettingsLayoutBackwards) {
                
                // Backwards toggle option in the layout settings
                cell.textLabel.text = @"Backwards";
                [cell.toggleSwitch addTarget:self
                                      action:@selector(reverseFontNames:)
                            forControlEvents:UIControlEventValueChanged];
                
            } else if (indexPath.row == kSettingsSortingReverse) {
                
                // Reverse toggle option in the table sort settings
                cell.textLabel.text = @"Reverse";
                [cell.toggleSwitch addTarget:self
                                      action:@selector(sortFontNamesInReverse:)
                            forControlEvents:UIControlEventValueChanged];
                
            }
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
            
        } else {

            // Setting the reset button cell
            SettingsResetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingsResetCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (SettingsResetCell *)currentObject;
                        break;
                    }
                }
                
            }
            
            [cell.resetButton addTarget:self
                                 action:@selector(resetToDefault)
                       forControlEvents:UIControlEventTouchUpInside];
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
    }
}

#pragma mark - UITableView Delegates
////////////////////////////////////////////////////////////////////////////////

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.mainTable]) {
        return 70.0f;   // Main table cell heights
    }
    
    return 50.0f; // Settings table cell heights
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.mainTable]) {
        if (_isSearching) {
            return [_filteredResults count];
        } else {
            return [_fontFamilyNames count];
        }
    }
    
    if ([tableView isEqual:settings]) {
        if (section == kSettingsViewLayout) {
            return 3; // Total rows for the layout section
        } else if (section == kSettingsViewSorting) {
            return 4; // Total rows for the sorting section
        } else {
            return 1; // Total rows for the reset section
        }
    }
    
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.mainTable]) {
        return 1;
    } else {
        return 3;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.settings]) {
        if (section != kSettingsViewReset) {
            return 40.0f;
        }
    }
    
    return 0.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.mainTable]) {
        NSString *fontName;
        if (_isSearching) {
            fontName = [_filteredResults objectAtIndex:indexPath.row];
            [self.searchBar resignFirstResponder];
        } else {
            fontName = [_fontFamilyNames objectAtIndex:indexPath.row];
        }

        _fontViewController.view.alpha = 0.0f;
        _fontViewController.fontNameTitle.text = fontName;
        [_fontViewController.sampleAlphabet setFont:[UIFont fontWithName:fontName
                                                                   size:18.0f]];
        [self.view addSubview:_fontViewController.view];
        [UIView animateWithDuration:0.5
                         animations:^{
                             _fontViewController.view.alpha = 1.0f;
                         }];
    }
    
    
    if ([tableView isEqual:self.settings]) {
        if (indexPath.section == kSettingsViewLayout && indexPath.row != ([tableView numberOfRowsInSection:kSettingsViewLayout] - 1)) {
            [[tableView cellForRowAtIndexPath:_settingsLayoutPrevRow] setBackgroundColor:[UIColor clearColor]];
            [tableView deselectRowAtIndexPath:_settingsLayoutPrevRow animated:NO];
            
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor wisteriaColor]];
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];

            DebugLog(@"Layout section: %d, Row: %d", indexPath.section, indexPath.row);

            switch (indexPath.row) {
                case kSettingsLayoutLeft:
                    [self alignTextLeft];
                    DebugLog(@"Align Left");
                    break;
                    
                case kSettingsLayoutRight:
                    [self alignTextRight];
                    DebugLog(@"Align Right");
                    break;
                    
                default:
                    break;
            }
            
            _settingsLayoutPrevRow = indexPath;
            [self saveState];
            
        } else if (indexPath.section == kSettingsViewSorting && indexPath.row != ([tableView numberOfRowsInSection:kSettingsViewSorting] - 1)) {
            [[tableView cellForRowAtIndexPath:_settingsSortPrevRow] setBackgroundColor:[UIColor clearColor]];
            [tableView deselectRowAtIndexPath:_settingsSortPrevRow animated:NO];
            [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor wisteriaColor]];
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];
            
            DebugLog(@"Sorting section: %d, Row: %d", indexPath.section, indexPath.row);


            switch (indexPath.row) {
                case kSettingsSortingAlpha:
                    [self sortFontNamesAlphanumerically];
                    DebugLog(@"Sort Alphanumerically");
                    break;
                    
                case kSettingsSortingCount:
                    [self sortFontNamesByLength];
                    DebugLog(@"Sort by Length");
                    break;
                    
                case kSettingsSortingSize:
                    [self sortFontNamesByDisplaySize];
                    DebugLog(@"Sort by Display Size");
                    break;
        
                default:
                    break;
            }
            
            _settingsSortPrevRow = indexPath;
            [self saveState];
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_fontFamilyNames removeObjectAtIndex:indexPath.row];
        [self.mainTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self resetSortSettings];
    }
    
    [self saveState];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id thing = [_fontFamilyNames objectAtIndex:sourceIndexPath.row];
    [_fontFamilyNames removeObjectAtIndex:sourceIndexPath.row];
    [_fontFamilyNames insertObject:thing atIndex:destinationIndexPath.row];
    [self resetSortSettings];
    
    [self saveState];
}

#pragma mark - UISearchBar Delegates
////////////////////////////////////////////////////////////////////////////////

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0) {
        _isSearching = NO;
        [self.searchBar resignFirstResponder];
    } else {
        _isSearching = YES;
        _filteredResults = [[NSMutableArray alloc] init];
        
        for (NSString* fontName in _fontFamilyNames) {
            NSRange nameRange = [fontName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound) {
                [_filteredResults addObject:fontName];
            }
        }
    }
    
    DebugLog(@"Filtered Results: %@", _filteredResults);
    
    
    [mainTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


// Search bar text field delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBar afterDelay: 0.1];
    return YES;
}

#pragma mark - Interface Actions
////////////////////////////////////////////////////////////////////////////////

- (void)presentSettings
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    [searchBar resignFirstResponder];
        
    if (self.mainView.center.x != screenWidth) {
        // Show the settings & function area.
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGFloat newXPos = screenWidth;
                             CGFloat mainViewYPos = mainView.center.y;
                             self.mainView.center = CGPointMake(newXPos, mainViewYPos);
                             
                             CGFloat posTableYPos = self.mainTable.center.y;
                             self.mainTable.center = CGPointMake(newXPos, posTableYPos);
                         }];
    } else {
        // Hide the settings & function area.
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGFloat newXPos = [[UIScreen mainScreen] bounds].size.width / 2;
                             CGFloat mainViewYPos = mainView.center.y;
                             self.mainView.center = CGPointMake(newXPos, mainViewYPos);
                             
                             CGFloat posTableYPos = self.mainTable.center.y;
                             self.mainTable.center = CGPointMake(newXPos, posTableYPos);
                         }];
    }
}

- (void)toggleEdit
{
    BOOL editingState = self.mainTable.editing ? NO : YES;
    
    if (editingState) {
        _editButton.title = @"Done";
        [_editButton configureFlatButtonWithColor:[UIColor peterRiverColor]
                                 highlightedColor:[UIColor belizeHoleColor]
                                     cornerRadius:3];
    } else {
        _editButton.title = @"Edit";
        [_editButton configureFlatButtonWithColor:[UIColor amethystColor]
                                 highlightedColor:[UIColor wisteriaColor]
                                     cornerRadius:3];
    }
    
    [self.mainTable setEditing:editingState animated:YES];
}

#pragma mark - Layout Actions
/////////////////////////////////////////////////////////////////////////////////

- (void)alignTextLeft
{
    [self.mainTable reloadData];
    _textAlignment = NSTextAlignmentLeft;
    [self.mainTable reloadRowsAtIndexPaths:[mainTable indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)alignTextRight
{
    [self.mainTable reloadData];
    _textAlignment = NSTextAlignmentRight;
    [self.mainTable reloadRowsAtIndexPaths:[self.mainTable indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}

// Reverse font name string characters
- (NSString *)reverseString:(NSString *)originalString
{
    NSMutableString *reverseFontName = [[NSMutableString alloc] init];
    for (int j = [originalString length] - 1; j >= 0; j--) {
        unichar character = [originalString characterAtIndex:j];
        [reverseFontName appendString:[NSString stringWithCharacters:&character length:1]];
    }
    
    return reverseFontName;
}

// Toggle action for font name reversal
- (void)reverseFontNames:(id)sender
{
    if ([sender isOn]) {
        _fontsReversed = YES;
    } else {
        _fontsReversed = NO;
    }
    
    if (_isLoaded) {
        [self saveState];
    }
    
    [mainTable reloadData];
}

#pragma mark - Sorting Actions 
////////////////////////////////////////////////////////////////////////////////

/*
- (void)sortFontNamesAlphanumerically
{
    NSArray *newFontList = [_fontFamilyNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    if (_fontSortReversed) {
        _fontFamilyNames = (NSMutableArray *)[[newFontList reverseObjectEnumerator] allObjects];
    } else {
        _fontFamilyNames = [[NSMutableArray alloc] initWithArray:newFontList];
    }
    
    [mainTable reloadData];
} */

/*
- (void)sortFontNamesByLength
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    NSArray *newFontList = [_fontFamilyNames sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (_fontSortReversed) {
        _fontFamilyNames = (NSMutableArray *)[[newFontList reverseObjectEnumerator] allObjects];
    } else {
        _fontFamilyNames = [[NSMutableArray alloc] initWithArray:newFontList];
    }
    
    [mainTable reloadData];
}*/

- (void)sortFontNamesByDisplaySize
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

    
    if (_fontSortReversed) {
        _fontFamilyNames = (NSMutableArray *)[[sortedArray reverseObjectEnumerator] allObjects];
    } else {
        _fontFamilyNames = [sortedArray mutableCopy];
    }
    
    [mainTable reloadData];
}

- (void)sortFontNamesInReverse:(id)sender
{
    if (_isLoaded) {
        if ([sender isOn] && !_fontSortReversed) {
            _fontFamilyNames = (NSMutableArray *)[[_fontFamilyNames reverseObjectEnumerator] allObjects];
            _fontSortReversed = YES;
            
            [mainTable reloadData];
        } else {
            _fontFamilyNames = (NSMutableArray *)[[_fontFamilyNames reverseObjectEnumerator] allObjects];
            _fontSortReversed = NO;

            if ([[settings indexPathsForSelectedRows] count]) {
                for (NSIndexPath *selectedRow in [settings indexPathsForSelectedRows]) {
                    if (selectedRow.section == 1) {
                        switch (selectedRow.row) {
                            case 0:
                                [self sortFontNamesAlphanumerically];
                                break;
                                
                            case 1:
                                [self sortFontNamesByLength];
                                break;
                                
                            case 2:
                                [self sortFontNamesByDisplaySize];
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
            } else {
                [mainTable reloadData];
            }
        }
        
        [self saveState];
    }
}



#pragma mark - Reset Actions
////////////////////////////////////////////////////////////////////////////////

- (void)resetToDefault
{
    NSArray *selectedRowPaths = [settings indexPathsForVisibleRows];
    
    // Reset cells
    for (NSIndexPath *path in selectedRowPaths) {
        if ([[settings cellForRowAtIndexPath:path] isKindOfClass:[SettingsToggleCell class]]) {
            SettingsToggleCell *cell = (SettingsToggleCell *)[settings cellForRowAtIndexPath:path];
            [cell.toggleSwitch setOn:NO animated:YES];
        } else {
            [settings deselectRowAtIndexPath:path animated:NO];
            [[settings cellForRowAtIndexPath:path] setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    // Reset Options
    _settingsLayoutPrevRow = [NSIndexPath indexPathForRow:0 inSection:0];
    _settingsSortPrevRow = [NSIndexPath indexPathForRow:0 inSection:1];
    _textAlignment = NSTextAlignmentLeft;
    _fontFamilyNames = [[UIFont familyNames] mutableCopy];
    _applicationState = [NSMutableDictionary new];
    _fontsReversed = NO;
    _fontSortReversed = NO;
    
    [self flushStoredFontData];
    [self saveState];
    
    [mainTable reloadData];
}

- (void)resetSortSettings
{
    // Reset the reverse toggle
    NSIndexPath *reverseTogglePath = [NSIndexPath indexPathForItem:kSettingsSortingReverse inSection:kSettingsViewSorting];
    SettingsToggleCell *reverseArrayToggleCell = (SettingsToggleCell *) [settings cellForRowAtIndexPath:reverseTogglePath];
    if ([[reverseArrayToggleCell toggleSwitch] isOn]) {
        [[reverseArrayToggleCell toggleSwitch] setOn:NO animated:YES];
    }
    
    // Reset the sorting options
    for (NSIndexPath *path in [settings indexPathsForSelectedRows]) {
        if (path.section == kSettingsViewSorting) {
            if (![[settings cellForRowAtIndexPath:path] isKindOfClass:[SettingsToggleCell class]]) {
                [[settings cellForRowAtIndexPath:path] setBackgroundColor:[UIColor clearColor]];
                [settings deselectRowAtIndexPath:path animated:NO];
                [settings reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil]
                                    withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
    [self saveState];
}

- (void)flushStoredFontData
{
    // Flush the stored rating information from core data
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Font"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for(NSManagedObject *font in data) {
        [context deleteObject:font];
    }
    
    if (![context save:&error]) {
    	DebugLog(@"Error deleting %@", error);
    }
}


@end
