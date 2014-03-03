//
//  XMG8tracksConnector.h
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMGMix;

@interface XMG8tracksConnector : NSObject

+ (instancetype)sharedConnector;
- (void)grabSomeMixesWithCompletionBlock:(void (^)(NSArray *mixes))completionBlock;
- (void)grabImageForMix:(XMGMix *)mix withCompletionBlock:(void (^)(UIImage *image))completionBlock;
@end
