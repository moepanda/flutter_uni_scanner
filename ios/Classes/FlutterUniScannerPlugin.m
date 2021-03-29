#import "FlutterUniScannerPlugin.h"
#import "StyleDIY.h"
#import "QQScanZXingViewController.h"
#import "Global.h"

@implementation FlutterUniScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    NSString *const PLUGIN_NAME = @"com.moepanda00.flutter_uni_scanner";
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:PLUGIN_NAME
            binaryMessenger:[registrar messenger]];
    FlutterUniScannerPlugin* instance = [[FlutterUniScannerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.hostViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"startScan" isEqualToString:call.method]) {
        self.result = result;
        [self showBarcodeView];
    }else {
      result(FlutterMethodNotImplemented);
    }
}

- (void)showBarcodeView {
    QQScanZXingViewController *vc = [QQScanZXingViewController new];
    vc.style = [StyleDIY qqStyle];
    vc.cameraInvokeMsg = @"相机启动中";
    vc.continuous = [Global sharedManager].continuous;
//        vc.orientation = [StyleDIY videoOrientation];
    vc.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
//    [self.hostViewController pushViewController:navigationController animated:YES];
    [self.hostViewController presentViewController:navigationController animated:YES completion:nil];
}


- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didFailWithErrorCode:(NSString *)errorCode {
    if (self.result){
        self.result([FlutterError errorWithCode:errorCode
                                        message:nil
                                        details:nil]);
    }
}

- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didScanBarcodeWithResult:(NSString *)result {
    if (self.result) {
        NSDictionary *resultDict = @{@"code":result};
        self.result(resultDict);
    }
}

@end
