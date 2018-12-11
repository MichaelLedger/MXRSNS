//
//  Mp3Mp4PlayManager.h
//  按段播放mp3 mp4
//
//  Created by bin.yan on 15-2-15.
//  Copyright (c) 2015年 bin.yan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

// 播放音效 小于30s
// 音频播放时间不能超过30s
// 数据必须是PCM或者IMA4格式
// 音频文件必须打包成.caf.aif、.wav中的一种（注意这是官方文档的说法，实际测试发现一些.mp3也可以播放）
#define PlaySystemSound(filePath)  {NSURL *fileUrl=[NSURL fileURLWithPath:filePath];\
SystemSoundID soundID=0; \
AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID); \
AudioServicesPlaySystemSound(soundID);}

#define PlaySystemSoundWithCompletion(filePath,soundCompleteCallback)  {NSURL *fileUrl=[NSURL fileURLWithPath:filePath];\
SystemSoundID soundID=0; \
AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID); \
AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);\
AudioServicesPlaySystemSound(soundID);}

@class MPMoviePlayerController;
@class Mp3Mp4PlayManager;

typedef void(^StopCallBack)(NSDictionary *);
typedef void(^StartCallBack)(Mp3Mp4PlayManager *);

@interface Mp3Mp4PlayManager : NSObject

+ (id)shareMp3PlayManager;
- (void)playMp3:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end onView:(UIView *)parentView stopCallBack:(StopCallBack)callBack;
- (void)playMp3:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end onView:(UIView *)parentView startCallBack:(StartCallBack)startCallBack stopCallBack:(StopCallBack)callBack;

- (void)playCurrentMp3;
- (BOOL)videoPlaying;
- (void)stopPlay;
- (void)pausePlay;
- (void)stop;
- (float)getCurrentMp3Duration;
@property (nonatomic) NSString *currentActionID;
@property (strong, nonatomic) MPMoviePlayerController * moviePlayer;
@property (strong, nonatomic) NSString                * mp3Path;
@property (assign, nonatomic) BOOL                      isLoop; // 是否重复播放
@property (strong, nonatomic) UIButton                *previousVideoBtn; // 之前播放的按钮
@end
