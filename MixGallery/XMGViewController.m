//
//  XMGViewController.m
//  MixGallery
//
//  Created by Camille  Kander on 01/03/2014.
//  Copyright (c) 2014 Camille Kander. All rights reserved.
//

#import "XMGViewController.h"
#import "XMG8tracksConnector.h"
#import "XMGMix.h"
#import "XMGMixCell.h"
#import "XMGMixDetailsViewController.h"

@interface XMGViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *secretScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;

@property (nonatomic, strong) NSArray *mixes;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic) NSUInteger currentPageNumber;

@end

@implementation XMGViewController

static CGFloat const kLineSpacing = 30.0;
static CGSize const kCellSize = {200.0, 200.0};
static NSString * const kShowMixDetailsSegueIdentifier = @"ShowMixDetails";

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.collectionView addGestureRecognizer:_secretScrollView.panGestureRecognizer];
    self.collectionView.panGestureRecognizer.enabled = NO;
    
    CGRect scrollViewFrame = self.secretScrollView.frame;
    scrollViewFrame.size.width = kCellSize.width + kLineSpacing;
    self.secretScrollView.frame = scrollViewFrame;
    
    [self loadData:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (void)setCurrentPageNumber:(NSUInteger)currentPageNumber {
    
    _currentPageNumber = currentPageNumber;
   
    if (currentPageNumber < [self.mixes count]) {
        XMGMix *mix = [self.mixes objectAtIndex:currentPageNumber];
        self.nameLabel.text = mix.name;
    } else {
        self.nameLabel.text = nil;
    }
}

- (IBAction)loadData:(id)sender {
    
    XMG8tracksConnector *connector = [XMG8tracksConnector sharedConnector];
    
    [connector grabSomeMixesWithCompletionBlock:^(NSArray *mixes) {
        
        if (mixes && [mixes count] > 0) {
            
            self.mixes = mixes;
            self.images = [[NSMutableDictionary alloc] initWithCapacity:[mixes count]];
            
            self.secretScrollView.contentSize = CGSizeMake(kCellSize.width * (double)mixes.count + kLineSpacing * (double)mixes.count, 20);
            
            [self.collectionView reloadData];
            self.currentPageNumber = 0;
            
            [mixes enumerateObjectsUsingBlock:^(XMGMix *mix, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@", mix.name);
                [[XMG8tracksConnector sharedConnector] grabImageForMix:mix withCompletionBlock:^(UIImage *image) {
                    [self.images setObject:image forKey:@(mix.identifier)];
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];
                }];
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.tryAgainButton.alpha = 0.0;
            }];
    
        } else {
            self.nameLabel.text = @"No data";
            [UIView animateWithDuration:0.5 animations:^{
                self.tryAgainButton.alpha = 1.0;
            }];
        }
    }];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.mixes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIndentifier = @"CellIdentifier";
    XMGMixCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (indexPath.item < [self.mixes count]) {
        XMGMix *mix = [self.mixes objectAtIndex:indexPath.item];
        [cell.imageView setImage:[self.images objectForKey:@(mix.identifier)]];
    }
    
    return cell;
    
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == self.currentPageNumber) {
        [self performSegueWithIdentifier:kShowMixDetailsSegueIdentifier sender:[self.mixes objectAtIndex:indexPath.item]];
    } else {
        [self.secretScrollView setContentOffset:CGPointMake((double)indexPath.item * (kCellSize.width + kLineSpacing), 0.0) animated:YES];
    }
}

#pragma mark - Collection view delegate flow layout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return kLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return kCellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGSize cellSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    CGFloat leftAndRight = (self.collectionView.frame.size.width - cellSize.width) / 2.0;
    
    return UIEdgeInsetsMake(0.0, leftAndRight, 0.0, leftAndRight);
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.secretScrollView) { //ignore collection view scrolling callbacks
        CGPoint contentOffset = scrollView.contentOffset;
        contentOffset.x = contentOffset.x - self.collectionView.contentInset.left;
        self.collectionView.contentOffset = contentOffset;

        NSUInteger pageNumber = 0.5 + contentOffset.x / (kCellSize.width + kLineSpacing);
        if (pageNumber != self.currentPageNumber) {
            self.currentPageNumber = pageNumber;
        }
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kShowMixDetailsSegueIdentifier]) {
        XMGMixDetailsViewController *dvc = segue.destinationViewController;
        dvc.mix = sender;
        dvc.image = [self.images objectForKey:@(dvc.mix.identifier)];
    }
}

- (IBAction)closeMixDetails:(UIStoryboardSegue *)segue {

}

#pragma mark - Appearance

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
