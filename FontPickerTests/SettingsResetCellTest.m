#import "AppDelegate.h"

// Class under test
#import "SettingsResetCell.h"

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

@interface SettingsResetCellTest : SenTestCase

@end

@implementation SettingsResetCellTest
{
    SettingsResetCell *sut;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    sut = [[SettingsResetCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:@"cell"];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testShouldHaveAResetButton
{
    assertThatBool([sut respondsToSelector:@selector(resetButton)], equalToBool(YES));
}

@end
