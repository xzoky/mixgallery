//
//  XMGMix.m
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import "XMGMix.h"

@implementation XMGMix

+ (instancetype)mixWithDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary) {
        return nil;
    }
    
    XMGMix *mix = [[self alloc] init];
    
    mix.identifier = [(NSNumber *)[dictionary objectForKey:@"id"] unsignedIntegerValue];
    mix.path = [dictionary objectForKey:@"path"];
    mix.webPath = [dictionary objectForKey:@"web_path"];
    mix.name = [dictionary objectForKey:@"name"];
    mix.userID = [(NSNumber *)[dictionary objectForKey:@"user_id"] unsignedIntegerValue];
    mix.published = [(NSNumber *)[dictionary objectForKey:@"published"] boolValue];
    mix.coverURLs = [dictionary objectForKey:@"cover_urls"];
    mix.descriptionString = [dictionary objectForKey:@"description"];
    mix.playsCount = [(NSNumber *)[dictionary objectForKey:@"plays_count"] unsignedIntegerValue];
    mix.tagListCache = [dictionary objectForKey:@"tag_list_cache"];
    mix.firstPublishedAt = [self dateFromString:[dictionary objectForKey:@"first_published_at"]];
    mix.likesCount = [(NSNumber *)[dictionary objectForKey:@"likes_count"] unsignedIntegerValue];
    mix.certification = [self certificationLevelFromString:[dictionary objectForKey:@"certification"]];
    
    return mix;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:
            @"id: %i,\npath: %@,\nwebPath: %@,\nname: %@,\nuserID: %i,\npublished:%i,\ncoverURLs: %@,\ndescriptionString: %@,\nplaysCount: %i,\ntagListCache: %@,\nfirstPublishedAt: %@,\nlikesCount: %i,\ncertification: %u", self.identifier, self.path, self.webPath, self.name, self.userID, self.published, self.coverURLs, self.descriptionString, self.playsCount, self.tagListCache, self.firstPublishedAt, self.likesCount, self.certification];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    
    return [[self dateFormatter] dateFromString:dateString];
}

+ (NSDateFormatter *)dateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return dateFormatter;
}

+ (XMGCertificationLevel)certificationLevelFromString:(NSString *)certificationString {
    
    if ([certificationString isEqualToString:@"gem"]) {
        return XMGCertificationLevelGem;
    } else if ([certificationString isEqualToString:@"gold"]) {
        return XMGCertificationLevelGold;
    } else if ([certificationString isEqualToString:@"platinum"]) {
        return XMGCertificationLevelPlatinum;
    } else if ([certificationString isEqualToString:@"diamond"]) {
        return XMGCertificationLevelDiamond;
    } else {
        return XMGCertificationLevelNone;
    }
}

@end
