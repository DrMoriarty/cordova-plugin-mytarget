//
//  MyTargetPlugin.m

#import "MyTargetPlugin.h"

@implementation MyTargetPlugin {
    MTRGAdView *bannerView;
    CDVInvokedUrlCommand* lastCommand;
}

-(void)success
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:lastCommand.callbackId];
}

-(void)fail:(NSString*)error 
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:lastCommand.callbackId];
}

-(UIViewController*)findViewController
{
    id vc = self.webView;
    do {
        vc = [vc nextResponder];
    } while([vc isKindOfClass:UIView.class]);
    return vc;
}

- (void)makeBanner:(CDVInvokedUrlCommand*)command
{
    NSString *slotId = [command.arguments objectAtIndex:0];
    bannerView = [[MTRGAdView alloc]initWithSlotId:slotId];
    bannerView.delegate = self;
    bannerView.viewController = [self findViewController];
    [bannerView load];
}

- (void)removeBanner:(CDVInvokedUrlCommand*)command
{
    if(bannerView != null) {
    } else {
    }
}

- (void)makeFullscreen:(CDVInvokedUrlCommand*)command
{
}

-(void)onLoadWithAdView:(MTRGAdView *)adView
{
    UIView view = self.findViewController.view;
    // Устанавливаем размер
    _adView.frame = CGRectMake((view.frame.size.width-320)/2,view.frame.size.height-50,320,50);
    // Добавляем на экран
    [view addSubview: _adView];
    // Запускаем показ рекламных объявлений
    [_adView start];
    [self success];
}

-(void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView
{
    NSLog(@"No ad for banner: %@\n%@", reason, adView);
    [self fail:reason];
}

-(void)onAdClickWithAdView:(MTRGAdView *)adView
{
    NSLog(@"Click on ad view: %@", adView);
}
