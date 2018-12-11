//
//  UIViewController+MXROneMinuteDataAnalysis.m
//  huashida_home
//
//  Created by Martin.Liu on 2018/7/16.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "UIViewController+MXROneMinuteDataAnalysis.h"
#import <objc/runtime.h>
#import "MXROneMinuteDataAnalysis.h"
typedef NS_ENUM(NSInteger, MXRDataAnalysisVCType) {
    MXRDataAnalysisVCTypeVCTypeNone         = 0,
    MXRDataAnalysisVCTypeVCTypeGather       = 1,
    MXRDataAnalysisVCTypeVCTypeNotGather    = 2,
};

@interface UIViewController ()
@property (nonatomic, assign) MXRDataAnalysisVCType analysisType;
@property (nonatomic, strong) MXROneMinuteItemModel *oneMinuteItemModel;
@end

static char analysisTypeKey;

@implementation UIViewController (MXROneMinuteDataAnalysis)

// load to swizz method
+ (void)load
{
    if (APPCURRENTTYPE == MXRAppTypeBookCity) {
        [self mxr_swizzleInstanceMethod:@selector(viewWillAppear:) with:@selector(mxr_viewWillAppear:)];
        [self mxr_swizzleInstanceMethod:@selector(viewWillDisappear:) with:@selector(mxr_viewWillDisappear:)];
    }
}

// swizzed method
- (void)mxr_viewWillAppear:(BOOL)animated
{
    [self mxr_viewWillAppear:animated];
    if ([MXROneMinuteDataAnalysis isInAnalysisTime]) {
        if ([self needAnalysisClass]) {
            [MXROneMinuteDataAnalysis addItemData:self.oneMinuteItemModel];
            self.oneMinuteItemModel.name = NSStringFromClass(self.class);
        }
    }
}

- (void)mxr_viewWillDisappear:(BOOL)animated
{
    [self mxr_viewWillDisappear:animated];
    if ([MXROneMinuteDataAnalysis isInAnalysisTime]) {
        if ([self needAnalysisClass]) {
            self.oneMinuteItemModel.endTimeInterval = [[NSDate new] timeIntervalSince1970];
            self.oneMinuteItemModel.duration = self.oneMinuteItemModel.endTimeInterval - self.oneMinuteItemModel.startTimeInterval;
            self.oneMinuteItemModel.name = NSStringFromClass(self.class);
        }
    }
}

// used to swizz methods
+ (BOOL)mxr_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

// association
- (MXRDataAnalysisVCType)analysisType
{
    return [objc_getAssociatedObject(self, &analysisTypeKey) integerValue];
}

- (void)setAnalysisType:(MXRDataAnalysisVCType)analysisType
{
    objc_setAssociatedObject(self, &analysisTypeKey, @(analysisType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char oneMinuteItemModelKey;

- (MXROneMinuteItemModel *)oneMinuteItemModel
{
    MXROneMinuteItemModel *model = objc_getAssociatedObject(self, &oneMinuteItemModelKey);
    if (!model) {
        model = [MXROneMinuteItemModel new];
        model.type = @"page";
        model.name = NSStringFromClass(self.class);
        objc_setAssociatedObject(self, &oneMinuteItemModelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return model;
}

#pragma mark - custom Method
- (BOOL)needAnalysisClass
{
    NSArray *clazzNameArray = [MXROneMinuteDataAnalysis sharedInstance].vcClazzDict.allKeys;
    if ([clazzNameArray containsObject:[NSString stringWithFormat:@"%@", self.class]]) {
        return YES;
    }
    return NO;
//
//    NSArray *ignoreClasses = @[UINavigationController.class,
//                               UITabBarController.class,
//                               UIPageViewController.class,
//                               UISplitViewController.class,
//                               UIDocumentMenuViewController.class,
//                               UIDocumentPickerViewController.class,
//                               UIInputViewController.class,
//                               UIActivityViewController.class,
//                               UIReferenceLibraryViewController.class,
//                               UIAlertController.class,
//                               UISearchController.class,
//                               ];
//    switch (self.analysisType) {
//        case MXRDataAnalysisVCTypeVCTypeNone:
//            {
//                Class clazz = self.class;
//                const char *imagePathC = class_getImageName(clazz);
//                if (imagePathC) {
//                    NSString *imagePath = [NSString stringWithCString:imagePathC encoding:NSUTF8StringEncoding];
//                    if ([imagePath containsString:@"4dBookCity.app/4dBookCity"]) {
//                        for (Class ignoreClazz in ignoreClasses) {
//                            if ([self isKindOfClass:ignoreClazz]) {
//                                self.analysisType = MXRDataAnalysisVCTypeVCTypeNotGather;
//                                return NO;
//                            }
//                        }
//                        return YES;
//                    }
//                }
//                self.analysisType = MXRDataAnalysisVCTypeVCTypeNotGather;
//                return NO;
//            }
//            break;
//        case MXRDataAnalysisVCTypeVCTypeGather:
//            return YES;
//            break;
//        case MXRDataAnalysisVCTypeVCTypeNotGather:
//            return NO;
//            break;
//    }
}

@end
