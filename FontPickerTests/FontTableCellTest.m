#import "AppDelegate.h"

// Class under test
#import "FontTableCell.h"

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

@interface FontTableCellTest : SenTestCase

@end

@implementation FontTableCellTest
{
    FontTableCell *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[FontTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:@"cell"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testShoulHaveATextLabel
{
    assertThatBool([sut respondsToSelector:@selector(textLabel)], equalToBool(YES));
}

@end
