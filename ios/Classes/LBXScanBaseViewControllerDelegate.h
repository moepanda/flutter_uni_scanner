//
// Created by konata on 26/3/21.
//

#import <Foundation/Foundation.h>

@class LBXScanBaseViewController;

@protocol LBXScanBaseViewControllerDelegate <NSObject>

- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didScanBarcodeWithResult:(NSString *)result;
- (void)lBXScanBaseViewController:(LBXScanBaseViewController *)controller didFailWithErrorCode:(NSString *)errorCode;

@end
