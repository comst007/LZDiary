//
//  LZHomeCell.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZHomeCell.h"
#import "LZVerticalLabel.h"

extern CGFloat itemWidth;
extern CGFloat itemHeight;

@interface LZHomeCell ()

@property (nonatomic, strong) LZVerticalLabel *diaryLabel;

@end

@implementation LZHomeCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.diaryLabel = [[LZVerticalLabel alloc] initWithFont:@"TpldKhangXiDictTrial" fontsize:16 text:@"1002" lineHeight:5];
    
    [self.contentView addSubview:self.diaryLabel];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.diaryLabel.center = CGPointMake(60 / 2 , (150) / 2);
}

- (void)setLabelText:(NSString *)labelText{
    
    _labelText = labelText;
    
    [self.diaryLabel updateText:labelText];
}
@end
