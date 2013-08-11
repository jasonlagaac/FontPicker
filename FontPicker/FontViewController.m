//
//  FontViewController.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "FontViewController.h"
#import "AppDelegate.h"

#define kFontSampleText @"ABCDEFGHIJKLMN\nOPQRSTUVWXYZ\nabcdefghijklmno\npqrstuvwxyz\n\n1234567890"

typedef enum {
    kFontAttributeRegular,
    kFontAttributeBold,
    kFontAttributeUnderline,
    kFontAttributeStrike
} FontAttributeStates;


@interface FontViewController ()

// Load actions
- (void)loadFontViewArea;
- (void)loadCloseButton;
- (void)loadFontNameTitle;
- (void)loadSampleAlphabet;
- (void)loadSlider;
- (void)loadStarRatings;
- (void)loadFontData;

// Slider Actions
- (void)changeFontSize;

// Star Rating Actions
- (void)starsSelectionChanged:(EDStarRating *)control
                       rating:(float)rating;

// Dismiss View Actions
- (void)dismissFontView;

@end

@implementation FontViewController
@synthesize fontNameTitle, sampleAlphabet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadFontViewArea];
    [self loadCloseButton];
    [self loadFontNameTitle];
    [self loadSampleAlphabet];
    [self loadSlider];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFontData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadStarRatings];
}

- (void)viewDidDisappear:(BOOL)animated {
    _starRating = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Actions
////////////////////////////////////////////////////////////////////////////////

- (void)loadFontViewArea
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGPoint fontViewCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2 - 10.0f);
    
    _fontModal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 380)];
    _fontModal.center = fontViewCenter;
    _fontModal.backgroundColor = [UIColor whiteColor];
    _fontModal.layer.cornerRadius = 5;
    _fontModal.layer.masksToBounds = YES;
    
    [self.view addSubview:_fontModal];
}

- (void)loadCloseButton
{
    FUIButton *button = [[FUIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    button.center = CGPointMake(145.0f, 340.0f);
    button.cornerRadius = 3;
    button.buttonColor = [UIColor wisteriaColor];
    button.shadowColor = [UIColor amethystColor];
    button.shadowHeight = 3;
    [button setTitle:@"CLOSE" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldFlatFontOfSize:20.0f];
    
    [button addTarget:self
               action:@selector(dismissFontView)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_fontModal addSubview:button];
}

- (void)loadFontNameTitle
{
    fontNameTitle = [[UILabel alloc] init];
    
    self.fontNameTitle.frame = CGRectMake(0, 0, 280.0f, 70.0f);
    self.fontNameTitle.text = @"Test Font";
    self.fontNameTitle.textColor = [UIColor concreteColor];
    self.fontNameTitle.font = [UIFont boldFlatFontOfSize:19];
    self.fontNameTitle.textAlignment = NSTextAlignmentCenter;
    
    [_fontModal addSubview:self.fontNameTitle];
}


- (void)loadSampleAlphabet
{
    sampleAlphabet = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 250, 150)];
    sampleAlphabet.text = kFontSampleText;
    sampleAlphabet.textAlignment = NSTextAlignmentCenter;
    sampleAlphabet.backgroundColor = [UIColor clearColor];
    sampleAlphabet.textColor = [UIColor midnightBlueColor];
    sampleAlphabet.editable = NO;
    
    [_fontModal addSubview:sampleAlphabet];
}

- (void)loadSlider
{
    _fontSizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    _fontSizeSlider.center = CGPointMake(145.0f, 70.0f);
    _fontSizeSlider.value = 18.0f;
    _fontSizeSlider.minimumValue = 10.0f;
    _fontSizeSlider.maximumValue = 200;
    
    [_fontSizeSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                         progressColor:[UIColor wisteriaColor]
                                            thumbColor:[UIColor concreteColor]];
    
    [_fontSizeSlider addTarget:self
                        action:@selector(changeFontSize)
              forControlEvents:UIControlEventValueChanged];
    
    [_fontModal addSubview:_fontSizeSlider];
}


- (void)loadStarRatings
{
    _starRating = [[EDStarRating alloc] initWithFrame:CGRectMake(45, 240, 200, 60)];
    
	// Do any additional setup after loading the view, typically from a nib.
    _starRating.backgroundColor = [UIColor clearColor];
    _starRating.starImage = [UIImage imageNamed:@"star.png"];
    _starRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 15.0;
    _starRating.editable=YES;
    
    if (_fontData) {
        _starRating.rating = [_fontData.rating floatValue];
    } else {
        _starRating.rating = 0;
    }
    
    _starRating.displayMode = EDStarRatingDisplayHalf;
    [_starRating setNeedsDisplay];
    
    [_fontModal addSubview:_starRating];
}

- (void)loadFontData
{
    _fontData = nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", fontNameTitle.text];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Font"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSArray *filtered = [data filteredArrayUsingPredicate:predicate];
    
    if ([filtered count]) {
        _fontData = (Font *)[[data filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    }
}

/*
- (void)loadSegmentedControl
{
    NSArray *textOptions = [NSArray arrayWithObjects:@"Regular", @"Bold", @"Underline", @"Strike", nil];
    _segmentedControl = [[FUISegmentedControl alloc] initWithItems:textOptions];
    _segmentedControl.frame = CGRectMake(0, 0, 260, 30);
    _segmentedControl.center = CGPointMake(145.0f, 290.0f);
    
    _segmentedControl.selectedFont = [UIFont boldFlatFontOfSize:10];
    _segmentedControl.selectedFontColor = [UIColor cloudsColor];
    _segmentedControl.deselectedFont = [UIFont boldFlatFontOfSize:10];
    _segmentedControl.deselectedFontColor = [UIColor cloudsColor];
    _segmentedControl.selectedColor = [UIColor amethystColor];
    _segmentedControl.deselectedColor = [UIColor midnightBlueColor];
    _segmentedControl.dividerColor = [UIColor silverColor];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self
                         action:@selector(changeFontAttributes)
               forControlEvents:UIControlEventValueChanged];
    
    [_fontModal addSubview:_segmentedControl];
}

#pragma mark - Segmented Control Actions
/////////////////////////////////////////////////////////////////////////////////

- (void)changeFontAttributes
{
    if (_segmentedControl.selectedSegmentIndex == kFontAttributeRegular) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:kFontSampleText];
        [string addAttribute:NSFontA value:<#(id)#> range:<#(NSRange)#>]
    }
}*/

#pragma mark - Slider Actions
/////////////////////////////////////////////////////////////////////////////////

- (void)changeFontSize
{
    NSLog(@"Changing Font Size");
    NSString *fontName = sampleAlphabet.font.fontName;
    [sampleAlphabet setFont:[UIFont fontWithName:fontName
                                            size:_fontSizeSlider.value]];
}

#pragma mark - Star Rating actions
/////////////////////////////////////////////////////////////////////////////////

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{

    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Create a new managed object
    Font *font = [NSEntityDescription insertNewObjectForEntityForName:@"Font" inManagedObjectContext:context];
    [font setValue:[NSNumber numberWithFloat:rating] forKey:@"rating"];
    [font setValue:fontNameTitle.text forKey:@"name"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

#pragma mark - Dismiss view actions
/////////////////////////////////////////////////////////////////////////////////

- (void)dismissFontView
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.view.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         _starRating.rating = 0;
                         [self.view removeFromSuperview];
                     }];
}



@end
