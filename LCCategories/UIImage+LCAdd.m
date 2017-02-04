//
//  UIImage+LCAdd.m
//
//  Created by Liu-Mac on 4/11/2015.
//  Copyright © 2015 Liu-Mac. All rights reserved.
//

#import "UIImage+LCAdd.h"


@implementation UIImage (LCAdd)

/**
 *  播放动画
 *
 *  @param data 源文件（图片源）
 *
 *  @return 图片
 */
+ (UIImage *)lc_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    // 加载所有图片
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 图片数量
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    // 只有一张，直接加载
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    // 多张图片，循环播放
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            // 图片播放时间累加
            duration += [self lc_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image
                                                  scale:[UIScreen mainScreen].scale
                                            orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        // 加载动画图片，指定动画播放时间
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}

/**
 *  计算动画中每一张图片的播放时间
 *
 *  @param index  图片索引
 *  @param source 图片组
 *
 *  @return  播放时间
 */
+ (float)lc_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    
    // 字典转换
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    // 如果有延迟时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    // 否则就获取播放下一张图片需要等待的时间
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // 设置最小值
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

/**
 *  播放gif动画
 *
 *  @param name 文件名
 *
 *  @return 图片
 */
+ (UIImage *)lc_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // 视网膜屏，可能要加载高清图
    if (scale > 1.0f) {
        // 文件名1
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (data) {
            return [UIImage lc_animatedGIFWithData:data];
        }
        
        // 文件名2
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage lc_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
    // 普通屏幕
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        if (data) {
            return [UIImage lc_animatedGIFWithData:data];
        }
        
        return [UIImage imageNamed:name];
    }
}

/**
 *  缩放动画
 *
 *  @param size 大小
 *
 *  @return 图片
 */
- (UIImage *)lc_animatedImageByScalingAndCroppingToSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }
    
    CGSize scaledSize = size;
    CGPoint thumbnailPoint = CGPointZero;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;
    
    if (widthFactor > heightFactor) {
        thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
    }
    else if (widthFactor < heightFactor) {
        thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
    }
    
    NSMutableArray *scaledImages = [NSMutableArray array];
    
    // 重绘制图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    for (UIImage *image in self.images) {
        [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        [scaledImages addObject:newImage];
    }
    
    UIGraphicsEndImageContext();
    
    return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

#pragma mark - 图片处理

- (UIImage *)lc_fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  返回指定颜色生成的图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 *
 *  @return 图片
 */
+ (UIImage *)lc_imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/**
 *  获取指定尺寸（50*50）的图片
 *
 *  @param color 图片颜色
 *  @param name  文本,居中显示
 *
 *  @return 图片
 */
+ (UIImage *)lc_imageWithColor:(UIColor *)color text:(NSString *)name
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    [name drawAtPoint:CGPointMake(10, 15) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/// 对图片进行模糊处理
+ (UIImage *)lc_gaussianBlurImage:(UIImage *)image andInputRadius:(CGFloat)radius
{
    if (!image) {
        return nil;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return resultImage;
}
/// 由颜色生成模糊图片
+ (UIImage *)lc_gaussianBlurImageWithColor:(UIColor *)color andSize:(CGSize)size andInputRadius:(CGFloat)radius
{
    UIImage *image = [UIImage lc_imageWithColor:color andSize:size];
    if (image) {
        return [UIImage lc_gaussianBlurImage:image andInputRadius:radius];
    }
    else {
        return nil;
    }
}

/// 如果含有透明通道就返回TRUE
- (BOOL)lc_hasAlpha {
    // 获取图片的Alpha信息
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    // 只要满足一下一种就含有透明通道
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/**
 *  转成黑白图像
 *
 *  @param sourceImage 原图
 *
 *  @return 黑白图像
 */
+ (UIImage*)lc_covertToGrayImageFromImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    // 指定颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // 创建图形上下文
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    // 绘制图片
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    // 得到图片
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

/**
 *  获取图片指定位置的颜色
 *
 *  @param point 位置
 *
 *  @return 颜色
 */
- (UIColor *)lc_colorAtPoint:(CGPoint )point
{
    if (point.x < 0 || point.y < 0) return nil;
    
    CGImageRef imageRef = self.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    if (point.x >= width || point.y >= height) return nil;
    // 申请内存 w*h*pixel
    unsigned char *rawData = malloc(height * width * 4);
    if (!rawData) return nil;
    // 指定颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    // 创建图形上下文
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast
                                                 | kCGBitmapByteOrder32Big);
    if (!context) {
        free(rawData);
        return nil;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    // 遍历寻找所要寻找位置的颜色，像素矩阵
    int byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
    UIColor *result = nil;
    result = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    free(rawData);
    return result;
}

/**
 *  旋转图片
 *
 *  @param isHorizontal 方向
 *
 *  @return 结果图片
 */
- (UIImage *)lc_flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI); // 旋转
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);// 平移
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  图片剪切为圆形
 *
 *  @return 剪切后的圆形图片
 */
- (UIImage *)lc_roundImage{
    
    //获取size
    CGSize size = [self lc_sizeFromImage:self];
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建一个图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制圆形路径
    CGContextAddEllipseInRect(ctx, rect);
    
    //剪裁上下文
    CGContextClip(ctx);
    
    //绘制图片
    [self drawInRect:rect];
    
    //取出图片
    UIImage *roundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return roundImage;
}


- (CGSize)lc_sizeFromImage:(UIImage *)image{
    
    CGSize size = image.size;
    
    CGFloat wh =MIN(size.width, size.height);
    
    return CGSizeMake(wh, wh);
}

/*
 *  直接截屏
 */
+ (UIImage *)lc_cutScreen{
    return [self lc_cutFromView:[UIApplication sharedApplication].keyWindow];
}

/**
 *  从给定UIView中截图：UIView转UIImage
 */
+ (UIImage *)lc_cutFromView:(UIView *)view{
    
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在新建的图形上下文中渲染view的layer
    [view.layer renderInContext:context];
    
    [[UIColor clearColor] setFill];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  从给定UIImage和指定Frame截图：
 */
- (UIImage *)lc_cutWithFrame:(CGRect)frame{
    
    //创建CGImage
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.CGImage, frame);
    
    //创建image
    UIImage *newImage=[UIImage imageWithCGImage:cgimage];
    
    //释放CGImage
    CGImageRelease(cgimage);
    
    return newImage;
}

#pragma mark - 图片缩放相关

//UIImage等比例缩放
+(UIImage *)lc_scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

//UIImage自定长宽缩放
+(UIImage *)lc_reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

+ (instancetype)lc_imageOfAlwaysOriginalWithImageNamed:(NSString *)name {
    
    return [[self imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

+ (UIImage *)lc_imageOfResizableWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    CGSize size = image.size;
    
    return  [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height/2, size.width/2, size.height/2 - 1, size.width/2 -1)];
}

#pragma mark - 水印
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
                  marginXY:(CGPoint)marginXY{
    
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //绘制文本
    NSDictionary *attr =@{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint],NSForegroundColorAttributeName:fontColor};
    
    CGRect strRect = [self lc_calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    
    [text drawInRect:strRect withAttributes:attr];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
                        marginXY:(CGPoint)marginXY{
    
    CGSize size = self.size;
    
    CGRect rect = (CGRect){CGPointZero,size};
    
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //绘制图片
    [self drawInRect:rect];
    
    //计算水印的rect
    CGSize waterImageSize = CGSizeEqualToSize(waterSize, CGSizeZero)?waterImage.size:waterSize;
    CGRect calRect = [self lc_rectWithRect:rect size:waterImageSize direction:direction marginXY:marginXY];
    
    //绘制水印图片
    [waterImage drawInRect:calRect];
    
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

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
          marginXY:(CGPoint)marginXY{
    
    CGSize size =  [str sizeWithAttributes:attr];
    
    CGRect calRect = [self lc_rectWithRect:rect size:size direction:direction marginXY:marginXY];
    
    return calRect;
}

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
              marginXY:(CGPoint)marginXY{
    
    CGPoint point = CGPointZero;
    
    //右上
    if(ImageWaterDirectTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    
    //左下
    if(ImageWaterDirectBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    
    //右下
    if(ImageWaterDirectBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    
    //正中
    if(ImageWaterDirectCenter == direction) point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
    
    point.x+=marginXY.x;
    point.y+=marginXY.y;
    
    CGRect calRect = (CGRect){point,size};
    
    return calRect;
}

@end
