#import "AppDelegate.h"

// Class under test
#import "SettingsToggleCell.h"

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
@interface SettingToggleCellTest : SenTestCase

@end

@implementation SettingToggleCellTest
{
    SettingsToggleCell *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[SettingsToggleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"cell"];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testShouldHaveTextLabel
{
    assertThatBool([sut respondsToSelector:@selector(textLabel)], equalToBool(YES));
}

- (void)testShouldHaveToggleSwitch
{
    assertThatBool([sut respondsToSelector:@selector(toggleSwitch)], equalToBool(YES));
}


@end
