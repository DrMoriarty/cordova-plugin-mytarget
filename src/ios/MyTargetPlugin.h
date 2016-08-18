//
//  MyTargetPlugin.h

#import <Cordova/CDV.h>
#import <MyTargetSDK/MyTargetSDK.h>

@interface MyTargetPlugin : CDVPlugin <MTRGAdViewDelegate, MTRGInterstitialAdDelegate>
{
}

- (void)loadBanner:(CDVInvokedUrlCommand*)command;
- (void)showBanner:(CDVInvokedUrlCommand*)command;
- (void)removeBanner:(CDVInvokedUrlCommand*)command;
- (void)loadFullscreen:(CDVInvokedUrlCommand*)command;
- (void)showFullscreen:(CDVInvokedUrlCommand*)command;

@end
