//
//  SettingsToggleCell.m
//  FontPicker
//
//  Created by Jason Lagaac on 10/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "SettingsToggleCell.h"

@implementation SettingsToggleCell
@synthesize textLabel, toggleSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
    }
    return self;
}

- (void)layoutSubviews
{
    // Set the toggle switch colors
    toggleSwitch.onColor = [UIColor cloudsColor];
    toggleSwitch.offColor = [UIColor cloudsColor];
    toggleSwitch.onBackgroundColor = [UIColor wisteriaColor];
    toggleSwitch.offBackgroundColor = [UIColor silverColor];
    toggleSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    toggleSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    [toggleSwitch setOn:NO];
    
    self.textLabel.font = [UIFont boldFlatFontOfSize:14.0f];
    self.textLabel.textColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
