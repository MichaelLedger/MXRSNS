//
//  MXRBookSNSMomentStatusNoUploadModel.m
//  huashida_home
//
//  Created by gxd on 16/9/21.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRBookSNSMomentStatusNoUploadModel.h"
#import "MXRBookSNSDetailCommentListModel.h"
#import <objc/message.h>
@interface MXRBookSNSMomentStatusNoUploadModel()

@end
@implementation MXRBookSNSMomentStatusNoUploadModel
#pragma mark - Init
-(instancetype)initWithUserHandleNoUploadStatusType:(MXRBookSNSUserHandleNoUploadStatusType)handleType andBookSNSMomentId:(NSString *)momentId andUnFocusUserId:(NSString *)userId andReportDetail:(NSString *)reportDetail andCommentListModel:(MXRBookSNSDetailCommentListModel *)listModel andHandleUserId:(NSString *)handleUserID{

    self = [super init];
    if (self) {
        _needUploadType = handleType;
        _bookSNSMomentId = momentId;
        _unFocusUserId = userId;
        _reportdetail = reportDetail;
        self.commentListModel = listModel;
        _uploadStatusType = MXRBookSNSUploadStatusTypeUploadFail;
        _handleUserID = handleUserID;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        unsigned int count=0;
        Ivar *ivar=class_copyIvarList([self class], &count);
        for (int i=0; i<count; i++) {
            Ivar iva=ivar[i];
            const char*name=ivar_getName(iva);
            NSString *strName=[NSString stringWithUTF8String:name];
            id value=[aDecoder decodeObjectForKey:strName];
            if (value) {
                [self setValue:value forKey:strName];
            }else{
//                DLOG(@"key value not exist,key=%@",strName);
            }
        }
        free(ivar);
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count=0;
    Ivar *ivar=class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva=ivar[i];
        const char *name=ivar_getName(iva);
        NSString*strName=[NSString stringWithUTF8String:name];
        id value=[self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}
#pragma mark - Public Methods
-(void)beginUpload{

    _uploadStatusType = MXRBookSNSUploadStatusTypeUploading;
}
-(void)sussUpload{

    _uploadStatusType = MXRBookSNSUploadStatusTypeUploadSuss;
}
-(void)failUpload{

    _uploadStatusType = MXRBookSNSUploadStatusTypeUploadFail;
}
@end
