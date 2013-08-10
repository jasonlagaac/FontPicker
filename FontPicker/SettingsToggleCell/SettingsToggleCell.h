//
//  SettingsToggleCell.h
//  FontPicker
//
//  Created by Jason Lagaac on 10/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>

@interface SettingsToggleCell : UITableViewCell

/**
 Setting toggle text label
 */
@property (nonatomic, strong) IBOutlet UILabel *textLabel;

/**
 Setting toggle switch
 */
@property (nonatomic, strong) IBOutlet FUISwitch *toggleSwitch;

@end
