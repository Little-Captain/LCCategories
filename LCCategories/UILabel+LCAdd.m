//
//  UILabel+LCAdd.m
//
//  Created by Liu-Mac on 4/27/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UILabel+LCAdd.h"

@implementation UILabel (LCAdd)

+ (instancetype)lc_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label;
}

@end
