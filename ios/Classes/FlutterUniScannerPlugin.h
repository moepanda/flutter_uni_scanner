#import <Flutter/Flutter.h>
#import "LBXScanBaseViewControllerDelegate.h"

@interface FlutterUniScannerPlugin : NSObject<FlutterPlugin, LBXScanBaseViewControllerDelegate>

@property(nonatomic, retain) FlutterResult result;
@property (nonatomic, assign) UIViewController *hostViewController;
@end
