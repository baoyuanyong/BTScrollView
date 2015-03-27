




#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define is4InchScreen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIOS7    ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define isIOS6    ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)

#define kScreenBound     [[UIScreen mainScreen] bounds]
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]


#define kNavigationBarFrame  CGRectMake(0,0,kScreenBound.size.width,44)

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#define kRootViewTag   100
