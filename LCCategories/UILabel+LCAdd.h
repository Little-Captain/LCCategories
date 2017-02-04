//
//  UILabel+LCAdd.h
//
//  Created by Liu-Mac on 4/27/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LCAdd)

/**
 创建文本标签

 @param text 文本
 @param fontSize 字体大小
 @param color 颜色
 @return label对象
 */
+ (instancetype)lc_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

@end
