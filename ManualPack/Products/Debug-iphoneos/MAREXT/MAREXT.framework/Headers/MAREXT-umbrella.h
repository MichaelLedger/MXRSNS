#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MARCategory.h"
#import "MARColorArt.h"
#import "MARDebug.h"
#import "MARSystemSound.h"
#import "MARTouchID.h"
#import "MARXMLDictionary.h"
#import "NSArray+MAREX.h"
#import "NSData+MAREX.h"
#import "NSData+MAREX_Type.h"
#import "NSDate+MAREX.h"
#import "NSDictionary+MAREX.h"
#import "NSFileManager+MAREX.h"
#import "NSMutableArray+MAREX.h"
#import "NSNotificationCenter+MAREX.h"
#import "NSNumber+MAREX.h"
#import "NSObject+DLIntrospection.h"
#import "NSObject+MAREX.h"
#import "NSObject+MAR_Observer.h"
#import "NSProcessInfo+MAREX.h"
#import "NSString+MAREX.h"
#import "NSString+MAREX_Regex.h"
#import "NSTimer+MAREX.h"
#import "MARClassInfo.h"
#import "NSObject+MARModel.h"
#import "CALayer+MAREX.h"
#import "MARCGUtilities.h"
#import "MARIvar.h"
#import "MARMethod.h"
#import "MARProperty.h"
#import "MARRunimeOBJ.h"
#import "MARUnregisteredClass.h"
#import "MARLabel.h"
#import "MARUIButton.h"
#import "MARUITextView.h"
#import "UIApplication+MAREX.h"
#import "UIBarButtonItem+JKBadge.h"
#import "UIBarButtonItem+MAREX.h"
#import "UIBezierPath+MAREX.h"
#import "UIButton+MAREX.h"
#import "UIColor+MAREX.h"
#import "UIControl+MAREX.h"
#import "UIDevice+MAREX.h"
#import "UIFont+MAREX.h"
#import "UIGestureRecognizer+MAREX.h"
#import "UIImage+MAREX.h"
#import "UINavigationController+MAREX.h"
#import "UIResponder+MAREX.h"
#import "UIScrollView+MAREX.h"
#import "UITextField+MAREX.h"
#import "UIView+MAREX.h"
#import "UIWindow+MAREX.h"
#import "MAREXMacro.h"
#import "MARGlobalManager.h"
#import "MARReachability.h"
#import "MARUserDefault.h"
#import "MARWeakProxy.h"
#import "SVProgressHUD+MAREX.h"

FOUNDATION_EXPORT double MAREXTVersionNumber;
FOUNDATION_EXPORT const unsigned char MAREXTVersionString[];

