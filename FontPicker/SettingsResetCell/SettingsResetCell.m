//
//  SettingsResetCell.m
//  FontPicker
//
//  Created by Jason Lagaac on 10/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "SettingsResetCell.h"

@implementation SettingsResetCell

@synthesize resetButton;

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
    // Configure the reset button layout
    resetButton.buttonColor = [UIColor amethystColor];
    resetButton.shadowColor = [UIColor wisteriaColor];
    resetButton.shadowHeight = 3.0f;
    resetButton.cornerRadius = 6.0f;
    resetButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [resetButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
