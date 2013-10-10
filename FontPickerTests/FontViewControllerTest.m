#import "AppDelegate.h"

// Class under test
#import "FontViewController.h"

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

@interface FontViewControllerTest : SenTestCase

@end

@implementation FontViewControllerTest
{
    FontViewController *sut;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    sut = [[FontViewController alloc] initWithNibName:@"FontViewController"
                                               bundle:nil];
    [sut view];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    sut = nil;
    [super tearDown];
}

- (void)testShouldHaveFontTitle
{
    assertThat([sut fontNameTitle], notNilValue());
}

- (void)testShouldHaveSampleAlphabet
{
    assertThat([sut sampleAlphabet], notNilValue());
}


@end
