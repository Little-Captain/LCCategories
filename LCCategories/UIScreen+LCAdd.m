//
//  UIScreen+LCAdd.m
//
//  Created by Liu-Mac on 12/11/2014.
//  Copyright © 2014 Liu-Mac. All rights reserved.
//

#import "UIScreen+LCAdd.h"

@implementation UIScreen (LCAdd)

+ (CGFloat)lc_screenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)lc_screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)lc_scale {
    
    return [UIScreen mainScreen].scale;
}

@end
