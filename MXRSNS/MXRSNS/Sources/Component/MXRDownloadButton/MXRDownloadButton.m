//
//  MXRDownloadButton.m
//  huashida_home
//
//  Created by weiqing.tang on 2016/12/7.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRDownloadButton.h"
#import "BookInfoForShelf.h"
//#import "BookShelfManger.h"
#import "JXTProgressLabel.h"


#define BorderWidth 1
@interface MXRDownloadButton()

//@property (nonatomic,strong) UIView  *progressView;

@end

@implementation MXRDownloadButton

#define BTN_WIDTH 60
#define BTN_HEIGHT 22

-(UIView *)createProgressView{
    if ( _progressView == nil )
    {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, BTN_HEIGHT)];
        _progressView.backgroundColor = MXRCOLOR_2FB8E2;
        [self addSubview:_progressView];
        self.progressView.userInteractionEnabled = NO;
        
        //设置按钮的
        self.layer.borderColor = MXRCOLOR_2FB8E2.CGColor;
        self.layer.borderWidth = BorderWidth;
        self.layer.cornerRadius = 11;
        self.layer.masksToBounds = YES;
    }
    return _progressView;
}

-(JXTProgressLabel *)createProgresslable {
    if (!_progresslable) {
        _progresslable = [[JXTProgressLabel alloc] initWithFrame:CGRectMake(0, BorderWidth, self.buttonWidth - BorderWidth*2, self.buttonHeight - BorderWidth*2)];
        _progresslable.font = MXRFONT(11);
        _progresslable.textAlignment = NSTextAlignmentCenter;
        _progresslable.backgroundTextColor = self.backgroundTextColor;
        _progresslable.foregroundTextColor = [UIColor whiteColor];
        _progresslable.userInteractionEnabled = NO;
        [self addSubview:_progresslable];
    }
    return _progresslable;
}


-(void)setBookInfo:(BookInfoForShelf *)bookInfo{
    _downloadBookInfo = bookInfo;
    
    if (self.buttonHeight <= 0) [self setMXRDownloadBtnHeight:BTN_HEIGHT];
    if (self.buttonWidth  <= 0) [self setMXRDownloadBtnWidth:BTN_WIDTH];
    if (!self.backgroundTextColor) [self setMXRDownloadBtnBackgroundTextColor:MXRCOLOR_2FB8E2];
    [self createProgressView];
    [self createProgresslable];
    self.progresslable.backgroundTextColor = self.backgroundTextColor;
    self.progresslable.foregroundTextColor = [UIColor whiteColor];
    self.progresslable.text = [NSString stringWithFormat:@"%.1f%%", bookInfo.downProgress * 100];
    self.progressView.frame = CGRectMake(0, 0, (self.buttonWidth - 2) * bookInfo.downProgress, self.buttonHeight);
    self.progresslable.clipWidth = (self.buttonWidth - 2)*bookInfo.downProgress;
    
    if (bookInfo.State == READSTATE_READING || bookInfo.State == READSTATE_READFINISH || bookInfo.State == READSTATE_HUIBEN|| bookInfo.State == READSTATE_RECENT_DOWNLOAD) {
        //进入阅读
        if(bookInfo.isNeedUpdate){
            self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Update", @"更新");
        }else{
            self.progresslable.text      = MXRLocalizedString(@"READ", @"阅读");
            self.progressView.frame      = CGRectMake(0, 0, self.buttonWidth , self.buttonHeight);
            self.progresslable.backgroundTextColor = [UIColor whiteColor];
            self.progresslable.foregroundTextColor = [UIColor whiteColor];
            self.progresslable.clipWidth = self.buttonWidth - 2;
        }
    }else if (bookInfo.State == DOWNSTATE_WAITING ) {
            if(bookInfo.isNeedUpdate){
                self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Update", @"更新");
            }
            else{
//                if([BookShelfManger getBookWithId:bookInfo.bookGUID]){
//                    self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Waiting", @"等待");
//                }else{
//                    self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Download", @"下载");
//                }
            }
    }
    else if(bookInfo.State == DOWNSTATE_DOWNING)
    {
        if(bookInfo.isNeedUpdate) {
            self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Update", @"更新");
        }
        else{
            //do nothing
        }
    }
    else if(bookInfo.State == DOWNSTATE_PAUSE)
    {
        if(bookInfo.isNeedUpdate){
            self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Update", @"更新");
        }
        else{
           self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Pause", @"暂停");
        }
    }else if (bookInfo.State == DOWNSTATE_JOINBOOKSHELF){
       self.progresslable.text = MXRLocalizedString(@"CustomButtonForBookList_Download", @"下载");
    }
}
- (void)setMXRDownloadBtnWidth:(CGFloat)buttonWidth
{
    _buttonWidth = buttonWidth;
}

- (void)setMXRDownloadBtnHeight:(CGFloat)buttonHeight
{
    _buttonHeight = buttonHeight;
}

- (void)setMXRDownloadBtnBackgroundTextColor:(UIColor *)backgroundTextColor
{
    _backgroundTextColor = backgroundTextColor;
}
@end
