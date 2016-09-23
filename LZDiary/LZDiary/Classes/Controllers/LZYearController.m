//
//  LZYearController.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZYearController.h"
#import "LZDiaryLayout.h"
#import "LZVerticalLabel.h"
#import "NSString+ChineseNumber.h"
#import "UIButton+LZDiaryButton.h"
#import "LZYearCell.h"
#import "LZMonthController.h"
#import "LZComposeController.h"
#import "LZItemStorage.h"
#import "NSNumber+chineseNumber.h"
#import "LZTipView.h"

@interface LZYearController ()<UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) LZVerticalLabel *yearLabel;
@property (nonatomic, strong) UIButton *composeButton;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

@property (nonatomic, strong) UITapGestureRecognizer *labelTapGesture;
@end

@implementation LZYearController

static NSString * const reuseIdentifier = @"LZYearCell";

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupBase];
    [self setupLabelAndButton];
    
    [self setupCollectionView];
    
    
   
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTip];
    [self.collectionView reloadData];
    
    
}

- (void)showTip{
    NSNumber *firstStart = [[NSUserDefaults standardUserDefaults] valueForKey:@"firstLoadYearVC"];
    
    if (firstStart.boolValue != YES) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"firstLoadYearVC"];
        LZTipView *tipView = [[LZTipView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:tipView];
        [tipView show];
        
    }
    
}

- (void)setupBase{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    
    tapGesture.numberOfTapsRequired = 2 ;
    
    self.doubleTapGesture = tapGesture;
    
    
    [self.view addGestureRecognizer:tapGesture];
    
}
- (void)setupLabelAndButton{
   
    LZVerticalLabel *label = [[LZVerticalLabel alloc] initWithFont:@"TpldKhangXiDictTrial" fontsize:20 text:[@(self.currentYear) parseToChineseNumber] lineHeight:5];
    label.userInteractionEnabled = YES;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    label.center = CGPointMake(screenWidth - 15 - label.frame.size.width / 2, 20 + label.frame.size.height / 2);
    self.yearLabel = label;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    tapGesture.numberOfTapsRequired = 1;
    
   
    
    self.labelTapGesture = tapGesture;
    
    [self.labelTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
     [label addGestureRecognizer:tapGesture];
    [self.view addSubview:label];
    
    UIButton *composeBtn = [UIButton diarybuttonWithText:@"写" fontSize:14 width:40 normalImageName:@"Oval" hightlightImageName:@"Oval_pressed"];
    composeBtn.center = CGPointMake(label.center.x, CGRectGetMaxY(label.frame) + 38);
    
    [composeBtn addTarget:self action:@selector(composeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:composeBtn];
    self.composeButton = composeBtn;
    
}



- (void)setupCollectionView{
    
    LZDiaryLayout *yearLayout = [[LZDiaryLayout alloc] init];
    
    yearLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.collectionView setCollectionViewLayout:yearLayout animated:NO];
    
    self.collectionView.frame = CGRectMake(0, 0, 60 * 3, 150);
    
    self.collectionView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(UITapGestureRecognizer *)tapGesture{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)labelTap:(UITapGestureRecognizer *)tapGesture{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)composeAction{
    
    LZComposeController *composeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZComposeVC"];
    [self presentViewController:composeVC animated:YES completion:^{
        
    }];
}


#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [[LZItemStorage sharedItemStorage] allMonthInYear:self.currentYear].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZYearCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.contentView.alpha = 1 ;
    
    NSArray *monthArr = [[LZItemStorage sharedItemStorage] allMonthInYear:self.currentYear];
    
    NSNumber *currentMon = monthArr[indexPath.row];
    
    cell.month = currentMon.integerValue;
    
    cell.labelText = [NSString stringWithFormat:@"%@月", [currentMon parseToChineseNumber]];
    
    // Configure the cell
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat leftRightMargin = (60 * 3 - 2 * 60) / 2 ;
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
        
        CGFloat percent =   (offsetX - cellMargin ) / cellW - leftCellIndex  ;
        
        //NSLog(@"leftcellIndex: %li ---- rightcellIndex: %li, percent %lf", leftCellIndex, rightCellIndex, percent);
        
        NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:leftCellIndex inSection:0];
        
        NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:rightCellIndex inSection:0];
        
        LZYearCell *leftCell = (LZYearCell *)[self.collectionView cellForItemAtIndexPath:leftIndexPath];
        
        LZYearCell *rightCell = (LZYearCell *)[self.collectionView cellForItemAtIndexPath:rightIndexPath];
        
        
        leftCell.contentView.alpha = 1 - percent ;
        
        rightCell.contentView.alpha =  percent;
        
    }
    
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LZMonthController *monthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZMonthVC"];
    
    LZYearCell * cell = (LZYearCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    monthVC.currentYear = self.currentYear;
    monthVC.currentMonth = cell.month;
    
    
    [self.navigationController pushViewController:monthVC animated:YES];
}
#pragma mark <UICollectionViewDelegate>



@end
