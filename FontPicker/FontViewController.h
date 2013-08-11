//
//  FontViewController.h
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>
#import <EDStarRating/EDStarRating.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "Font.h"

@interface FontViewController : UIViewController <EDStarRatingProtocol>
{
    UIView              *_fontViewArea;
    UISlider            *_fontSizeSlider;
    EDStarRating        *_starRating;
    Font                *_fontData;
    
    //FUISegmentedControl *_segmentedControl
}

@property (nonatomic, strong) UILabel *fontNameTitle;
@property (nonatomic, strong) UITextView *sampleAlphabet;


//- (void)setSampleAlphabetWithFont:(UIFont *)font;

@end
