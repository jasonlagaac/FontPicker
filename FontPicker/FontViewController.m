//
//  FontViewController.m
//  FontPicker
//
//  Created by Jason Lagaac on 11/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import "FontViewController.h"

@interface FontViewController ()

@end

@implementation FontViewController
@synthesize fontNameTitle;
@synthesize sampleAlphabet;

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
    [self loadFontNameTile];
    [self loadSampleAlphabet];
    [self loadSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFontViewArea
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGPoint fontViewCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2 - 10.0f);
    
    _fontViewArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 380)];
    _fontViewArea.center = fontViewCenter;
    _fontViewArea.backgroundColor = [UIColor whiteColor];
    _fontViewArea.layer.cornerRadius = 5;
    _fontViewArea.layer.masksToBounds = YES;
    
    [self.view addSubview:_fontViewArea];
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
    
    [_fontViewArea addSubview:button];
}

- (void)loadFontNameTile
{
    fontNameTitle = [[UILabel alloc] init];
    
    self.fontNameTitle.frame = CGRectMake(0, 0, 280.0f, 70.0f);
    self.fontNameTitle.text = @"Test Font";
    self.fontNameTitle.textColor = [UIColor concreteColor];
    self.fontNameTitle.font = [UIFont boldFlatFontOfSize:19];
    self.fontNameTitle.textAlignment = NSTextAlignmentCenter;
    
    [_fontViewArea addSubview:self.fontNameTitle];
}


- (void)loadSampleAlphabet
{
    sampleAlphabet = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 250, 150)];
    sampleAlphabet.text = @"ABCDEFGHIJKLMN\nOPQRSTUVWXYZ\n"
                           "abcdefghijklmno\npqrstuvwxyz\n\n"
                           "1234567890";
    sampleAlphabet.textAlignment = NSTextAlignmentCenter;
    sampleAlphabet.backgroundColor = [UIColor clearColor];
    sampleAlphabet.textColor = [UIColor midnightBlueColor];
    sampleAlphabet.editable = NO;
    
    [_fontViewArea addSubview:sampleAlphabet];
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
    
    [_fontViewArea addSubview:_fontSizeSlider];
}

- (void)changeFontSize
{
    NSLog(@"Changing Font Size");
    NSString *fontName = sampleAlphabet.font.fontName;
    [sampleAlphabet setFont:[UIFont fontWithName:fontName
                                            size:_fontSizeSlider.value]];
}

- (void)dismissFontView
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.view.alpha = 0.0f;
                     }];
}



@end
