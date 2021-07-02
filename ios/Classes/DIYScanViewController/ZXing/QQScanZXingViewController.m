//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "QQScanZXingViewController.h"
#import "LBXPermission.h"


@interface QQScanZXingViewController ()
@end

@implementation QQScanZXingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    if (_topTitle) {
        
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
    }
    
    if (_bottomItemsView) {
        
        
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds)-100,CGRectGetWidth(self.view.bounds), 100);

        
        self.bottomItemsView.frame = frame;
        CGSize size = CGSizeMake(100, 87);//stt 原本尺寸65 暂时用文字 之后换图片

        _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
        _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)*2/3, CGRectGetHeight(_bottomItemsView.frame)/2);

        _btnPhoto.bounds = _btnFlash.bounds;
        _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/3, CGRectGetHeight(_bottomItemsView.frame)/2);
    }

}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self drawBottomItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];


}

//绘制扫描区域
- (void)drawTitle
{
    if (_returnBtn) {
        return;
    }

    self.returnBtn = [[UIButton alloc]init];
    self.returnBtn.frame = CGRectMake(20, 20, 48, 48);
//    [self.returnBtn setImage:image forState:UIControlStateNormal];
    [self.returnBtn setTitle:@"返回" forState:UIControlStateNormal];//stt 暂时用文字 之后换图片
    [self.returnBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.returnBtn];

    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);

        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }


        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = self.tipText;
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}



- (void)drawBottomItems
{
    if (_bottomItemsView) {

        return;
    }


    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds)-100,CGRectGetWidth(self.view.bounds), 100);
    self.bottomItemsView = [[UIView alloc]initWithFrame:frame];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    [self.view addSubview:_bottomItemsView];

    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
//     [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash setTitle:@"打开闪光灯" forState:UIControlStateNormal];//stt 暂时用文字 之后换图片
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];

    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
//    [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto setTitle:@"打开相册" forState:UIControlStateNormal];//stt 暂时用文字 之后换图片
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];


    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];

}




#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];

    if (self.isOpenFlash)
    {
//        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_scan_off"] forState:UIControlStateNormal];
        [_btnFlash setTitle:@"关闭闪光灯" forState:UIControlStateNormal];//stt
    }
    else
//        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
        [_btnFlash setTitle:@"打开闪光灯" forState:UIControlStateNormal];//stt
}

- (void)returnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {

    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];;
    image = [[UIImage alloc] initWithContentsOfFile:image_path];

    return image;

}




@end
