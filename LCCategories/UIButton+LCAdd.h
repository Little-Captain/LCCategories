//
//  UIButton+LCAdd.h
//
//  Created by Liu-Mac on 6/27/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LCAdd)

/**
 创建文本按钮

 @param title            标题文字
 @param fontSize         字体大小
 @param normalColor      默认颜色
 @param highlightedColor 高亮颜色

 @return 创建的按钮
 */
+ (instancetype)lc_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor;


/**
 创建文本按钮

 @param title               标题文字
 @param fontSize            字体大小
 @param normalColor         默认颜色
 @param highlightedColor    高亮颜色
 @param backgroundImageName 背景图像名称

 @return 创建的按钮
 */
+ (instancetype)lc_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName;

/**
 创建图像按钮

 @param imageName           图像名称
 @param backgroundImageName 背景图像名称

 @return 创建的按钮
 */
+ (instancetype)lc_imageButton:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName;

@end
