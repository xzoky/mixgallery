//
//  XMGMixDetailsViewController.m
//  MixGallery
//
//  Created by Camille  Kander on 02/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import "XMGMixDetailsViewController.h"
#import "XMGMix.h"

@interface XMGMixDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation XMGMixDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateLabels];
}

- (void)setMix:(XMGMix *)mix {
    
    _mix = mix;
    [self updateLabels];
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    [self updateLabels];
}

- (void)updateLabels {
    
    self.imageView.image = self.image;
    self.navBar.topItem.title = self.mix.name;
    self.descriptionLabel.text = self.mix.descriptionString;
    self.playCountLabel.text = [NSString stringWithFormat:@"%C %i", (unichar)0xe23a, self.mix.playsCount];
    self.likesCountLabel.text = [NSString stringWithFormat:@"%C %i", (unichar)0xe022, self.mix.likesCount];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMMM d, YYYY";
    self.dateLabel.text = [dateFormatter stringFromDate:self.mix.firstPublishedAt];
}

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

@end
