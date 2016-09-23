//
//  LZShowController.m
//  LZDiary
//
//  Created by comst on 16/9/22.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZShowController.h"
#import "NSString+ChineseNumber.h"
#import "UIButton+LZDiaryButton.h"
#import "UIWebView+LZScreenShot.h"
#import "LZComposeController.h"
#import "LZItemStorage.h"
@interface LZShowController ()<UIWebViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIView *buttonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@property (nonatomic, strong) UIView *refreshView;
@end

@implementation LZShowController

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupWebView];
    [self setupContainerView];
    
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self webViewReload];
}

- (void)setupWebView{
    
    self.contentWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view insertSubview:self.contentWebView belowSubview:self.buttonContainerView];
    
    self.contentWebView.delegate = self;
    self.contentWebView.scrollView.delegate = self;
    self.contentWebView.scrollView.bounces = YES;
    self.contentWebView.alpha = 0;
    
    
    self.contentWebView.backgroundColor = [UIColor whiteColor];
  
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    
    self.doubleTap = doubleTap;
    [self.contentWebView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndHideContainerAction:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    self.singleTap = singleTap;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];

    [self.contentWebView addGestureRecognizer:singleTap];
    
    UIButton *refreshBtn = [UIButton diarybuttonWithText:@"完" fontSize:16 width:40 normalImageName:@"Oval" hightlightImageName:@"Oval_pressed"];
    refreshBtn.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), -20);
    
  
    
    [self.view addSubview:refreshBtn];
    
    self.refreshView = refreshBtn;
}

- (void)setupContainerView{
    
}

- (void)webViewReload{
    
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"DiaryTemplate" withExtension:@"html"];
    NSString *sourceContent = [NSString stringWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:nil];
    
    NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self.currentDiary.createDate];
    NSInteger month = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self.currentDiary.createDate];
    NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self.currentDiary.createDate];
    NSString *yearStr = [NSString stringWithFormat:@"%li", year];
    NSString *monthStr = [NSString stringWithFormat:@"%li", month];
    NSString *dayStr = [NSString stringWithFormat:@"%li", day];
    NSString *timeString = [NSString stringWithFormat:@"%@年%@月%@日",[yearStr parseToChineseNumber], [monthStr parseToChineseNumberWithUnit], [dayStr parseToChineseNumberWithUnit]];
    
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#timeString#" withString:timeString];
    
    NSString *diaryContent = [self.currentDiary.content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>" options:NSLiteralSearch range:NSMakeRange(0, self.currentDiary.content.length)];
    
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#newDiaryString#" withString:diaryContent];
    
    NSString *title = @"";
    CGFloat contentWidthOffset = 140;
    CGFloat contentMargin = 10;
    NSString *titleStr = self.currentDiary.title;
    NSString *parseTimeStr = [NSString stringWithFormat:@"%@日", [dayStr parseToChineseNumberWithUnit]];
    
    if (![titleStr isEqualToString:parseTimeStr]) {
        title = titleStr;
        contentWidthOffset = 205;
        title = [NSString stringWithFormat:@"<div class='title'>%@</div>", title];//@"<div class='title'>\(title)</div>";
        
    }
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#contentMargin#" withString: [NSString stringWithFormat:@"%lf", contentMargin]];
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#title#" withString: title];
    
    CGFloat minWidth = [UIScreen mainScreen].bounds.size.width - contentWidthOffset;
    
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#minWidth#" withString: [NSString stringWithFormat:@"%lf", minWidth]];
    
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#fontStr#" withString:@"TpldKhangXiDictTrial"];
    
    CGFloat titleMarginRight = 15;
    
    sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#titleMarginRight#" withString: [NSString stringWithFormat:@"%lf", titleMarginRight]];
    
    if (![self.currentDiary.location isEqualToString:@""]) {
        sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#location#" withString:self.currentDiary.location];
    }else{
        sourceContent = [sourceContent stringByReplacingOccurrencesOfString:@"#location#" withString:@""];
    }
    
    [self.contentWebView loadHTMLString:sourceContent baseURL:nil];
    
    
    
}

- (IBAction)saveAction:(UIButton *)sender {
    
    CGPoint offset = self.contentWebView.scrollView.contentOffset;
    
    UIImage *screenShot = [self.contentWebView screenShot];
    
    self.contentWebView.scrollView.contentOffset = offset;
    
    NSArray *items = @[screenShot];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityVC.popoverPresentationController.sourceView = sender;
    
    [self presentViewController:activityVC animated:YES completion:^{
        
    }];
    
}

- (IBAction)editAction:(UIButton *)sender {
    
    LZComposeController *composeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LZComposeVC"];
    composeVC.currentItem = self.currentDiary;
    
    [self presentViewController:composeVC animated:YES completion:^{
        
    }];
}

- (IBAction)deleteAction:(UIButton *)sender {
    [[LZItemStorage sharedItemStorage] deleteItem:self.currentDiary];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - gesture action
- (void)backAction:(UIGestureRecognizer *)gesture{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAndHideContainerAction:(UIGestureRecognizer *)gesture{
    if (self.buttonContainerView.alpha == 0.0) {
         //show
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.containerViewBottomConstraint.constant = 20;
            [self.view layoutIfNeeded];
            
            self.buttonContainerView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        //hide
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.containerViewBottomConstraint.constant = -60;
            [self.view layoutIfNeeded];;
            self.buttonContainerView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat percent;
    
    if (offsetY >= -80) {
        
        percent = (80 + offsetY) / 80;

    }else{
        
        percent = 0 ;
    }
    CGPoint center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), -20);
    center.y += - offsetY;
    self.refreshView.center = center;
    self.refreshView.alpha = percent;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat offsetY =scrollView.contentOffset.y;
    
    
    if (offsetY < - 80) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIView animateWithDuration:1.0 animations:^{
        self.contentWebView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    CGFloat width = self.contentWebView.scrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width;
    self.contentWebView.scrollView.contentOffset = CGPointMake(width, 0);
    
}

#pragma mark - gesture delegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end

