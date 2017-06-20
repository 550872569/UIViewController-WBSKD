//
//  UIViewController+WBSKD.m
//  AudioNote
//
//  Created by sogou-Yan on 2017/6/20.
//  Copyright © 2017年 YY. All rights reserved.
//

#import "UIViewController+WBSKD.h"
#import <objc/message.h>

@implementation UIViewController (WBSKD)

#pragma mark - NSObject Class Methods
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
        Method targetMethod = class_getInstanceMethod(self, @selector(_weibo_fix_presentViewController:animated:completion:));
        method_exchangeImplementations(originMethod, targetMethod);
    });
}

#pragma mark - Private Methods
- (void)_weibo_fix_presentViewController:(UIViewController *)viewControllerToPresent
                                animated:(BOOL)flag
                              completion:(void (^)(void))completion {
    // determine if the class name prefix is for the weibo SDK and be safe to make sure the length
    NSString * weiboSDKPrefix = @"WBSDK";
    NSString * className = [self classNameFromViewControllerToPresent:viewControllerToPresent];
    if ( className.length >= weiboSDKPrefix.length ) {
        NSString * prefix = [[className substringWithRange:NSMakeRange(0, weiboSDKPrefix.length)] uppercaseString];
        if ( [prefix isEqualToString:weiboSDKPrefix]) {
            UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
            [rootVC  _weibo_fix_presentViewController:viewControllerToPresent
                                             animated:flag
                                           completion:completion];
            return;
        }
    }
    [self _weibo_fix_presentViewController:viewControllerToPresent animated:flag completion:completion];
}
- (NSString *)classNameFromViewControllerToPresent:(UIViewController *)viewController {
    if ( [viewController isKindOfClass:[UINavigationController class]] ) {
        return [self classNameFromViewControllerToPresent:((UINavigationController *)viewController).topViewController];
    }
    return NSStringFromClass([viewController class]);
}

@end
