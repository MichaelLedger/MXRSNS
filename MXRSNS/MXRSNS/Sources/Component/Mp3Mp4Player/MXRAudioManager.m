//
//  MXRAudioManager.m
//  ZJS_AudioAndVideo
//
//  Created by 周建顺 on 15/12/31.
//  Copyright © 2015年 周建顺. All rights reserved.
//

#import "MXRAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MXRUserSettingsManager.h"

@interface MXRAudioManager()<AVAudioPlayerDelegate>

@property (nonatomic,copy) MXRAudioStopCallBack stopCallback;
@property (nonatomic,copy) NSString *filePath;
@property (assign, nonatomic) NSTimeInterval            startTime;
@property (assign, nonatomic) NSTimeInterval            endTime;

@property (nonatomic) NSTimer *timer;

@property (nonatomic,strong)     AVAudioPlayer *audioPlayer;



@end

@implementation MXRAudioManager

+(id)shareAudioPlayManager{
    static dispatch_once_t onceToken;
    static MXRAudioManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MXRAudioManager alloc] init];
    });
    
    return instance;
}

-(void)initAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(MXRAudioStopCallBack)callBack{
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {

        [self audioStopedAtError];
        return;
    }
    
    if ((end > start)&&(start>0)) {
        self.startTime      = start;
        self.endTime        = end;
    }else{
        self.startTime      = 0;
        self.endTime        = 0;
    }
    
    
    self.filePath = filePath;

    self.stopCallback   = callBack;
    
    // 清理资源
    if (self.audioPlayer) {
        if (self.audioPlayer.isPlaying) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
    [self stopTimer];
    
    // 创建新的player
    [self createAudioPlayer:self.filePath];

}

-(void)playAudio:(NSString *)filePath startAt:(NSTimeInterval)start endOf:(NSTimeInterval)end stopCallBack:(MXRAudioStopCallBack)callBack{
    
    [self initAudio:filePath startAt:start endOf:end stopCallBack:callBack];
    [self playCurrentAudio];
}



/**
 播放当前音频
 */
-(void)playCurrentAudio{
    if (!self.audioPlayer) {
        // 创建新的player
        [self createAudioPlayer:self.filePath];
    }
    if (self.isPlaying) {
        
    }else{
        [self startTimer];
        [self.audioPlayer play];
        
    }
    if (self.audioStatusChangedBlock) {
        self.audioStatusChangedBlock(self, MXRAudioStatusStartPlay);
    }
}


/**
 暂停当前音频
 */
-(void)pausePlay{
    if (self.isPlaying) {
        [self stopTimer];
        [self.audioPlayer pause];

    }else{
       
    }
    if (self.audioStatusChangedBlock) {
        self.audioStatusChangedBlock(self, MXRAudioStatusPause);
    }
}


/**
 停止播放
 */
-(void)stopPlay{
    [self stopPlayIsSuccess:NO];
}

#pragma mark - getter and setter

-(BOOL)isPlaying{

    return self.audioPlayer.isPlaying;
}

-(NSTimeInterval)duration{
    if (self.endTime > self.startTime) {
        return self.endTime - self.startTime;
    }
    return self.audioPlayer.duration;
}

-(NSTimeInterval)currentTime{
    
    return self.audioPlayer.currentTime - self.startTime;
}


-(void)setCurrentTime:(NSTimeInterval)currentTime{
   
    self.audioPlayer.currentTime = currentTime + self.startTime;
 
    //[self startTime];
}

#pragma mark 私有方法


/**
 开始计时器，在指定时间停止播放音频
 */
-(void)startTimer{
    [self stopTimer];

    if (self.endTime > self.startTime ) {
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:(self.endTime - self.audioPlayer.currentTime) target:self selector:@selector(stopAtEndTime) userInfo:nil repeats:NO];
     
    }else{
           self.timer =  [NSTimer scheduledTimerWithTimeInterval:(self.audioPlayer.duration  - self.audioPlayer.currentTime) target:self selector:@selector(stopAtEndTime) userInfo:nil repeats:NO];
    }
}


/**
 停止计时器
 */
-(void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 计时器到了，停止播放
-(void)stopAtEndTime{
    [self stopPlayIsSuccess:YES];
}

// 出错时的回调
-(void)audioStopedAtError{
  
    [self stopTimer];
    if (self.stopCallback) {
        self.stopCallback(self,NO,nil);
    }
}

-(void)stopPlayIsSuccess:(BOOL)isSuccess{
    
    if (self.audioPlayer) {
        
        [self stopTimer];
        
        if (self.isPlaying) {
            
            [self.audioPlayer stop];
            self.audioPlayer.currentTime = self.startTime;
        }

        if (self.stopCallback) {
            self.stopCallback(self,isSuccess,nil);
        }
        
    }
    
    if (self.audioStatusChangedBlock) {
        self.audioStatusChangedBlock(self, MXRAudioStatusStop);
    }
}

-(void)createAudioPlayer:(NSString *)filePath{
    
    NSURL *url=[NSURL fileURLWithPath:filePath];
    NSError *error=nil;
    //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    //设置播放器属性
    self.audioPlayer.numberOfLoops=0;//设置为0不循环
    self.audioPlayer.delegate=self;
    
    if(error){
        DLOG(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
    
    [self.audioPlayer prepareToPlay];//加载音频文件到缓存
    
    self.audioPlayer.currentTime = self.startTime;
    
    
    MXRARServerType type = [[MXRUserSettingsManager defaultManager] getServerType];
    switch (type) {
        case MXRARServerTypeOuterNetFormalReview:
        {
            self.audioPlayer.enableRate = YES;
            self.audioPlayer.rate = [MXRUserSettingsManager defaultManager].audioRate>2?2:[MXRUserSettingsManager defaultManager].audioRate;
        }
            break;
        default:
            break; //默认为正式
    }
    

}


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    if (self.stopCallback) {
//        self.stopCallback(self,flag,nil);
//    }
    DLOG_METHOD
}


@end
