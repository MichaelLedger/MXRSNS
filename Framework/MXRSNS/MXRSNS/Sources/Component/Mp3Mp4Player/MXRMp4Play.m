//
//  MXRMp4Play.m
//  huashida_home
//
//  Created by zhenyu.wang on 15-3-3.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "MXRMp4Play.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MXRConstant.h"

@interface MXRMp4Play ()

@property (copy,   nonatomic) StopCallBackForMp4        stopCallBack;
@property (strong, nonatomic) NSString                  *mp4Path;
@property (assign, nonatomic) NSTimeInterval            startTime;
@property (assign, nonatomic) NSTimeInterval            endTime;

@end

@implementation MXRMp4Play{
    BOOL     isPlaying;
}

+ (id)shareMp4PlayManager {
    static MXRMp4Play * mp4 = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        mp4 = [[MXRMp4Play alloc] init];
    });
    
    return mp4;
}

- (BOOL)isHeFaMp4:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end{
    self.mp4Path        = filePath;
    self.startTime      = start;
    self.endTime        = end;
    //判断播放时长是否合法
    if (start > end && end != -1){
        [MXRConstant showAlert:@"当前视频配置错误" andShowTime:2.0f];
        return NO;
    }else{
        return YES;
    }
}
//必须要先调用 isHeFaMp4设置endtime
- (void)playMp4OnView:(UIView *)parentView  andPath:(NSString *)filePath stopCallBack:(StopCallBackForMp4)callBack {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self playMp4OnView:parentView url:url stopCallBack:callBack];
}

- (void)playMp4OnView:(UIView *)parentView  url:(NSURL *)url stopCallBack:(StopCallBackForMp4)callBack{
    self.mp4Path = [url absoluteString];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:self.mp4Path] && ! playerItem ) {
        [self notifyMp3IsStoped];
        return;
    }
    self.stopCallBack   = callBack;
    
    if ( self.avPlayer ) {
        NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
        [nfc removeObserver:self];
        [self notifyMp3IsStoped];
        [self.avPlayer pause];
        isPlaying = NO;
        _avPlayer = nil;
        [_playerLayer removeFromSuperlayer];
    }
    
    _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _playerLayer.frame = parentView.layer.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [parentView.layer addSublayer:_playerLayer];
    [_avPlayer seekToTime:CMTimeMake(self.startTime, 1)];
    if (self.endTime != -1) {
        playerItem.forwardPlaybackEndTime = CMTimeMake(self.endTime, 1);
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    [self play];
    isPlaying = YES;
}



- (NSTimeInterval)getCurrentVideoDuration{
    NSURL * musicURL= [[NSURL alloc] initFileURLWithPath:self.mp4Path];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
    return asset.duration.value / asset.duration.timescale;
}

- (NSTimeInterval)getCurrentVideoCurrentPlaybackTime{
    CMTime currentTime = _avPlayer.currentItem.currentTime;
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
    return currentPlayTime;
}


- (void)notifyMp3IsStoped {
    NSDictionary * dict = @{@"filePath":self.mp4Path?:@"",
                            @"start":@(self.startTime),
                            @"end":@(self.endTime)};
    if ( self.stopCallBack ) {
        self.stopCallBack(dict);
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)noti {
    _avPlayer = nil;
    [_playerLayer removeFromSuperlayer];
    isPlaying = NO;
    self.playStatus = Pause;
    NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
    [nfc removeObserver:self];
    [self notifyMp3IsStoped];
}

- (void)playCurrentMp3Mp4{
    if ([self videoPlaying]) {
        [self pausePlay];
        isPlaying = NO;
    }else{
        if (!_avPlayer) {
            NSURL *url = [NSURL fileURLWithPath:self.mp4Path];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [_avPlayer seekToTime:CMTimeMake(self.startTime, 1)];
            if ( self.endTime != -1) {
                playerItem.forwardPlaybackEndTime = CMTimeMake(self.endTime, 1);
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        }
        [_avPlayer seekToTime:CMTimeMake(self.startTime, 1)];
        [self play];
        isPlaying = YES;
    }
}

- (BOOL)videoPlaying{
    if (_avPlayer.currentItem.status == MPMoviePlaybackStatePlaying || isPlaying) {
        return YES;
    }
    return NO;
}

- (void)play{
    [_avPlayer play];
    self.playStatus = Playing;
}

- (void)stopPlay {
    if (isPlaying) {
        [self pausePlay];
        isPlaying = NO;
        _avPlayer = nil;
        [_playerLayer removeFromSuperlayer];
        NSNotificationCenter * nfc = [NSNotificationCenter defaultCenter];
        [nfc removeObserver:self];
    }
}

- (void)pausePlay{
    if (self.playStatus != Pause ) {
        [_avPlayer pause];
        self.playStatus = Pause;
    }
}

@end
