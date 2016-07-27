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

@end
