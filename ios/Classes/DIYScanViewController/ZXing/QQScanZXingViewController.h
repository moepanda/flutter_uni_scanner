//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXAlertAction.h"
#import "LBXScanZXingViewController.h"

#pragma mark -模仿qq界面
@interface QQScanZXingViewController : LBXScanZXingViewController


//返回按钮
@property (nonatomic, strong) UIButton *returnBtn;

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;
@property (nonatomic,strong) NSString *tipText;

#pragma mark - 底部几个功能：开启闪光灯、相册
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;






@end
