
// XMGConst.m ：定义所有的全局常量

#import <UIKit/UIKit.h>

/** 请求路径 */
NSString * const XQRequestURL = @"http://api.budejie.com/api/api_open.php";

/** 统一的间距 */
CGFloat const XQCommonMargin = 10;

/** 统一较小的间距 */
CGFloat const XQCommonSmallMargin = 5;

/** 导航栏最大的Y值 */
CGFloat const XQNavBarMaxY = 64;

/** UITabBar的高度 */
CGFloat const XQTabBarH = 49;

/** TitlesView的高度 */
CGFloat const XQTitlesViewH = 35;

/** TabBar按钮重复点击的通知 */
NSString * const XQTabBarButtonDidRepeatClickNotification = @"XQTabBarButtonDidRepeatClickNotification";

/** titleView按钮重复点击的通知 */
NSString * const XQTitleButtonDidRepeatClickNotification = @"XQTitleButtonDidRepeatClickNotification";

/** 性别-男 */
NSString * const XQUserSexMale = @"m";

/** 性别-女 */
NSString * const XQUserSexFemale = @"f";
