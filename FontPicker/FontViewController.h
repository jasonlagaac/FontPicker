//
//  FontViewController.h
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FontViewController : UIViewController
{
    UIView *_fontViewArea;
}

@property (nonatomic, strong) UILabel *fontNameTitle;
@property (nonatomic, strong) UITextView *sampleAlphabet;

- (void)setSampleAlphabetWithFont:(UIFont *)font;

@end
