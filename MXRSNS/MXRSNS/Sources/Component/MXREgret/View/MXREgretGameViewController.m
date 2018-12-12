//
//  MXREgretGameViewController.m
//  huashida_home
//
//  Created by MountainX on 2018/10/17.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXREgretGameViewController.h"
//#import "SSZipArchive.h"
//#import <EgretWebViewLib.h>
#import "EgretWebViewLib.h"
#import <WebKit/WebKit.h>
#import "MXRHeader.h"
//#import "MXREgretGameUpdater.h"
//#import "MXRBuyViewController.h"
#import "MXRNavigationViewController.h"
#import "MXRWebNetworkUrl.h"

@interface MXREgretGameViewController () /*<FileLoaderProtocol>*/

@property (copy, nonatomic) NSString *zipName;
@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *gameUrl;

//@property (nonatomic, strong) MXREgretGameUpdater *updater;

@end

@implementation MXREgretGameViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mxr_preferredNavigationBarHidden = YES;
    self.disablePopGestureRecognizer = YES;

    __weak __typeof(self) selfWeak = self;

    // 直接加载网页
    [self initEgretPreload];
    [self setExternalInterfaces];
    [EgretWebViewLib startGame:ServiceURL_HTML_Egret_Challenge SuperView:selfWeak.view];
}

-(void)dealloc {
    DLOG_METHOD
}

#pragma mark - 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 初始化白鹭引擎
- (void)initEgretPreload {
    [EgretWebViewLib initialize:@"/egretGame/preload/"];
}

#pragma mark - 初始化游戏更新控制器
- (void)setupUpdater {
    _host = @"http://192.168.0.125:10122/egret/";
    _zipName = @"game.zip";
//    _updater = [[MXREgretGameUpdater alloc] initWithHost:_host FileName:_zipName];
}

#pragma mark - 启动游戏
- (void)startGame {
    [self setExternalInterfaces];
    [EgretWebViewLib startLocalServerFromResource];
    [EgretWebViewLib startGame:@"game/index.html" Host:_host SuperView:self.view];
}

#pragma mark - 退出游戏
- (void)exitGame {
    [self.navigationController popViewControllerAnimated:YES];
    [EgretWebViewLib stopAllLoader];
    [EgretWebViewLib stopGame];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [EgretWebViewLib destroy];
    });
}

#pragma mark - 通过ZipFileLoader更新游戏
- (void)updateGameByZipFileLoader {
    @MXRWeakObj(self);
//    [_updater updateWithZipFileLoader:^{
//        [MXRConstant showAlert:@"ZipFileLoader更新游戏完成" andShowTime:1.f];
//        [selfWeak startGame];
//    }];
}

#pragma mark - 手动更新游戏
- (void)updateGameManual {
    @MXRWeakObj(self);
//    [_updater updateCustom:^{
//        [MXRConstant showAlert:@"手动更新游戏完成" andShowTime:1.f];
//        [selfWeak startGame];
//    }];
}

#pragma mark - 清空缓存
- (void)clearGameCache {
    [EgretWebViewLib cleanPreloadDir];
    [MXRConstant showAlert:@"缓存已清空" andShowTime:1.f];
}

#pragma mark - Egret和原生交互
- (void)setExternalInterfaces {
    __weak __typeof(self) selfWeak = self;
    // 返回
    [EgretWebViewLib setExternalInterface:@"goBackToMobile" Callback:^(NSString* msg) {
        [selfWeak exitGame];
    }];
    // 资源加载完毕
    [EgretWebViewLib setExternalInterface:@"resLoaded" Callback:^(NSString *msg) {
        // 请求头
        [EgretWebViewLib callExternalInterface:@"getUserHeader" Value:[MXRHeader createHeader]];
        // 获取用户基本信息
        NSMutableString *userInfoJson = [NSMutableString string];
        if (selfWeak.model == nil) {
            DLOG(@"Error：缺失游戏角色信息！！！");
        } else {
            NSDictionary *userInfo = [selfWeak.model interfaceDict];
            userInfoJson = [[NSMutableString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            //去掉字符串中的空格
            [userInfoJson replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, userInfoJson.length)];
            //去掉字符串中的换行符(不去除JSON无法解析)
            [userInfoJson replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, userInfoJson.length)];
        }
        [EgretWebViewLib callExternalInterface:@"getUserInfo" Value:autoString(userInfoJson)];
    }];
    // 充值
//    [EgretWebViewLib setExternalInterface:@"rechargeMXZ" Callback:^(NSString* msg) {
//        [selfWeak rechargeMXZ];
//    }];
    [EgretWebViewLib setExternalInterface:@"testJson" Callback:^(NSString *msg) {
        [MXRConstant showAlert:autoString(msg) andShowTime:1.f];
    }];
}

#pragma mark - 充值梦想钻
//- (void)rechargeMXZ {
//    MXRBuyViewController *vc = [MXRBuyViewController buyViewController];
//    MXRNavigationViewController *navi = [[MXRNavigationViewController alloc] initWithRootViewController:vc];
//    vc.buyTypeFromPage = MXRBuyTypeFromCourse;
//    vc.isPresent = YES;
//    [[self topViewController] presentViewController:navi animated:YES completion:nil];
//}

#pragma mark - FileLoaderProtocol
- (void)onStart:(long)fileCount Size:(long)totalSize {
    DLOG(@"onStart %ld %ld", fileCount, totalSize);
}

- (void)onProgress:(NSString*)filePath Loaded:(long)loaded Error:(long)error Total:(long)total {
    DLOG(@"onProgress %@ %ld %ld %ld", @"", loaded, error, total);
}

- (void)onError:(NSString*)urlStr Msg:(NSString*)errMsg {
    DLOG(@"onError %@ %@", urlStr, errMsg);
}

- (void)onStop {
    DLOG(@"onStop");
    __weak __typeof(self) selfWeak = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [EgretWebViewLib startLocalServer];
        [EgretWebViewLib startGame:selfWeak.gameUrl SuperView:selfWeak.view];
    });
}

//- (bool)onUnZip:(NSString*)zipFilePath DstDir:(NSString*)dstDir {
//    NSError *error = nil;
//    [SSZipArchive unzipFileAtPath:zipFilePath toDestination:dstDir overwrite:YES password:nil error:&error];
//    if (error) {
//        DLOG(@"==== failed to open zip file at %@\n%@", zipFilePath, error.localizedDescription);
//        return false;
//    } else {
//        DLOG(@"==== unzip Success: %@", zipFilePath);
//        return true;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
