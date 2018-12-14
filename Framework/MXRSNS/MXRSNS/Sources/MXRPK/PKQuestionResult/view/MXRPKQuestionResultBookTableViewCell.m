//
//  MXRPKQuestionResultBookTableViewCell.m
//  huashida_home
//
//  Created by MountainX on 2018/8/8.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKQuestionResultBookTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "BookShelfManger.h"
#import "MXRDownloadButton.h"
//#import "MXRBookManager.h"

@interface MXRPKQuestionResultBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bookIv;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookDescLabel;
@property (weak, nonatomic) IBOutlet MXRDownloadButton *downloadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadBtnHeightConstraint;

@end

@implementation MXRPKQuestionResultBookTableViewCell

static NSString *const cellIdentifier = @"MXRPKQuestionResultBookTableViewCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MXRPKQuestionResultBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MXRPKQuestionResultBookTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Add Observers
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(progressChanged:) name:MXRBookDownloadProgressChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshDownloadBtn:) name:MXRBookDownloadCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshDownloadBtn:) name:MXRBookDownloadFailNotification object:nil];
    
    [_downloadBtn setMXRDownloadBtnWidth:_downloadBtnWidthConstraint.constant];
    [_downloadBtn setMXRDownloadBtnHeight:_downloadBtnHeightConstraint.constant];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setBook:(MXRPKRecommendBook *)book {
    _book = book;
    
//    BookInfoForShelf *localBook = [BookShelfManger getBookWithId:book.bookGuid];
//    if (localBook) {
//        [_downloadBtn setBookInfo:localBook];
//    } else {
//        BookInfoForShelf *bookInfo = [[BookInfoForShelf alloc] init];
//        bookInfo.bookGUID = book.bookGuid;
//        bookInfo.BookDesc = book.bookDesc;
//        bookInfo.bookName = book.bookName;
//        bookInfo.bookIconURL = book.bookIconUrl;
////        bookInfo.star = [NSNumber numberWithInteger:[book.bookStar integerValue]];
//        [_downloadBtn setBookInfo:bookInfo];
//    }
    
    [_bookIv sd_setImageWithURL:[NSURL URLWithString:[autoString(_book.bookIconUrl) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:MXR_BOOK_ICON_PLACEHOLDER_IMAGE];
    
    _bookNameLabel.text = autoString(_book.bookName);
    _bookDescLabel.text = autoString(_book.bookDesc);
}

- (IBAction)downloadBtnClicked:(MXRDownloadButton *)sender {
//    MXRDownloadButtonState downloadState = [sender.downloadBookInfo getDownloadState];
//    if (![BookShelfManger getBookWithId:sender.downloadBookInfo.bookGUID]){
//        downloadState = MXRDownloadButtonStateCanDownload;
//    }
//    [[MXRBookManager defaultManager] switchBookStateWith:downloadState bookInfo:sender.downloadBookInfo];
    [sender setBookInfo:sender.downloadBookInfo];//避免暂停和进度变化先后不可控制，显示文案统一为'暂停'
}

-(void)progressChanged:(NSNotification*)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *bookGUID    = [userInfo objectForKey:@"bookGuid"];
    NSNumber *progress    = [userInfo valueForKey:@"progress"];
//    if ([bookGUID isEqualToString:_downloadBtn.downloadBookInfo.bookGUID]) {
//        _downloadBtn.downloadBookInfo.downProgress = [progress floatValue];
//        [self.downloadBtn setBookInfo:_downloadBtn.downloadBookInfo];
//    }
}

- (void)refreshDownloadBtn:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *bookGUID    = [userInfo objectForKey:@"bookGuid"];
//    if ([bookGUID isEqualToString:_downloadBtn.downloadBookInfo.bookGUID]) {
//        [self.downloadBtn setBookInfo:_downloadBtn.downloadBookInfo];
//    }
}

@end
