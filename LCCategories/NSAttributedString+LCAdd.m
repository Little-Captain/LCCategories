//
//  NSAttributedString+LCAdd.m
//
//  Created by Liu-Mac on 5/21/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "NSAttributedString+LCAdd.h"

@implementation NSAttributedString (LCAdd)

/**
 使用图像和文本生成上下排列的属性文本
 
 @param image 图像
 @param imageWH 图像宽高
 @param title 标题文字
 @param fontSize 标题字体大小
 @param titleColor 标题颜色
 @param spacing 图像和标题间距
 @return 属性文本
 */
+ (instancetype)lc_attributedStringWithImage:(UIImage *)image imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing {
    
    // 文本字典
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 换行文本
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:spacingDict];
    
    // 按钮文字
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    
    return attM.copy;
}

@end
