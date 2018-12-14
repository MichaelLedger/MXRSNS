//
//  MXRSearchBookFromBookStore.m
//  huashida_home
//
//  Created by yuchen.li on 16/10/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSearchBookFromBookStore.h"
@interface MXRSearchBookFromBookStore()

@property (weak, nonatomic) IBOutlet UILabel *searchFromBookStoreLabel;

@end

@implementation MXRSearchBookFromBookStore
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"MXRSearchBookFromBookStore" owner:self options:nil]lastObject];
        self.frame = frame;
        self.searchFromBookStoreLabel.text = MXRLocalizedString(@"MXRSearchBookFromBookStore_Search_From_Store", @"在书城中搜索");
        self.autoresizingMask = NO;
    }
    return self;
}
@end
