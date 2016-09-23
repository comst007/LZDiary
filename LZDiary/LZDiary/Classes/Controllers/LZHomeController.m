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
#import "LZYearController.h"
#import "LZDiaryAnimator.h"
#import "LZItemStorage.h"
#import "NSNumber+chineseNumber.h"
    CGFloat itemHeight = 150;
    CGFloat itemWidth = 60;
    CGFloat collectionViewWidth = 3 * 60;


@interface LZHomeController ()<UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@end

@implementation LZHomeController

static NSString * const reuseIdentifier = @"LZHomeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    self.navigationController.delegate = self;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
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
   
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [[LZItemStorage sharedItemStorage] allYear].count > 0 ? : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.alpha = 1;
    
    if ([[LZItemStorage sharedItemStorage] allYear].count == 0) {
        
        cell.year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
        cell.labelText = [NSString stringWithFormat:@"%@年", [@([[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]]) parseToChineseNumber]];
    }else{
        
        NSArray *allYeas = [[LZItemStorage sharedItemStorage] allYear];
        NSNumber * currentYear = (NSNumber *)allYeas[indexPath.row];
        
        cell.year = currentYear.integerValue;
        cell.labelText = [NSString stringWithFormat:@"%@年", [currentYear parseToChineseNumber]];
    }
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat leftRightMargin = (collectionViewWidth - 2 * itemWidth) / 2 ;
    return UIEdgeInsetsMake(0, leftRightMargin, 0, leftRightMargin);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"---offset: %lf", scrollView.contentOffset.x);
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat cellMargin = 30;
    CGFloat cellW = 60.0;
    
    if (offsetX >= cellMargin) {
        
        
        NSInteger leftCellIndex = (offsetX - cellMargin ) / cellW;
        NSInteger rightCellIndex = (offsetX - cellMargin + 60 * 3) / cellW;
        
        CGFloat percent =  ( (offsetX - cellMargin ) - leftCellIndex * cellW) / (cellW * 1) ;
        
        //NSLog(@"leftcellIndex: %li ---- rightcellIndex: %li, percent %lf", leftCellIndex, rightCellIndex, percent);
        
        NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:leftCellIndex inSection:0];
        
        NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:rightCellIndex inSection:0];
        
        LZHomeCell *leftCell = (LZHomeCell *)[self.collectionView cellForItemAtIndexPath:leftIndexPath];
        
        LZHomeCell *rightCell = (LZHomeCell *)[self.collectionView cellForItemAtIndexPath:rightIndexPath];
        
        
        leftCell.contentView.alpha = 1 - percent > 0? 1 - percent : 0;
        
        rightCell.contentView.alpha =  percent < 1 ? percent: 1;
        
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LZYearController *yearVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZYearVC"];
    
    LZHomeCell *cell = (LZHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    yearVC.currentYear = cell.year;
    
    
    [self.navigationController pushViewController:yearVC animated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    LZDiaryAnimator *animator = [[LZDiaryAnimator alloc] init];
    animator.op = operation;
    
    return animator;
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
