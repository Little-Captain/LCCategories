//
//  UIView+LCAdd.h
//
//  Created by Liu-Mac on 12/11/2014.
//  Copyright © 2014 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCAdd)

#pragma mark - boundes
@property (nonatomic, assign) CGFloat bWidth;
@property (nonatomic, assign) CGFloat bHeight;
@property (nonatomic, assign) CGSize  bSize;

#pragma mark - center
@property (nonatomic, assign) CGFloat cX;
@property (nonatomic, assign) CGFloat cY;

#pragma mark - frame
@property (nonatomic, assign) CGFloat fX;
@property (nonatomic, assign) CGFloat fY;
@property (nonatomic, assign) CGFloat fWidth;
@property (nonatomic, assign) CGFloat fHeight;
@property (nonatomic, assign) CGPoint fOrigin;
@property (nonatomic, assign) CGSize  fSize;

/// 返回视图截图
- (UIImage *)lc_snapshotImage;

/// 从nib文件当中加载View.
+ (instancetype)lc_loadFromNib;

/**
 *  返回当前视图, 所处的控制器
 *
 *  @return 控制器
 */
- (UIViewController *)lc_currentViewController;

#pragma mark - 动画相关

// 位移
- (void)lc_moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void)lc_moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method;
- (void)lc_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack;
- (void)lc_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method;

// 形变
/**
 *   旋转
 */
- (void)lc_rotate:(int)degrees secs:(float)secs delegate:(id)delegate callback:(SEL)method;
/**
 *  缩放
 */
- (void)lc_scale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method;

/**
 *  顺时针旋转
 *
 *  @param secs 动画执行时间
 */
- (void)lc_spinClockwise:(float)secs;

/**
 *  逆时针旋转
 *
 *  @param secs 动画执行时间
 */
- (void)lc_spinCounterClockwise:(float)secs;


/**
 *  反翻页效果
 *
 *  @param secs 动画执行时间
 */
- (void)lc_curlDown:(float)secs;

/**
 *  视图翻页后消失
 *
 *  @param secs 动画执行时间
 */
- (void)lc_curlUpAndAway:(float)secs;

/**
 *  旋转缩放到一点后消失
 *
 *  @param secs 动画执行时间
 */
- (void)lc_drainAway:(float)secs;

/**
 *  将视图改变到一定透明度
 *
 *  @param newAlpha alpha
 *  @param secs     动画执行时间
 */
- (void)lc_changeAlpha:(float)newAlpha secs:(float)secs;


/**
 *  改变透明度结束动画后还原
 *
 *  @param secs         alpha
 *  @param continuously 是否循环
 */
- (void)lc_pulse:(float)secs continuously:(BOOL)continuously;


/**
 *  以渐变方式添加子控件
 *
 *  @param subview 需要添加的子控件
 */
- (void)lc_addSubviewWithFadeAnimation:(UIView *)subview;

@end
