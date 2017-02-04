//
//  UIView+LCAdd.m
//
//  Created by Liu-Mac on 12/11/2014.
//  Copyright © 2014 Liu-Mac. All rights reserved.
//

#import "UIView+LCAdd.h"

@implementation UIView (LCAdd)

- (UIImage *)lc_snapshotImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

+ (instancetype)lc_loadFromNib {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
}

- (UIViewController *)lc_currentViewController
{
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 动画相关

// Very helpful function

#define radiansForDegrees(degrees) ((degrees) * M_PI / 180.0)


#pragma mark - Moves

- (void)lc_moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option {
    [self lc_moveTo:destination duration:secs option:option delegate:nil callback:nil];
}

- (void)lc_moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [delegate performSelector:method];
#pragma clang diagnostic pop
                             
                         }
                     }];
}

- (void)lc_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack {
    [self lc_raceTo:destination withSnapBack:withSnapBack delegate:nil callback:nil];
}

- (void)lc_raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method {
    CGPoint stopPoint = destination;
    if (withSnapBack) {
        // Determine our stop point, from which we will "snap back" to the final destination
        int diffx = destination.x - self.frame.origin.x;
        int diffy = destination.y - self.frame.origin.y;
        if (diffx < 0) {
            // Destination is to the left of current position
            stopPoint.x -= 10.0;
        } else if (diffx > 0) {
            stopPoint.x += 10.0;
        }
        if (diffy < 0) {
            // Destination is to the left of current position
            stopPoint.y -= 10.0;
        } else if (diffy > 0) {
            stopPoint.y += 10.0;
        }
    }
    
    // Do the animation
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(stopPoint.x, stopPoint.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (withSnapBack) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  self.frame = CGRectMake(destination.x, destination.y, self.frame.size.width, self.frame.size.height);
                                              }
                                              completion:^(BOOL finished) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                                  [delegate performSelector:method];
#pragma clang diagnostic pop
                                                  
                                              }];
                         } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [delegate performSelector:method];
#pragma clang diagnostic pop
                         }
                     }];
}


#pragma mark - Transforms

- (void)lc_rotate:(int)degrees secs:(float)secs delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(degrees));
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [delegate performSelector:method];
#pragma clang diagnostic pop
                         }
                     }];
}

- (void)lc_scale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [delegate performSelector:method];
#pragma clang diagnostic pop
                         }
                     }];
}

- (void)lc_spinClockwise:(float)secs {
    [UIView animateWithDuration:secs/4
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(90));
                     }
                     completion:^(BOOL finished) {
                         [self lc_spinClockwise:secs];
                     }];
}

- (void)lc_spinCounterClockwise:(float)secs {
    [UIView animateWithDuration:secs/4
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(270));
                     }
                     completion:^(BOOL finished) {
                         [self lc_spinCounterClockwise:secs];
                     }];
}


#pragma mark - Transitions

- (void)lc_curlDown:(float)secs {
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^ { [self setAlpha:1.0]; }
                    completion:nil];
}

- (void)lc_curlUpAndAway:(float)secs {
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^ { [self setAlpha:0]; }
                    completion:nil];
}

- (void)lc_drainAway:(float)secs {
    self.tag = 20;
    [NSTimer scheduledTimerWithTimeInterval:secs/50 target:self selector:@selector(lc_drainTimer:) userInfo:nil repeats:YES];
}

- (void)lc_drainTimer:(NSTimer*)timer {
    CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
    self.transform = trans;
    self.alpha = self.alpha * 0.98;
    self.tag = self.tag - 1;
    if (self.tag <= 0) {
        [timer invalidate];
        [self removeFromSuperview];
    }
}

#pragma mark - Effects

- (void)lc_changeAlpha:(float)newAlpha secs:(float)secs {
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = newAlpha;
                     }
                     completion:nil];
}

- (void)lc_pulse:(float)secs continuously:(BOOL)continuously {
    [UIView animateWithDuration:secs/2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Fade out, but not completely
                         self.alpha = 0.3;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:secs/2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              // Fade in
                                              self.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) {
                                              if (continuously) {
                                                  [self lc_pulse:secs continuously:continuously];
                                              }
                                          }];
                     }];
}
#pragma mark - add subview

- (void)lc_addSubviewWithFadeAnimation:(UIView *)subview {
    
    CGFloat finalAlpha = subview.alpha;
    
    subview.alpha = 0.0;
    [self addSubview:subview];
    [UIView animateWithDuration:0.2 animations:^{
        subview.alpha = finalAlpha;
    }];
}

#pragma mark - bounds center frame

- (CGFloat)bWidth {
    
    return self.bounds.size.width;
    
}

- (void)setBWidth:(CGFloat)bWidth {
    
    CGRect bounds = self.bounds;
    bounds.size.width = bWidth;
    self.bounds = bounds;
    
}

- (CGFloat)bHeight {
    
    return self.bounds.size.height;
    
}

- (void)setBHeight:(CGFloat)bHeight {
    
    CGRect bounds = self.bounds;
    bounds.size.height = bHeight;
    self.bounds = bounds;
    
}

- (CGSize)bSize {
    
    return self.bounds.size;
    
}

- (void)setBSize:(CGSize)bSize {
    
    CGRect bounds = self.bounds;
    bounds.size = bSize;
    self.bounds = bounds;
    
}

- (CGFloat)cX {
    
    return self.center.x;
    
}

- (void)setCX:(CGFloat)cX {
    
    CGPoint center = self.center;
    center.x = cX;
    self.center = center;
    
}

- (CGFloat)cY {
    
    return self.center.y;
    
}

- (void)setCY:(CGFloat)cY {
    
    CGPoint center = self.center;
    center.y = cY;
    self.center = center;
    
}

- (CGFloat)fX {
    
    return self.frame.origin.x;
    
}

- (void)setFX:(CGFloat)fX {
    
    CGRect frame = self.frame;
    frame.origin.x = fX;
    self.frame = frame;
    
}

- (CGFloat)fY {
    
    return self.frame.origin.y;
    
}

- (void)setFY:(CGFloat)fY {
    
    CGRect frame = self.frame;
    frame.origin.y = fY;
    self.frame = frame;
    
}

- (CGFloat)fWidth {
    
    return self.frame.size.width;
    
}

- (void)setFWidth:(CGFloat)fWidth {
    
    CGRect frame = self.frame;
    frame.size.width = fWidth;
    self.frame = frame;
    
}

- (CGFloat)fHeight {
    
    return self.frame.size.height;
    
}

- (void)setFHeight:(CGFloat)fHeight {
    
    CGRect frame = self.frame;
    frame.size.height = fHeight;
    self.frame = frame;
    
}

- (CGPoint)fOrigin {
    
    return self.frame.origin;
    
}

- (void)setFOrigin:(CGPoint)fOrigin {
    
    CGRect frame = self.frame;
    frame.origin = fOrigin;
    self.frame = frame;
    
}

- (CGSize)fSize {
    
    return self.frame.size;
    
}

- (void)setFSize:(CGSize)fSize {
    
    CGRect frame = self.frame;
    frame.size = fSize;
    self.frame = frame;
    
}

@end
