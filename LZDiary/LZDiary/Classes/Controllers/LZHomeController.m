//
//  LZHomeController.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZHomeController.h"
#import "LZDiaryLayout.h"
#import "LZHomeCell.h"
#import "NSString+ChineseNumber.h"
    CGFloat itemHeight = 150;
    CGFloat itemWidth = 60;
    CGFloat collectionViewWidth = 3 * 60;


@interface LZHomeController ()<UICollectionViewDelegateFlowLayout>

@end

@implementation LZHomeController

static NSString * const reuseIdentifier = @"LZHomeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)showFonts{
    
    NSArray * fams = [UIFont familyNames];
    
    for (NSString * fam in fams) {
        NSArray * fonts = [UIFont fontNamesForFamilyName:fam];
        NSLog(@"+++++++%@ ----", fam);
        for (NSString *fontName in fonts) {
            NSLog(@"\t\t\t%@", fontName);
        }
    }
    
}
- (void)setup {
    LZDiaryLayout *diaryLayout = [[LZDiaryLayout alloc] init];
    diaryLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView setCollectionViewLayout:diaryLayout animated:NO];
    
    self.collectionView.frame = CGRectMake(0, 0, collectionViewWidth, itemHeight);
    self.collectionView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.labelText = [@"2015" parseToChineseNumber];
    }else{
        
        cell.labelText = [@"2016" parseToChineseNumber];
    }
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat leftRightMargin = (collectionViewWidth - 2 * itemWidth) / 2 ;
    return UIEdgeInsetsMake(0, leftRightMargin, 0, leftRightMargin);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
