//
//  MXRAppConfigModel.h
//  huashida_home
//
//  Created by weiqing.tang on 2018/5/29.
//  Copyright © 2018年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXRAppConfigModel : NSObject<MXRModelDelegate>
/*
 {
 "id": 2,
 "configName": "data_collection_rule",
 "configDesc": "SDK数据采集策略",
 "configValue": "0",
 "updateTime": "2017-03-06 09:30:56",
 "createTime": "2017-02-08 15:57:32"
 },
 {
 "id": 35,
 "configName": "message_page_url",
 "configDesc": "消息页面地址",
 "configValue": "http://192.168.0.125:10122/message/message_page_v1.html",
 "updateTime": "2017-06-27 00:00:00",
 "createTime": "2017-06-27 00:00:00"
 },
 {
 "id": 36,
 "configName": "rest_remind_time",
 "configDesc": "休息提醒时间，单位分钟",
 "configValue": "10",
 "updateTime": "2017-09-26 11:26:28",
 "createTime": "2017-09-26 11:26:26"
 }
 */
@property (nonatomic, assign) NSInteger iD;                   //配置ID
@property (nonatomic, copy) NSString *configDesc;             //配置描述
@property (nonatomic, copy) NSString *configName;             //配置名称
@property (nonatomic, copy) NSString *configValue;            //配置参数
@property (nonatomic, copy) NSString *createTime;             //创建时间
@property (nonatomic, copy) NSString *updateTime;             //更新时间
@end
