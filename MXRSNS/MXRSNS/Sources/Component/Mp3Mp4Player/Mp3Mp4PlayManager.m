//
//  Mp3PlayManager.m
//  测试按段播放mp3
//
//  Created by bin.yan on 15-2-15.
//  Copyright (c) 2015年 bin.yan. All rights reserved.
//

#import "Mp3Mp4PlayManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MXRConstant.h"
//#import "UnityAppController.h"
#import "MXRUserSettingsManager.h"
//#import "MXRUnityMessageHelper.h"

@interface Mp3Mp4PlayManager ()

@property (copy,   nonatomic) StopCallBack              stopCallBack;
@property (assign, nonatomic) NSTimeInterval            startTime;
@property (assign, nonatomic) NSTimeInterval            endTime;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, strong) id observer;

@end
@implementation Mp3Mp4PlayManager{
    BOOL     isPlaying;
}
+ (id)shareMp3PlayManager {
    static Mp3Mp4PlayManager * mp3 = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        mp3 = [[Mp3Mp4PlayManager alloc] init];
    });
    
    return mp3;
}


- (void)playMp3:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end onView:(UIView *)parentView startCallBack:(StartCallBack)startCallBack stopCallBack:(StopCallBack)callBack{
    //    NSAssert((end > start), @"结束时间必须大于开始时间");
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        DERROR(@"文件不存在=%@",filePath);
        [self notifyMp3IsStoped];
        return;
    }
    self.mp3Path        = filePath;
    self.startTime      = start;
    self.endTime        = end;
    self.stopCallBack   = callBack;
    
    
    if (start > end && end != -1){
        [MXRConstant showAlert:@"当前音频配置错误" andShowTime:2.0f];
        [self notifyMp3IsStoped];
        return;
    }
    
   
    [self removeObservers];
    
    if ( self.moviePlayer ) {
        //        [self notifyMp3IsStoped];
        [self.moviePlayer stop];
        isPlaying = NO;
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;
    }
    
    NSURL * url = nil;
    if ([filePath rangeOfString:@"http://"].length > 0)
    {
        url = [NSURL URLWithString:filePath];
    }
    else
    {
        url = [NSURL fileURLWithPath:filePath];
    }
    
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];

    if ( self.isLoop ) {
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    }
    self.moviePlayer.initialPlaybackTime = start;
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeOuterNetFormalReview:
        {
            self.moviePlayer.currentPlaybackRate = [MXRUserSettingsManager defaultManager].audioRate;
        }
            break;
        default:
            break; //默认为正式
    }
    

    
    // 需要显示播放的内容
    if ( parentView ) {
        [self.moviePlayer.view setFrame:parentView.bounds];
        [parentView addSubview:self.moviePlayer.view];
    }
    
    NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
    [nfc addObserver:self selector:@selector(mp3PlayDidStop:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    //V5.9.5 监听播放状态改变
    [nfc addObserver:self selector:@selector(mp3PlayStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    if (startCallBack) {
        startCallBack(self);
    }
    
    [self.moviePlayer prepareToPlay];
    //if (IOS9_OR_LATER) {
    if ( end != -1 )
    {
        [self.moviePlayer setCurrentPlaybackTime:self.startTime];
        //ios9 需要加一下代码来代替 initialPlaybackTime
       self.observer = [nfc addObserverForName:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          
                                                          if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                                                              [self.moviePlayer setCurrentPlaybackTime:self.startTime];
                                                              //[self.moviePlayer setEndPlaybackTime:end];
                                                          }
                                                          
                                                      }];
        
        [self.moviePlayer play];
        //ios 9需要加来代替 endPlaybackTime
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.endTime - self.startTime) target:self selector:@selector(stop) userInfo:nil repeats:NO];
    }else{
        [self.moviePlayer play];
    }
    //    }else{
    //
    //        if ( end != -1 )
    //        {
    //            self.moviePlayer.endPlaybackTime     = end;
    //        }
    //    }
    
   


    
    isPlaying = YES;

}

- (void)playMp3:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end onView:(UIView *)parentView stopCallBack:(StopCallBack)callBack {
    [self playMp3:filePath startAt:start endOf:end onView:parentView startCallBack:nil stopCallBack:callBack];
    
}

-(void)stateChanged{
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self.moviePlayer setCurrentPlaybackTime:self.startTime];
        //[self.moviePlayer setEndPlaybackTime:end];
    }
}

-(void)removeObservers{
    NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
    [nfc removeObserver:self];
    if (self.observer) {
        [nfc removeObserver:self.observer];
        self.observer = nil;
    }
}
- (void)stop{

    [self.timer invalidate];
    self.timer = nil;
    [self.moviePlayer stop];
}
- (void)notifyMp3IsStoped {
    [self.timer invalidate];
    self.timer = nil;
    self.currentActionID = nil;
//    NSDictionary * dict = @{@"filePath":self.mp3Path,
//                            @"start":@(self.startTime),
//                            @"end":@(self.endTime)};
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.mp3Path.length > 0) {
        [dict setObject:self.mp3Path forKey:@"filePath"];
    }
    [dict setObject:@(self.startTime) forKey:@"start"];
    [dict setObject:@(self.endTime) forKey:@"end"];
    
    if(self.stopCallBack){
       self.stopCallBack(dict);
    }
}

- (void)mp3PlayDidStop:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BookReading_AudioStateNoti object:self.moviePlayer];
//    UnityAppController *appAR = [UnityAppController getInstance];
//    if (appAR && [appAR isUnityScheduled]) {
//        //当扫一扫unity播放视频后需要告诉unity再次进入扫一扫界面
//        [MXRUnityMessageHelper unityEnableWordRecognitionEvent];
//        //停止音频的动画
//        [MXRUnityMessageHelper unityStopAllAudioAnimation];
//    }
    isPlaying = NO;
    [self removeObservers];
    [self notifyMp3IsStoped];
}

#pragma mark - 播放状态改变 V5.9.5 by MT.X
- (void)mp3PlayStateDidChange:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BookReading_AudioStateNoti object:self.moviePlayer];
}

- (void)playCurrentMp3{
    if ([self videoPlaying]) {
        [self pausePlay];
    }else{
        if (!self.moviePlayer) {
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.mp3Path]];
            self.moviePlayer.initialPlaybackTime = self.startTime;
            self.moviePlayer.endPlaybackTime     = self.endTime ;
            [self.moviePlayer setCurrentPlaybackTime:self.startTime];
        }
        __block NSTimeInterval startTime = self.moviePlayer.currentPlaybackTime;
        if ( self.endTime != -1 )
        {
            // 分段阅读
            if (!self.timer) {
                startTime = self.startTime;
            }else{
                
            }
        }else{
          
        }
       
        
        [self removeObservers];
        NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
        [nfc addObserver:self selector:@selector(mp3PlayDidStop:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        self.observer = [nfc addObserverForName:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          
                                                          if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                                                              [self.moviePlayer setCurrentPlaybackTime:startTime];
                                                              //[self.moviePlayer setEndPlaybackTime:end];
                                                          }
                                                          
                                                      }];
        //V5.9.5 监听播放状态改变
        [nfc addObserver:self selector:@selector(mp3PlayStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];

        [self.moviePlayer play];

        
        if ( self.endTime != -1 )
        {
            // 分段阅读
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.endTime - startTime) target:self selector:@selector(stop) userInfo:nil repeats:NO];
            }else{
                self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.endTime - startTime) target:self selector:@selector(stop) userInfo:nil repeats:NO];
            }
        }else{
            self.timer.fireDate = [NSDate distantPast];//恢复定时器
        }
        
//            DLOG(@"playCurrentMp3 currentPlaybackTime:%@",@(self.moviePlayer.currentPlaybackTime));
        isPlaying = YES;
    }
}

- (BOOL)videoPlaying{
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying || isPlaying) {
        return YES;
    }
    return NO;
}

- (void)stopPlay {
    [self.moviePlayer stop];
    //V5.19.0 先停止播放再移除观察者，避免通知无法发送 (修复bug5715) by MT.X
    [self removeObservers];
    self.moviePlayer = nil;
    [self.timer invalidate];
    self.timer = nil;
    
    
    if (isPlaying) {
        isPlaying = NO;
        if(self.stopCallBack){
            self.stopCallBack(nil);
        }

    }

}

-(void)pausePlay{
    //V5.9.5提前以获取暂停通知
    [self.moviePlayer pause];
    
    [self removeObservers];
    
//    DLOG(@"pausePlay currentPlaybackTime:%@",@(self.moviePlayer.currentPlaybackTime));
//    self.moviePlayer = nil;
//    [self.timer invalidate];
//    self.timer = nil;
    self.timer.fireDate = [NSDate distantFuture];
    
    if (isPlaying) {
        isPlaying = NO;
        //V5.9.5 暂停不统计&赠送梦想币
//        if(self.stopCallBack){
//            self.stopCallBack(nil);
//        }
    }
}

- (float)getCurrentMp3Duration{
    NSURL * musicURL= [[NSURL alloc] initFileURLWithPath:self.mp3Path];
    
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    if(play){
        NSData * urlData = [[NSData alloc] initWithContentsOfFile:self.mp3Path];
        play = [[AVAudioPlayer alloc] initWithData:urlData error:nil];
    }
    return play.duration;
}

@end
