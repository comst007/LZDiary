//
//  LZMonthController.m
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZMonthController.h"
#import "LZDiaryLayout.h"
#import "LZVerticalLabel.h"
#import "NSString+ChineseNumber.h"
#import "UIButton+LZDiaryButton.h"
#import "LZMonthCell.h"
#import "LZComposeController.h"
#import "LZShowController.h"
#import "LZItemStorage.h"
#import "NSNumber+chineseNumber.h"

@interface LZMonthController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) LZVerticalLabel *yearLabel;
@property (nonatomic, strong) UIButton *composeButton;
@property (nonatomic, strong) LZVerticalLabel *monthLabel;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *yLabelTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *mLabelTapGesture;

@property (nonatomic, assign) CGFloat preOffsetX;
@end

@implementation LZMonthController

static NSString * const reuseIdentifier = @"LZMonthCell";

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetup];
    [self setupLabelAndButton];
    [self setupCollectionView];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)baseSetup{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    
    tapGesture.numberOfTapsRequired = 2 ;
    
    self.doubleTapGesture = tapGesture;
    
    
    [self.view addGestureRecognizer:tapGesture];

}

- (void)setupLabelAndButton{
    
    LZVerticalLabel *label = [[LZVerticalLabel alloc] initWithFont:@"TpldKhangXiDictTrial" fontsize:20 text:[@(self.currentYear) parseToChineseNumber] lineHeight:5];
    label.userInteractionEnabled = YES;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    label.center = CGPointMake(screenWidth - 15 - label.frame.size.width / 2, 20 + label.frame.size.height / 2);
    self.yearLabel = label;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearLabelTap:)];
    tapGesture.numberOfTapsRequired = 1;
    
    
    
    self.yLabelTapGesture = tapGesture;
    
    [self.yLabelTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    [label addGestureRecognizer:tapGesture];
    [self.view addSubview:label];
    
    UIButton *composeBtn = [UIButton diarybuttonWithText:@"写" fontSize:14 width:40 normalImageName:@"Oval" hightlightImageName:@"Oval_pressed"];
    composeBtn.center = CGPointMake(label.center.x, CGRectGetMaxY(label.frame) + 38);
    
    [composeBtn addTarget:self action:@selector(composeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:composeBtn];
    self.composeButton = composeBtn;
    
    LZVerticalLabel *monthLabel = [[LZVerticalLabel alloc] initWithFont:@"Wyue-GutiFangsong-NC" fontsize:16 text:[NSString stringWithFormat:@"%@月", [@(self.currentMonth) parseToChineseNumberWithUnit]] lineHeight:5];
    
    monthLabel.center = CGPointMake(self.yearLabel.center.x, (screenHeight - 150) / 2 + monthLabel.frame.size.height / 2);
    
    UIColor *monColor = [UIColor colorWithRed:192 / 255.0 green:23 / 255.0 blue:48 / 255.0 alpha:1];
    [monthLabel updateColor:monColor];
    monthLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *monthGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthLabelTap:)];
    monthGesture.numberOfTapsRequired = 1;
    
    
    
    self.mLabelTapGesture = monthGesture;
    
    [self.mLabelTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    [monthLabel addGestureRecognizer:monthGesture];
    
    self.monthLabel = monthLabel;
    [self.view addSubview:monthLabel];
    

}

- (void)setupCollectionView{
    
    //self.collectionView.backgroundColor = [UIColor blueColor];
    LZDiaryLayout *yearLayout = [[LZDiaryLayout alloc] init];
    
    yearLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView setCollectionViewLayout:yearLayout animated:NO];
    
    self.collectionView.frame = CGRectMake(0, 0, 60 * 3, 150);
    
    self.collectionView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - gesture action

- (void)backAction:(UITapGestureRecognizer *)tapGesture{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)yearLabelTap:(UITapGestureRecognizer *)tapGesture{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)monthLabelTap:(UITapGestureRecognizer *)tapGesture{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)composeAction{
    
    LZComposeController *composeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZComposeVC"];
    [self presentViewController:composeVC animated:YES completion:^{
        
    }];
}


#pragma mark <UICollectionViewDataSource>




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return [[LZItemStorage sharedItemStorage] allItemsWithYear:self.currentYear month:self.currentMonth].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZMonthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.alpha = 1;
    
    NSArray *diaryArr = [[LZItemStorage sharedItemStorage] allItemsWithYear:self.currentYear month:self.currentMonth] ;
    
    Diary *currentItem = diaryArr[indexPath.row];
    
    cell.labelText = currentItem.title;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat leftRightMargin = (60 * 3 - 2 * 60) / 2 ;
    return UIEdgeInsetsMake(0, leftRightMargin, 0, leftRightMargin);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LZShowController *showVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZShowVC"];
    
    NSArray *diaryArr = [[LZItemStorage sharedItemStorage] allItemsWithYear:self.currentYear month:self.currentMonth] ;
    
    Diary *currentItem = diaryArr[indexPath.row];
    
    /*
    LZDiaryItem *item = [[LZDiaryItem alloc] init];
    item.title = @"静夜思";
    item.content = @"窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。窗前明月光。\n疑是地上霜。\n举头望明月。\n低头思故乡。";
    item.location = @"深圳";
    item.year = 2016;
    item.month = 9;
    item.createDate = [NSDate date];
     */
    showVC.currentDiary = currentItem;
    
    [self.navigationController pushViewController:showVC animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //NSLog(@"---offset: %lf", scrollView.contentOffset.x);
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat cellMargin = 30;
    CGFloat cellW = 60.0;

    if (offsetX >= cellMargin) {
        
        
        NSInteger leftCellIndex = (offsetX - cellMargin ) / cellW;
        NSInteger rightCellIndex = (offsetX - cellMargin + 60 * 3) / cellW;
        
        CGFloat percent =   (offsetX - cellMargin ) / cellW - leftCellIndex  ;
        
        //NSLog(@"leftcellIndex: %li ---- rightcellIndex: %li, percent %lf", leftCellIndex, rightCellIndex, percent);
        
        NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:leftCellIndex inSection:0];
        
        NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:rightCellIndex inSection:0];
        
        LZMonthCell *leftCell = (LZMonthCell *)[self.collectionView cellForItemAtIndexPath:leftIndexPath];
        
        LZMonthCell *rightCell = (LZMonthCell *)[self.collectionView cellForItemAtIndexPath:rightIndexPath];
        
        
        leftCell.contentView.alpha = 1 - percent ;
        
        rightCell.contentView.alpha =  percent;
   
    }
    
    
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
