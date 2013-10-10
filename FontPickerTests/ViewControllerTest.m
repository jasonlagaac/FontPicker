#import "AppDelegate.h"

// Class under test
#import "ViewController.h"

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

@interface ViewControllerTest : SenTestCase
@end

@implementation ViewControllerTest
{
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[ViewController alloc] initWithNibName:@"ViewController_iPhone"
                                           bundle:nil];
    [sut view];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    sut = nil;
    [super tearDown];
}

- (void)testShouldHaveMainView
{
    assertThat([sut mainView], notNilValue());
}

- (void)testShouldHaveSettingsTable
{
    assertThat([sut settings], notNilValue());
}

- (void)testShouldHaveMainTable
{
    assertThat([sut mainTable], notNilValue());
}

- (void)testShouldHaveSearchBar
{
    assertThat([sut searchBar], notNilValue());
}


@end
