//
//  MyTargetPlugin.h

#import <Cordova/CDV.h>
#import <MyTargetSDK/MyTargetSDK.h>

@interface MyTargetPlugin : CDVPlugin <MTRGAdViewDelegate, MTRGInterstitialAdDelegate>
{
}

- (void)makeBanner:(CDVInvokedUrlCommand*)command;
- (void)removeBanner:(CDVInvokedUrlCommand*)command;
- (void)makeFullscreen:(CDVInvokedUrlCommand*)command;
- (void)preloadFullscreen:(CDVInvokedUrlCommand*)command;
- (void)showPreloadedFullscreen:(CDVInvokedUrlCommand*)command;

@end
