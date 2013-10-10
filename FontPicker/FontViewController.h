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
#import "FontData.h"

@interface FontViewController : UIViewController <EDStarRatingProtocol>

/** Font name modal title */
@property (nonatomic, strong) UILabel *fontNameTitle;

/** Text view to show the sample alphabet */
@property (nonatomic, strong) UITextView *sampleAlphabet;

@end
