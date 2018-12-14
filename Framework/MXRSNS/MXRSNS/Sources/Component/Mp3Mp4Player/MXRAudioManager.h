

//
//  MXRAudioManager.h
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 15/12/31.
//  Copyright © 2015年 周建顺. All rights reserved.
//

// 原本是用来替换mp3mp4Manager的，但是不知为什么，播放完成的回调不执行，currentTime设置也无效。所以没有替换
#import <Foundation/Foundation.h>
#import "Enums.h"
@class MXRAudioManager;

typedef void(^ MXRAudioStopCallBack)(MXRAudioManager* manager,BOOL isSuccess,NSDictionary *userInfo);
typedef void(^ MXRAudioStatusChangedCallBack)(MXRAudioManager* manager,MXRAudioStatus);

@interface MXRAudioManager : NSObject

@property (nonatomic,readonly,getter=isPlaying) BOOL playing;
@property NSTimeInterval currentTime;
@property(readonly) NSTimeInterval duration; /* the duration of the sound. */
@property (nonatomic, copy) MXRAudioStatusChangedCallBack audioStatusChangedBlock;


+ (id)shareAudioPlayManager;
- (void)initAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(MXRAudioStopCallBack)callBack;
- (void)playAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(MXRAudioStopCallBack)callBack;

- (void)playCurrentAudio;
- (void)stopPlay;
/**
 暂停当前音频
 */
- (void)pausePlay;


@end
