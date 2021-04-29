#import "FlutterUniScannerPlugin.h"
#import "StyleDIY.h"
#import "QQScanZXingViewController.h"
#import "Global.h"

/** FlutterUniScannerPlugin */
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

/** FlutterUniScannerPlugin handleMethodCall*/
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"startScan" isEqualToString:call.method]) {
        self.result = result;
        [self showBarcodeView];
    }else {
      result(FlutterMethodNotImplemented);
    }
}
/** FlutterUniScannerPlugin showBarcodeView*/
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

/** FlutterUniScannerPlugin didFailWithErrorCode*/
- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didFailWithErrorCode:(NSString *)errorCode {
    if (self.result){
        self.result([FlutterError errorWithCode:errorCode
                                        message:nil
                                        details:nil]);
    }
}

/** FlutterUniScannerPlugin didScanBarcodeWithResult*/
- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didScanBarcodeWithResult:(NSString *)result {
    if (self.result) {
        NSDictionary *resultDict = @{@"code":result};
        self.result(resultDict);
    }
}

@end
