//
//  XMGMix.h
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XMGCertificationLevel) {
    XMGCertificationLevelNone = 0,
    XMGCertificationLevelGem,
    XMGCertificationLevelGold,
    XMGCertificationLevelPlatinum,
    XMGCertificationLevelDiamond
};

@interface XMGMix : NSObject

@property (nonatomic) NSUInteger identifier;
@property (nonatomic, strong) NSString *name;

@property (nonatomic) NSUInteger userID;
@property (nonatomic) NSUInteger playsCount;
@property (nonatomic) NSUInteger likesCount;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) enum XMGCertificationLevel certification;

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *webPath;
@property (nonatomic, strong) NSDictionary *coverURLs;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, getter=isPublished) BOOL published;
@property (nonatomic, strong) NSString *tagListCache;
@property (nonatomic, strong) NSDate *firstPublishedAt;

+ (instancetype)mixWithDictionary:(NSDictionary *)dictionary;
+ (NSDateFormatter *)dateFormatter;

@end
