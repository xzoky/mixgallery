//
//  XMGMixDetailsViewController.h
//  MixGallery
//
//  Created by Camille  Kander on 02/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGMix;

@interface XMGMixDetailsViewController : UIViewController

@property (nonatomic, strong) XMGMix *mix;
@property (nonatomic, strong) UIImage *image;

@end
