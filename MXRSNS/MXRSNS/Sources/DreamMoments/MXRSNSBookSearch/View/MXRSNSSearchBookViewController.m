//
//  MXRSearchBookViewController.m
//  huashida_home
//
//  Created by yuchen.li on 16/9/18.
//  Copyright © 2016年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "MXRSNSSearchBookViewController.h"
#import "MXRBookSNSSendDetailProxy.h"
#import "MXRSNSSearchBookCell.h"
#import "BookInfoForShelf.h"
#import "MXRSNSSearchNoBookView.h"
#import "MXRBookSNSSendDetailController.h"
#import "MXRBookStarModel.h"
//#import "MXRSearchResultController.h"
//#import "MXRSearchResultProxy.h"
#import "MXRSearchBookFromBookStore.h"
#import "MJRefresh.h"
#import "MXRTopSearchView.h"
#define MXRSNSSearchBookCellID @"MXRSNSSearchBookCellID"
@interface MXRSNSSearchBookViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *bookTableView;
@property (nonatomic, strong)NSMutableArray *bookReloadDataArray;              // 符合条件的 图书数据
@property (nonatomic, strong)NSMutableArray *sendArray;                        //
@property (nonatomic, strong)UIView *noBookView;                               // 未找到图书视图
@property (nonatomic, strong)UITapGestureRecognizer *resignKeyboardTap;         // 键盘消失的tap手势
@property (nonatomic, strong)UIView *searchBookFromBookStoreView;
@property (nonatomic, strong) MXRTopSearchView *topSearchView;
@property (strong, nonatomic,readonly) UITextField *searchTextField;            //搜索框

@end

/**
 搜索先搜索本地书架上面的图书,如若搜索不到，去书城搜索。
 */
@implementation MXRSNSSearchBookViewController
{
    BOOL isHaveSeachFromStoreView;
    BOOL isNeedRequestFromService;
    BOOL isHaveRefreshFooter;
    NSInteger _currentPage;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setTextField];
    self.topSearchView.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH_DEVICE, 40);  //iphoneX一定要重写 intrinsicContentSize 属性
    self.navigationItem.titleView = self.topSearchView;
    [self.view addSubview:self.bookTableView];
    NSRange range;
    range.location = 0;
    range.length = 1;
    
    [[MXRBookSNSSendDetailController getInstance]saveBookFromBookShelf];
    
    self.bookReloadDataArray = [[MXRBookSNSSendDetailProxy getInstance].bookDataArray  mutableCopy];
    if (self.bookReloadDataArray.count == 0) {
        [self.view addSubview:self.searchBookFromBookStoreView];
        isHaveSeachFromStoreView = YES;
    }
    // 将本地的图书的GUID用 ; 分隔开，拼接成一个字符串,去请求对应的图书星级
    NSString *bookGuids;
    for (int i = 0; i < self.bookReloadDataArray.count; i++) {
        BookInfoForShelf *book = self.bookReloadDataArray[i];
        //默认9
        book.star = @(9);
        if (i == 0) {
            bookGuids = book.bookGUID;
        }else{
            bookGuids = [NSString stringWithFormat:@"%@;%@",bookGuids,book.bookGUID];
        }
    }
    [self addAbserver];
    if (bookGuids) {
        // 请求图书的星级
        @MXRWeakObj(self);
        [[MXRBookSNSSendDetailController getInstance]getBookStarWithBookGuids:bookGuids callBack:^(BOOL isOkay) {
            if (isOkay) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    for (MXRBookStarModel *model in [MXRBookSNSSendDetailProxy getInstance].bookStarModelArray) {
                        for (BookInfoForShelf *book in [MXRBookSNSSendDetailProxy getInstance].bookDataArray) {
                            if ([model.bookGuid isEqualToString:book.bookGUID]) {
                                book.star = [NSNumber numberWithInteger:model.star];
                                break;
                            }
                        }
                    }
                    selfWeak.bookReloadDataArray = [[MXRBookSNSSendDetailProxy getInstance].bookDataArray  mutableCopy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [selfWeak.bookTableView reloadData];
                    });
                });
            }
        }];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeInteractivePopGestureRecognizer];
    self.topSearchView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, TOP_BAR_CONTENT_HEIGHT);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)dealloc{
    DLOG_METHOD;
}

-(void)addAbserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNoBookFind) name:Request_Search_Filed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveNoMoreBook) name:No_More_Result object:nil];
}

-(void)haveNoBookFind
{
    if (!self.noBookView) {
        [self addNoBookViewToSelfView];
        
    }
}

-(void)haveNoMoreBook{
    self.bookTableView.mj_footer.state = MJRefreshStateNoMoreData;
    
}
#pragma mark--UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.bookReloadDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXRSNSSearchBookCell *cell = [tableView dequeueReusableCellWithIdentifier:MXRSNSSearchBookCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MXRSNSSearchBookCell" owner:nil options:nil]lastObject];
    }
    if (self.bookReloadDataArray.count >= indexPath.row + 1) {
        cell.book = self.bookReloadDataArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bookReloadDataArray.count>indexPath.row) {
        BookInfoForShelf *book = self.bookReloadDataArray[indexPath.row];
        [self.delegate userHaveDoneSelectBook:book];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
        [self.bookTableView removeFromSuperview];
        self.bookTableView = nil;
    }
}
#pragma mark--UITextViewDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    isNeedRequestFromService = YES;
    [self textFieldDidChange:textField];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = @"";
}


-(void)textFieldDidChange:(id)sender{
    UITextField *searchTextField = (UITextField*)sender;
    if (searchTextField.text.length == 0) {
        if (isHaveRefreshFooter) {
            self.bookTableView.mj_footer = nil;
            isHaveRefreshFooter = NO;
        }
        self.bookReloadDataArray = [[MXRBookSNSSendDetailProxy getInstance].bookDataArray mutableCopy];
        if (self.bookReloadDataArray.count > 0) {
            if (self.noBookView) {
                [self.noBookView removeFromSuperview];
                self.noBookView = nil;
            }
            if (isHaveSeachFromStoreView) {
                [self.searchBookFromBookStoreView removeFromSuperview];
                self.searchBookFromBookStoreView = nil;
                isHaveSeachFromStoreView = NO;
            }
            [self.bookTableView reloadData];
        }else{
            if (self.noBookView) {
                [self.noBookView removeFromSuperview];
                self.noBookView = nil;
            }
            if (!isNeedRequestFromService) {
                [self.view addSubview:self.searchBookFromBookStoreView];
                isHaveSeachFromStoreView = YES;
            }
        }
    }else{
        // 避免 在输入拼音的过程中 请求数据，保证输入完一个汉字后再去请求图书信息
        NSString *langugeType = [[searchTextField textInputMode] primaryLanguage];
        if ([langugeType isEqualToString:@"zh-Hans"])//中文输入
        {
            UITextRange *selectedRange = [searchTextField markedTextRange];//选中部分
            //获取高亮部分
            UITextPosition *position = [searchTextField positionFromPosition:selectedRange.start offset:0];
            if (!position)//无高亮
            {
                //去请求数据
                [self searchBookWithKeyWord:searchTextField.text];
            }else//有高亮
            {
                
            }
        }else//非中文输入
        {
            //去请求数据
            [self searchBookWithKeyWord:searchTextField.text];
        }
    }
}
#pragma mark--根据关键字搜索本地图书
/**
  搜索先搜索本地书架上面的图书,如若搜索不到，去书城搜索。

 @param str
 */
-(void)searchBookWithKeyWord:(NSString*)str{
    [self.sendArray removeAllObjects];
    //本地书架
    for (BookInfoForShelf *book in [MXRBookSNSSendDetailProxy getInstance].bookDataArray) {
        if ([book.bookName containsString:str]) {
            [self.sendArray addObject:book];
        }
    }
    // 书架上 有符合条件 的书
    if (self.sendArray.count > 0) {
        isNeedRequestFromService = NO;
        self.bookReloadDataArray = self.sendArray;
        if (isHaveSeachFromStoreView) {
            [self.searchBookFromBookStoreView removeFromSuperview];
            self.searchBookFromBookStoreView = nil;
            isHaveSeachFromStoreView = NO;
        }
        if (self.noBookView) {
            [self.noBookView removeFromSuperview];
            self.noBookView = nil;
        }
        if (isHaveRefreshFooter) {
            self.bookTableView.mj_footer = nil;
            isHaveRefreshFooter = NO;
        }
        
        [self.bookTableView reloadData];
        return ;
    // 书架上 没有符合条件 的书
    }else if (self.sendArray.count == 0) {
        if (!isHaveSeachFromStoreView) {
            [self.view addSubview:self.searchBookFromBookStoreView];
            isHaveSeachFromStoreView = YES;
        }
        if (!isHaveRefreshFooter) {
            self.bookTableView.mj_footer = [MJRefreshBackStateFooter  footerWithRefreshingTarget:self refreshingAction:@selector(searchBookFromService)];
            isHaveRefreshFooter = YES;
        }
        if (isNeedRequestFromService) {
            isNeedRequestFromService = NO;
            _currentPage = 0;
            [self searchBookFromService];
        }
        
    }
}
#pragma mark--从服务器搜索图书
-(void)searchBookFromService{
    _currentPage++;
    @MXRWeakObj(self);
//    [[MXRSearchResultController getInstance]requestSearchResultWithString:self.searchTextField.text andIndexPage:_currentPage withCallBack:^(BOOL isOK) {
//        if (isHaveSeachFromStoreView) {
//            [selfWeak.searchBookFromBookStoreView removeFromSuperview];
//            selfWeak.searchBookFromBookStoreView = nil;
//            isHaveSeachFromStoreView = NO;
//        }
//        if (isOK) {
//            if ([MXRSearchResultProxy getInstence].arrayData.count == 0) {
//                
//                if (!selfWeak.noBookView) {
//                    [selfWeak addNoBookViewToSelfView];
//                }
//            }else{
//                if (selfWeak.noBookView) {
//                    [selfWeak.noBookView removeFromSuperview];
//                    selfWeak.noBookView = nil;
//                }
//                [selfWeak.sendArray  addObjectsFromArray:[MXRSearchResultProxy getInstence].arrayData];
//                selfWeak.bookReloadDataArray = selfWeak.sendArray;
//                [selfWeak.bookTableView reloadData];
//            }
//            if (self.bookTableView.mj_footer) {
//                [self.bookTableView.mj_footer endRefreshing];
//            }
//        }else{
//            if (!selfWeak.noBookView) {
//                [selfWeak addNoBookViewToSelfView];
//            }
//            if (self.bookTableView.mj_footer) {
//                [self.bookTableView.mj_footer endRefreshing];
//            }
//        }
//    }];
}

-(void)tapToResignFirstResign{
    [self.searchTextField resignFirstResponder];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchTextField resignFirstResponder];
    
}

-(void)addNoBookViewToSelfView{
    if (!self.noBookView) {
        self.noBookView = [[MXRSNSSearchNoBookView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+TOP_BAR_CONTENT_HEIGHT, SCREEN_WIDTH_DEVICE_ABSOLUTE, SCREEN_HEIGHT_DEVICE_ABSOLUTE-(STATUS_BAR_HEIGHT+TOP_BAR_CONTENT_HEIGHT)) withText: MXRLocalizedString(@"MXRSNSSearchNoBookView_No_find_Book", @"没有找到相关书籍") withPromptText:@"" andImageName:@"img_common_noSearchBook"];
        
        [self.noBookView addGestureRecognizer:self.resignKeyboardTap];
        [self.view addSubview:self.noBookView];
        self.noBookView.layer.zPosition = 50;
        [self.noBookView bringSubviewToFront:self.view];
    }
    
}

-(void)setTextField{
    //设计键盘return
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonTapped:(id)sender{
    [self.searchTextField resignFirstResponder];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark--getter
-(MXRTopSearchView *)topSearchView{
    if (!_topSearchView)
    {
        _topSearchView = [MXRTopSearchView topSearchView];
        _topSearchView.frame = CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, TOP_BAR_CONTENT_HEIGHT);
        [_topSearchView.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        [_topSearchView.rightButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topSearchView;
}
-(UITextField*)searchTextField{
    return self.topSearchView.textField;
}

-(UIView *)searchBookFromBookStoreView{
    if (!_searchBookFromBookStoreView) {
        _searchBookFromBookStoreView = [[MXRSearchBookFromBookStore alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE-TOP_BAR_HEIGHT)];
        [_searchBookFromBookStoreView addGestureRecognizer:self.resignKeyboardTap];
        
    }
    return _searchBookFromBookStoreView;
}
-(NSMutableArray *)sendArray{
    if (!_sendArray) {
        _sendArray = [[NSMutableArray alloc]init];
        
    }
    return _sendArray;
    
}
-(NSMutableArray *)bookReloadDataArray{
    if (!_bookReloadDataArray) {
        _bookReloadDataArray = [[NSMutableArray alloc]init];
    }
    return _bookReloadDataArray;
}

-(UITapGestureRecognizer *)resignKeyboardTap{
    if (!_resignKeyboardTap) {
        _resignKeyboardTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToResignFirstResign)];
    }
    return _resignKeyboardTap;
}

-(UITableView *)bookTableView {
    if (!_bookTableView) {
        _bookTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_DEVICE, SCREEN_HEIGHT_DEVICE-TOP_BAR_HEIGHT)];
        _bookTableView.delegate  = self;
        _bookTableView.dataSource= self;
        _bookTableView.rowHeight = 53;
        _bookTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _bookTableView;
}

@end
