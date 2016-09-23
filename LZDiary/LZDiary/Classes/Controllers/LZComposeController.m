//
//  LZComposeController.m
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZComposeController.h"
#import "NSString+ChineseNumber.h"
#import "LZLocation.h"
#import "LZItemStorage.h"
#import "NSNumber+chineseNumber.h"
@interface LZComposeController ()<UITextViewDelegate, LZLocation>
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UITextView *locationTextView;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTextViewBottomConstraint;

@property (nonatomic, strong) LZLocation *diaryLoaction;
@end

@implementation LZComposeController


- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextViews];
    [self setupNotification];
    
    self.diaryLoaction = [[LZLocation alloc] init];
    self.diaryLoaction.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)setupTextViews{
    
    self.titleTextView.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:18];
    self.titleTextView.editable = YES;
    self.titleTextView.userInteractionEnabled = YES;
    self.titleTextView.bounces = NO;
    self.titleTextView.delegate = self;
    
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]];
    NSString *dayStr = [NSString stringWithFormat:@"%li", day];
    
    self.titleTextView.text = self.currentItem ? self.currentItem.title : [NSString stringWithFormat:@"%@日", [dayStr parseToChineseNumberWithUnit]];
    
    
    self.composeTextView.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:18];
    self.composeTextView.editable = YES;
    self.composeTextView.userInteractionEnabled = YES;
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.composeTextView becomeFirstResponder];
    self.composeTextView.delegate = self;
    self.composeTextView.text = self.currentItem ? self.currentItem.content : @"";
    
    self.locationTextView.font = [UIFont fontWithName:@"TpldKhangXiDictTrial" size:16];
    self.locationTextView.editable = YES;
    self.locationTextView.userInteractionEnabled = YES;
    self.locationTextView.bounces = NO;
    self.locationTextView.delegate = self;
    self.locationTextView.text = self.currentItem ? self.currentItem.location : @"";
    
    self.finishButton.titleLabel.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:18];
}

- (void)setupNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (IBAction)finishAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self.currentItem) {
        //edit
        if ([self.titleTextView.text length] > 0) {
            self.currentItem.title = self.titleTextView.text;
        }
        
        if ([self.composeTextView.text length] > 0) {
            self.currentItem.content = self.composeTextView.text;
        }
        if ([self.locationTextView.text length] > 0) {
            self.currentItem.location = self.locationTextView.text;
        }
        [[LZItemStorage sharedItemStorage] saveItems];
    }else{
        //new diary
        if ([self.composeTextView.text length] > 0) {
            LZtmpItem *newItem = [[LZtmpItem alloc] init];
            
            
            newItem.content = self.composeTextView.text;
            newItem.location = self.locationTextView.text;
            newItem.createDate = [NSDate date];
            newItem.year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:newItem.createDate];
            newItem.month = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:newItem.createDate];
            
            if ([self.titleTextView.text length] > 0) {
                newItem.title = self.titleTextView.text;
            }else{
                newItem.title = [NSString stringWithFormat:@"%@日", [@(newItem.month) parseToChineseNumberWithUnit] ];
            }
            
            [[LZItemStorage sharedItemStorage] addNewItem:newItem];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

    });
   }

/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:^{
         
    }];
}*/

- (void)keyboardAction:(NSNotification *)notif{
    
    CGRect keyBoardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
    
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat keyboardHeight = screenHeight - keyBoardFrame.origin.y;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        self.locationTextViewBottomConstraint.constant = - (10 + keyboardHeight);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - textview delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - LZlocation

- (void)locationDidUpdate:(LZLocation *)currentLocation{
    if ([currentLocation.address isEqualToString:@""] || currentLocation.address.length == 0) {
        
    }else{
        self.locationTextView.text = [NSString stringWithFormat:@"于 %@", [currentLocation address]];
    }
    
}

- (void)dealloc{
    
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
