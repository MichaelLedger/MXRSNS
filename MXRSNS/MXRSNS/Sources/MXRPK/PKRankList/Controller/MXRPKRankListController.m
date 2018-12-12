//
//  MXRRKRankListController.m
//  huashida_home
//
//  Created by MinJing_Lin on 2018/10/18.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRPKRankListController.h"
#import "MXRPKNetworkManager.h"
#import "MXRPKRankListModel.h"

@implementation MXRPKRankListController


+ (void)loadPKRankListsuccess:(void(^)(MXRPKRankListModel *rankModel))success
                      failure:(void(^)(id error))failure {
    [MXRPKNetworkManager loadPKRankListsuccess:^(MXRNetworkResponse *response) {
        if (response.isSuccess && success) {
            MXRPKRankListModel *model = [MXRPKRankListModel mxr_modelWithJSON:response.body];
            success(model);
        } else {
            MXRPKRankListModel *model = [[MXRPKRankListModel alloc] init];//排行榜添加数据为空效果 V5.16.0 by MT.X
            success(model);
            
//            NSError *error = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:[response.errCode integerValue]  userInfo:@{NSLocalizedFailureReasonErrorKey:response.errMsg?:@"server response error"}];
//            if (failure) failure(error);
        }
    } failure:failure];
}
@end
