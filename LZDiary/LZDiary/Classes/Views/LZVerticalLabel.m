//
//  LZVerticalLabel.m
//  LZDiary
//
//  Created by comst on 16/9/20.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZVerticalLabel.h"

@interface LZVerticalLabel ()

@property (nonatomic, strong) NSMutableDictionary *textAttribute;
@end

@implementation LZVerticalLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)sizeWithtext:(NSString *)text attr:(NSDictionary *)attrdict fontsize:(CGFloat)fontsize{
    
    return  [text boundingRectWithSize:CGSizeMake(fontsize, 480) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrdict context:nil];
}

- (instancetype)initWithFont:(NSString *)fontName fontsize:(CGFloat)fontsize text:(NSString *)text lineHeight:(CGFloat)lineHeight{
    
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        UIFont *font = [UIFont fontWithName:fontName  size:fontsize];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = lineHeight;
        
        NSMutableDictionary *attrM = [NSMutableDictionary dictionary];
        
        attrM[NSFontAttributeName] = font;
        attrM[NSParagraphStyleAttributeName] = paraStyle;
        
        self.textAttribute = attrM;
        
        CGRect labeSize = [self sizeWithtext:text attr:self.textAttribute fontsize:fontsize];
        
        self.frame = CGRectMake(0, 0, labeSize.size.width, labeSize.size.height);
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttribute];
        self.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.numberOfLines = 0;
        
    }
    
    return self;
}

- (void)resizeLabelWithFont:(NSString *)fontName fontSize:(CGFloat)fontsize text:(NSString *)text lineHeight:(CGFloat)lineHeight{
    
    UIFont *font = [UIFont fontWithName:fontName  size:fontsize];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineHeight;
    
    NSMutableDictionary *attrM = [NSMutableDictionary dictionary];
    
    attrM[NSFontAttributeName] = font;
    attrM[NSParagraphStyleAttributeName] = paraStyle;
    
    self.textAttribute = attrM;
    
    CGRect labeSize = [self sizeWithtext:text attr:self.textAttribute fontsize:fontsize];
    
    self.frame = CGRectMake(0, 0, labeSize.size.width, labeSize.size.height);
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttribute];
    self.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.numberOfLines = 0;
    
}

- (void)updateText:(NSString *)text{
    
    CGRect labeSize = [self sizeWithtext:text attr:self.textAttribute fontsize:self.font.pointSize];
    
    self.frame = CGRectMake(0, 0, labeSize.size.width, labeSize.size.height);
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.textAttribute];
    
    
}

- (void)updateColor:(UIColor*)color{
    self.textAttribute[NSForegroundColorAttributeName] = color;
     self.attributedText = [[NSAttributedString alloc] initWithString:self.attributedText.string attributes:self.textAttribute];
}
@end
