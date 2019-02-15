//
//  MainTabBarController.m
//  CYLTabBarController
//
//  v1.16.0 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//
#import "MainTabBarController.h"
#import <UIKit/UIKit.h>

static CGFloat const CYLTabBarControllerHeight = 40.f;

@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end

//View Controllers
#import "MatchFriendVC.h"
//#import "ForumVC.h"
#import "ForumMainVC.h"
#import "IMVC.h"
#import "DCIMChatListViewController.h"

#import "MineVC.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabBarController

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                               tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                         imageInsets:imageInsets
                                                                             titlePositionAdjustment:titlePositionAdjustment
                                                                                             context:nil
                                             ];
    [self customizeTabBarAppearance:tabBarController];
    return (self = (MainTabBarController *)tabBarController);
}

- (NSArray *)viewControllers {
    MatchFriendVC *firstViewController = [[MatchFriendVC alloc] init];
    firstViewController.momentRequestType = MomentRequestTypeUnknow;
    UIViewController *firstNavigationController = [[CYLBaseNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    ForumMainVC *secondViewController = [[ForumMainVC alloc] init];
    UIViewController *secondNavigationController = [[CYLBaseNavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    DCIMChatListViewController *thirdViewController = [[DCIMChatListViewController alloc] init];
    UIViewController *thirdNavigationController = [[CYLBaseNavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    MineVC *fourthViewController = [[MineVC alloc] init];
    UIViewController *fourthNavigationController = [[CYLBaseNavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    CGFloat firstXOffset = -12/2;
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"home_normal",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"home_highlight",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(firstXOffset, -3.5)]
                                                 //第一位 右大，下大
                                                 };
    CGFloat secondXOffset = (-25+2)/2;
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"鱼塘",
                                                  CYLTabBarItemImage : @"fishpond_normal",
                                                  CYLTabBarItemSelectedImage : @"fishpond_highlight",
                                                  CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(secondXOffset, -3.5)]
                                                  };
    
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"消息",
                                                 CYLTabBarItemImage : @"message_normal",
                                                 CYLTabBarItemSelectedImage : @"message_highlight",
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(-secondXOffset, -3.5)]
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"account_normal",
                                                  CYLTabBarItemSelectedImage : @"account_highlight",
                                                  CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(-firstXOffset, -3.5)]
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    //    tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
     [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
    // remove the comment '//'
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
     [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    //        [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    
    //FIXED:  https://github.com/ChenYilong/CYLTabBarController/issues/312
    [UITabBar appearance].translucent = NO;
    //FIXED: https://github.com/ChenYilong/CYLTabBarController/issues/196
    NSString *tabBarBackgroundImageName = @"tabbarBg";
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:tabBarBackgroundImageName];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage];
    [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    CGFloat tabBarHeight = CYLTabBarControllerHeight;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor whiteColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)scaleImage:(UIImage *)image {
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    UIImage *secondStrechImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    return secondStrechImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
