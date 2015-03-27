//
//  BanJiaCoreUIConstant.h
//  Test_Test
//


#ifndef BanJiaCoreUI_BanJiaCoreUIConstant_h
#define BanJiaCoreUI_BanJiaCoreUIConstant_h


#define kControllerSuffix @"Controller"
//
#define GL_RELEASE(__POINTER) { [__POINTER release]; }
#define GL_RELEASE_SAFELY(__POINTER) { if(__POINTER != nil) [__POINTER release]; __POINTER = nil; }
// device
#define GL_IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO)
//
#define FONTSYS(size) ([UIFont systemFontOfSize:(size)])
#define FONTBOLDSYS(size) ([UIFont boldSystemFontOfSize:(size)])
//
#pragma mark Color宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//
#define GL_IMAGE(name) [UIImage imageNamed:(name)]


// Nav
#define kHeight_Navigation      44
#define kHeight_Status          20
#define kHeight_Line            0.5


#define HTTP_TRACE_SWITCH

#endif
