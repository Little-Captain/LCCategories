//
//  UIViewController+LCAdd.m
//
//  Created by Liu-Mac on 6/14/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UIViewController+LCAdd.h"

@implementation UIViewController (LCAdd)

- (void)lc_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}

@end
