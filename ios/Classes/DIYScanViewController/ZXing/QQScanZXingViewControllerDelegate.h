//
// Created by konata on 26/3/21.
//

#import <Foundation/Foundation.h>

@class QQScanZXingViewController;

@protocol QQScanZXingViewControllerDelegate <NSObject>

- (void)qQScanZXingViewController:(QQScanZXingViewController *)controller didScanBarcodeWithResult:(NSString *)result;
- (void)qQScanZXingViewController:(QQScanZXingViewController *)controller didFailWithErrorCode:(NSString *)errorCode;

@end
