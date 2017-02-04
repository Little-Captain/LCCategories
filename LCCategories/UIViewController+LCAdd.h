//
//  UIViewController+LCAdd.h
//
//  Created by Liu-Mac on 6/14/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LCAdd)

/**
 * 在当前视图控制器中添加子控制器，将子控制器的视图添加到 view 中
 *
 * @param childController 要添加的子控制器
 * @param view            要添加到的视图
 */
- (void)lc_addChildController:(UIViewController *)childController intoView:(UIView *)view;

@end
