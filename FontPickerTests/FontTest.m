#import "AppDelegate.h"

// Class under test
#import "Font.h"

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


@interface TCRouteTest : SenTestCase

@end

@interface FontTest : SenTestCase
@end

@implementation FontTest
{
    Font *sut;
}

- (void)setUp
{
    [super setUp];
    sut = [[Font alloc] init];

}

- (void)tearDown
{
    sut = nil;
    [super tearDown];
}


- (void)testShouldHaveArrayOfFonts
{
    assertThat([sut allFonts], notNilValue());
}

- (void)testShouldSortFontsAlphanumerically
{
    NSArray *sortedFonts = [[UIFont familyNames] copy];
    sortedFonts = [sortedFonts sortedArrayUsingSelector:@selector(localizedStandardCompare:)];

    assertThat([sut allFontsSortedAlphanumerically], equalTo(sortedFonts));
}

- (void)testShouldSortFontsByLength
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    NSArray *sortedFonts = [[[UIFont familyNames] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] copy];
    
    assertThat([sut allFontsSortedByLength], equalTo(sortedFonts));
}


@end
