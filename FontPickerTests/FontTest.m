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
    assertThat([sut fontFamilyNames], notNilValue());
}

- (void)testShouldReverseFontList
{
    NSArray *fontList = [UIFont familyNames];
    fontList = [[fontList reverseObjectEnumerator]  allObjects];
    
    assertThat([sut sortInReverse], equalTo(fontList));
}

#pragma mark - Sort Tests
////////////////////////////////////////////////////////////////////////////////

- (void)testShouldSortFontsAlphanumerically
{
    NSArray *sortedFonts = [[UIFont familyNames] copy];
    sortedFonts = [sortedFonts sortedArrayUsingSelector:@selector(localizedStandardCompare:)];

    assertThat([sut sortAlphanumericallyInReverse:NO], equalTo(sortedFonts));
}

- (void)testShouldSortFontsAlphanumericallyInReverse
{
    NSArray *sortedFonts = [[UIFont familyNames] copy];
    sortedFonts = [sortedFonts sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    sortedFonts = [[sortedFonts reverseObjectEnumerator] allObjects];
    
    assertThat([sut sortAlphanumericallyInReverse:YES], equalTo(sortedFonts));
}

- (void)testShouldSortFontsByLength
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    NSArray *sortedFonts = [[[UIFont familyNames] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] copy];
    
    assertThat([sut sortByLengthInReverse:NO], equalTo(sortedFonts));
}

- (void)testShouldSortFontsByLengthInbReverse
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:YES];
    NSArray *sortedFonts = [[[UIFont familyNames] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] copy];
    sortedFonts = [[sortedFonts reverseObjectEnumerator] allObjects];
    
    assertThat([sut sortByLengthInReverse:YES], equalTo(sortedFonts));
}

- (void)testShouldSortFontsByDisplaySize
{
    NSArray *sortedArray = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        UILabel *font1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        UILabel *font2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        
        [font1 setText:a];
        [font2 setText:b];
        
        CGSize textSize1 = [[font1 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        CGSize textSize2 = [[font2 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        
        NSNumber *size1 = [NSNumber numberWithFloat:textSize1.width];
        NSNumber *size2 = [NSNumber numberWithFloat:textSize2.width];;
        
        return [size1 compare:size2];
    }];
    
    assertThat([sut sortByDisplaySizeInReverse:NO], equalTo(sortedArray));
}

- (void)testShouldSortFontsByDisplaySizeInReverse
{
    NSArray *sortedArray = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        UILabel *font1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        UILabel *font2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        
        [font1 setText:a];
        [font2 setText:b];
        
        CGSize textSize1 = [[font1 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        CGSize textSize2 = [[font2 text] sizeWithFont:[UIFont flatFontOfSize:18.0f]];
        
        NSNumber *size1 = [NSNumber numberWithFloat:textSize1.width];
        NSNumber *size2 = [NSNumber numberWithFloat:textSize2.width];;
        
        return [size1 compare:size2];
    }];
    
    sortedArray = [[sortedArray reverseObjectEnumerator] allObjects];
    
    assertThat([sut sortByDisplaySizeInReverse:YES], equalTo(sortedArray));
}

#pragma mark - Search Tests
////////////////////////////////////////////////////////////////////////////////

- (void)testShouldSearchForFont
{
    NSMutableArray *filteredResults = [[NSMutableArray alloc] init];
    
    for (NSString* fontName in [UIFont familyNames]) {
        NSRange nameRange = [fontName rangeOfString:@"American" options:NSCaseInsensitiveSearch];
        if(nameRange.location != NSNotFound) {
            [filteredResults addObject:fontName];
        }
    }
    
    assertThat([sut searchForFont:@"American"], equalTo(filteredResults));
}


@end
