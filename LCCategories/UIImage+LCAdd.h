//
//  UIImage+LCAdd.h
//
//  Created by Liu-Mac on 4/11/2015.
//  Copyright © 2015 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

/*
 *  水印方向
 */
typedef NS_ENUM(NSUInteger, ImageWaterDirect) {
    //左上
    ImageWaterDirectTopLeft=0,
    
    //右上
    ImageWaterDirectTopRight,
    
    //左下
    ImageWaterDirectBottomLeft,
    
    //右下
    ImageWaterDirectBottomRight,
    
    //正中
    ImageWaterDirectCenter
};

@interface UIImage (LCAdd)

#pragma mark - gif 图片处理相关

/**
 *  播放动画
 *
 *  @param data 源文件（图片源）
 *
 *  @return 图片
 */
+ (UIImage *)lc_animatedGIFWithData:(NSData *)data;

/**
 *  计算动画中每一张图片的播放时间
 *
 *  @param index  图片索引
 *  @param source 图片组
 *
 *  @return  播放时间
 */
+ (float)lc_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;

/**
 *  播放gif动画
 *
 *  @param name 文件名
 *
 *  @return 图片
 */
+ (UIImage *)lc_animatedGIFNamed:(NSString *)name;
/**
 *  缩放动画
 *
 *  @param size 大小
 *
 *  @return 图片
 */
- (UIImage *)lc_animatedImageByScalingAndCroppingToSize:(CGSize)size;

#pragma mark - 图片处理

/**
 *  修正图片方向
 *
 *  @return 修改后的图片
 */
- (UIImage *)lc_fixOrientation;

/**
 *  返回指定颜色生成的图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return 图片
 */
+ (UIImage *)lc_imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  获取指定尺寸（50*50）的图片
 *
 *  @param color 图片颜色
 *  @param name  文本,居中显示
 *
 *  @return 图片
 */
+ (UIImage *)lc_imageWithColor:(UIColor *)color text:(NSString *)name;

/// 对图片进行模糊处理
+ (UIImage *)lc_gaussianBlurImage:(UIImage *)image andInputRadius:(CGFloat)radius;

/// 由颜色生成模糊图片
+ (UIImage *)lc_gaussianBlurImageWithColor:(UIColor *)color andSize:(CGSize)size andInputRadius:(CGFloat)radius;

/**
 *  转成黑白图像
 *
 *  @param sourceImage 原图
 *
 *  @return 黑白图像
 */
+ (UIImage*)lc_covertToGrayImageFromImage:(UIImage*)sourceImage;

/**
 *  获取图片指定位置的颜色
 *
 *  @param point 位置
 *
 *  @return 颜色
 */
- (UIColor *)lc_colorAtPoint:(CGPoint )point;
/**
 *  旋转图片
 *
 *  @param isHorizontal 方向
 *
 *  @return 结果图片
 */
- (UIImage *)lc_flip:(BOOL)isHorizontal;

/**
 *  图片剪切为圆形
 *
 *  @return 剪切后的圆形图片
 */
- (UIImage *)lc_roundImage;


//获取一个图片的大小.
- (CGSize)lc_sizeFromImage:(UIImage *)image;

/*
 *  直接截屏
 */
+ (UIImage *)lc_cutScreen;

/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)lc_cutFromView:(UIView *)view;

/**
 *  从给定UIImage和指定Frame截图：
 */
- (UIImage *)lc_cutWithFrame:(CGRect)frame;

#pragma mark - 图片缩放相关

//UIImage等比例缩放
+(UIImage *)lc_scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize;

//UIImage自定长宽缩放
+(UIImage *)lc_reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

// 返回原始的图片
+ (instancetype)lc_imageOfAlwaysOriginalWithImageNamed:(NSString *)name;

// 返回可拉伸的图片
+ (UIImage *)lc_imageOfResizableWithName:(NSString *)name;

#pragma mark - 水印相关

/**
 *  文字水印
 *
 *  @param text      文字
 *  @param direction 文字方向
 *  @param fontColor 文字颜色
 *  @param fontPoint 字体
 *  @param marginXY   对齐点
 *
 *  @return 图片
 */
- (UIImage *)lc_waterWithText:(NSString *)text
                 direction:(ImageWaterDirect)direction
                 fontColor:(UIColor *)fontColor
                 fontPoint:(CGFloat)fontPoint
                  marginXY:(CGPoint)marginXY;



/**
 *  绘制图片水印
 *
 *  @param waterImage 图片水印
 *  @param direction  方向
 *  @param waterSize  水印大小
 *  @param marginXY   对齐点
 *
 *  @return 图片
 */
- (UIImage *)lc_waterWithWaterImage:(UIImage *)waterImage
                       direction:(ImageWaterDirect)direction
                       waterSize:(CGSize)waterSize
                        marginXY:(CGPoint)marginXY;


/**
 *  文字水印位置
 *
 *  @param str       字符串
 *  @param attr      字符串属性
 *  @param direction 方向
 *  @param rect      图片Rect
 *  @param marginXY  对齐点
 *
 *  @return 图片
 */
- (CGRect)lc_calWidth:(NSString *)str
              attr:(NSDictionary *)attr
         direction:(ImageWaterDirect)direction
              rect:(CGRect)rect
          marginXY:(CGPoint)marginXY;

/**
 *  计算水印位置
 *
 *  @param rect      图片rect
 *  @param size      size
 *  @param direction 文字方向
 *  @param marginXY   对齐点
 *
 *  @return 图片
 */
- (CGRect)lc_rectWithRect:(CGRect)rect
                  size:(CGSize)size
             direction:(ImageWaterDirect)direction
              marginXY:(CGPoint)marginXY;

@end
