//
//  NSAttributedString+LCAdd.h
//
//  Created by Liu-Mac on 5/21/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (LCAdd)

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
+ (instancetype)lc_attributedStringWithImage:(UIImage *)image imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing;

@end
