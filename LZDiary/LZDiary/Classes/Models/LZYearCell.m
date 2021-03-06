//
//  LZYearCell.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZYearCell.h"
#import "LZVerticalLabel.h"

extern CGFloat itemWidth;
extern CGFloat itemHeight;

@interface LZYearCell ()

@property (nonatomic, strong) LZVerticalLabel *diaryLabel;

@end

@implementation LZYearCell


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.diaryLabel = [[LZVerticalLabel alloc] initWithFont:@"Wyue-GutiFangsong-NC" fontsize:16 text:@"1002" lineHeight:5];
    
    [self.contentView addSubview:self.diaryLabel];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
}

- (void)setLabelText:(NSString *)labelText{
    
    _labelText = labelText;
    
    [self.diaryLabel updateText:labelText];
    
    self.diaryLabel.center = CGPointMake(60 / 2 , self.diaryLabel.center.y + 28);
}
@end
