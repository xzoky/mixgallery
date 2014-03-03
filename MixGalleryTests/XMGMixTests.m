//
//  XMGMixTests.m
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMGMix.h"

@interface XMGMixTests : XCTestCase

@property (nonatomic, strong) XMGMix *mix;

@end

@implementation XMGMixTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"mix" ofType:@"json"]];
    NSError *error = nil;
    
    self.mix = [XMGMix mixWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.mix = nil;
    
    [super tearDown];
}

- (void)testMixWithDictionary {
    
    XCTAssertNotNil(self.mix);

    XMGMix *mix = [[XMGMix alloc] init];
    
    mix.identifier = 2568872;
    mix.path = @"/mixes/2568872";
    mix.webPath = @"/asprytan/solstices";
    mix.name = @"solstices";
    mix.userID = 4137083;
    mix.published = YES;
    mix.coverURLs = @{};
    mix.descriptionString = @"we have lived past countless moons and long enough. (a folk mix)";
    mix.playsCount = 247;
    mix.tagListCache = @"folk, instrumental, autumn, melancholy";
    mix.likesCount = 33;
    mix.certification = XMGCertificationLevelGem;
    
    mix.firstPublishedAt = [[XMGMix dateFormatter] dateFromString:@"2013-10-09T17:30:55Z"];
    
    XCTAssertEqual(self.mix.identifier, mix.identifier);
    XCTAssertEqual(self.mix.userID, mix.userID);
    XCTAssertEqual(self.mix.published, mix.published);
    XCTAssertEqual(self.mix.playsCount, mix.playsCount);
    XCTAssertEqual(self.mix.likesCount, mix.likesCount);
    XCTAssertEqual(self.mix.certification, mix.certification);
    
    XCTAssertEqualObjects(self.mix.path, mix.path);
    XCTAssertEqualObjects(self.mix.webPath, mix.webPath);
    XCTAssertEqualObjects(self.mix.name, mix.name);
    XCTAssertEqualObjects(self.mix.coverURLs, mix.coverURLs);
    XCTAssertEqualObjects(self.mix.descriptionString, mix.descriptionString);
    XCTAssertEqualObjects(self.mix.tagListCache, mix.tagListCache);

    XCTAssertEqualObjects(self.mix.firstPublishedAt, mix.firstPublishedAt);
}

@end
