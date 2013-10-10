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

/** Font view modal area */
@property (nonatomic, strong) UIView *fontModal;

/** Font size slider */
@property (nonatomic, strong) UISlider *fontSizeSlider;

/** Star rating area */
@property (nonatomic, strong) EDStarRating  *starRating;

/** Retrieved font data */
@property (nonatomic, strong) FontData *fontData;

@end

@implementation FontViewController

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
    self.starRating = nil;
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
    
    self.fontModal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 380)];
    self.fontModal.center = fontViewCenter;
    self.fontModal.backgroundColor = [UIColor whiteColor];
    self.fontModal.layer.cornerRadius = 5;
    self.fontModal.layer.masksToBounds = YES;
    
    [self.view addSubview:self.fontModal];
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
    
    [self.fontModal addSubview:button];
}

- (void)loadFontNameTitle
{
    self.fontNameTitle = [[UILabel alloc] init];
    
    self.fontNameTitle.frame = CGRectMake(0, 0, 280.0f, 70.0f);
    self.fontNameTitle.text = @"Test Font";
    self.fontNameTitle.textColor = [UIColor concreteColor];
    self.fontNameTitle.font = [UIFont boldFlatFontOfSize:19];
    self.fontNameTitle.textAlignment = NSTextAlignmentCenter;
    
    [self.fontModal addSubview:self.fontNameTitle];
}


- (void)loadSampleAlphabet
{
    self.sampleAlphabet = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 250, 150)];
    self.sampleAlphabet.text = kFontSampleText;
    self.sampleAlphabet.textAlignment = NSTextAlignmentCenter;
    self.sampleAlphabet.backgroundColor = [UIColor clearColor];
    self.sampleAlphabet.textColor = [UIColor midnightBlueColor];
    self.sampleAlphabet.editable = NO;
    
    [self.fontModal addSubview:self.sampleAlphabet];
}

- (void)loadSlider
{
    self.fontSizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    self.fontSizeSlider.center = CGPointMake(145.0f, 70.0f);
    self.fontSizeSlider.value = 18.0f;
    self.fontSizeSlider.minimumValue = 10.0f;
    self.fontSizeSlider.maximumValue = 200;
    
    [self.fontSizeSlider configureFlatSliderWithTrackColor:[UIColor silverColor]
                                             progressColor:[UIColor wisteriaColor]
                                                thumbColor:[UIColor concreteColor]];
    
    [self.fontSizeSlider addTarget:self
                        action:@selector(changeFontSize)
              forControlEvents:UIControlEventValueChanged];
    
    [self.fontModal addSubview:self.fontSizeSlider];
}


- (void)loadStarRatings
{
    self.starRating = [[EDStarRating alloc] initWithFrame:CGRectMake(45, 240, 200, 60)];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.starRating.backgroundColor = [UIColor clearColor];
    self.starRating.starImage = [UIImage imageNamed:@"star.png"];
    self.starRating.starHighlightedImage = [UIImage imageNamed:@"starhighlighted.png"];
    self.starRating.maxRating = 5.0;
    self.starRating.delegate = self;
    self.starRating.horizontalMargin = 15.0;
    self.starRating.editable=YES;
    
    if (self.fontData) {
        self.starRating.rating = [self.fontData.rating floatValue];
    } else {
        self.starRating.rating = 0;
    }
    
    self.starRating.displayMode = EDStarRatingDisplayHalf;
    [self.starRating setNeedsDisplay];
    
    [self.fontModal addSubview:self.starRating];
}

- (void)loadFontData
{
    self.fontData = nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", self.fontNameTitle.text];
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Fetch the fonts from persistent data store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FontData"];
    NSArray *data = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSArray *filtered = [data filteredArrayUsingPredicate:predicate];
    
    if ([filtered count]) {
        self.fontData = (FontData *)[[data filteredArrayUsingPredicate:predicate] objectAtIndex:0];
    }
}


#pragma mark - Slider Actions
/////////////////////////////////////////////////////////////////////////////////

- (void)changeFontSize
{
    DebugLog(@"Changing Font Size");
    NSString *fontName = self.sampleAlphabet.font.fontName;
    [self.sampleAlphabet setFont:[UIFont fontWithName:fontName
                                                 size:self.fontSizeSlider.value]];
}

#pragma mark - Star Rating actions
/////////////////////////////////////////////////////////////////////////////////

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{

    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    // Create a new managed object
    if (self.fontData == nil) {
        self.fontData = [NSEntityDescription insertNewObjectForEntityForName:@"FontData"
                                                      inManagedObjectContext:context];
        [self.fontData setValue:[NSNumber numberWithFloat:rating] forKey:@"rating"];
        [self.fontData setValue:self.fontNameTitle.text forKey:@"name"];
    } else {
        [self.fontData setRating:[NSNumber numberWithFloat:rating]];
    }
    
    NSError *error = nil;
    
    // Save the object to persistent store
    if (![context save:&error]) {
        DebugLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
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
                         self.starRating.rating = 0;
                         [self.view removeFromSuperview];
                     }];
}



@end
