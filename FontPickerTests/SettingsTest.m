#import "AppDelegate.h"

// Class under test
#import "Settings.h"

// Collaborators
#import <CoreLocation/CoreLocation.h>

// Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

@interface SettingsTest : SenTestCase

@end

@implementation SettingsTest
{
    Settings *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[Settings alloc] init];
}

- (void)tearDown
{
    sut = nil;
    [super tearDown];
}

- (void)testShouldHaveSortState
{
    assertThatBool([sut respondsToSelector:@selector(sortState)], equalToBool(YES));

}

- (void)testShouldHaveLayoutState
{
    assertThatBool([sut respondsToSelector:@selector(layoutState)], equalToBool(YES));
}

- (void)testShouldHaveFontsReversed
{
    assertThatBool([sut respondsToSelector:@selector(fontsReversed)], equalToBool(YES));
    
}

- (void)testShouldHaveFontSortReversed
{
    assertThatBool([sut respondsToSelector:@selector(fontSortReversed)], equalToBool(YES));
    
}

- (void)testShouldResetSortState
{
    [sut setSortState:kSettingsSortingCount];
    [sut reset];
    
    assertThatInt([sut sortState], equalToInt(kSettingsSortingAlpha));
}

- (void)testShouldResetLayoutState
{
    [sut setLayoutState:kSettingsLayoutRight];
    [sut reset];
    
    assertThatInt([sut layoutState], equalToInt(kSettingsLayoutLeft));
}

- (void)testShouldResetFontsReversed
{
    [sut setFontsReversed:YES];
    [sut reset];
    
    assertThatBool([sut fontsReversed], equalToBool(NO));
}

- (void)testShouldResetFontSortReversed
{
    [sut setFontSortReversed:YES];
    [sut reset];
    
    assertThatBool([sut fontSortReversed], equalToBool(NO));
}





@end
