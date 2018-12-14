//
//  MXRMp4Play.h
//  huashida_home
//
//  Created by zhenyu.wang on 15-3-3.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef enum {
    Playing,
    Pause,
    Stop
}AVPlayerPlayStatus;

@class AVPlayer;

typedef void(^StopCallBackForMp4)(NSDictionary *);

@interface MXRMp4Play : NSObject

+ (id)shareMp4PlayManager;

//必须要先调用 isHeFaMp4设置endtime
- (void)playMp4OnView:(UIView *)parentView  andPath:(NSString *)filePath stopCallBack:(StopCallBackForMp4)callBack;
- (void)playMp4OnView:(UIView *)parentView  url:(NSURL *)url stopCallBack:(StopCallBackForMp4)callBack;
- (void)playCurrentMp3Mp4;
- (BOOL)videoPlaying;
- (void)play;
- (void)stopPlay;
- (void)pausePlay;
- (BOOL)isHeFaMp4:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end;
- (NSTimeInterval)getCurrentVideoDuration;
- (NSTimeInterval)getCurrentVideoCurrentPlaybackTime;

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (assign, nonatomic) AVPlayerPlayStatus playStatus;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end
