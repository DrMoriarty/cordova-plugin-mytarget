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
    lastCommand = command;
    if(bannerView != nil) {
        [self fail:@"Banner view already created"];
    } else {
        NSString *slotId = [command.arguments objectAtIndex:0];
        bannerView = [[MTRGAdView alloc]initWithSlotId:slotId];
        bannerView.delegate = self;
        bannerView.viewController = [self findViewController];
        [bannerView load];
    }
}

- (void)removeBanner:(CDVInvokedUrlCommand*)command
{
    lastCommand = command;
    if(bannerView != nil) {
        [bannerView removeFromSuperview];
        bannerView = nil;
        [self success];
    } else {
        [self fail:@"No banner view"];
    }
}

- (void)makeFullscreen:(CDVInvokedUrlCommand*)command
{
    lastCommand = command;

    NSString *slotId = [command.arguments objectAtIndex:0];

    // Создаем экземпляр MTRGInterstitialAd
    MTRGInterstitialAd *_ad = [[MTRGInterstitialAd alloc]initWithSlotId:slotId];
    
    // Устанавливаем делегат
    _ad.delegate = self;
    
    // Запускаем загрузку данных
    [_ad load];
}

#pragma mark - MTRGAdViewDelegate

-(void)onLoadWithAdView:(MTRGAdView *)adView
{
    UIView *view = self.findViewController.view;
    // Устанавливаем размер
    bannerView.frame = CGRectMake((view.frame.size.width-320)/2,view.frame.size.height-50,320,50);
    // Добавляем на экран
    [view addSubview: bannerView];
    // Запускаем показ рекламных объявлений
    [bannerView start];
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

#pragma mark - MTRGInterstitialAdDelegate

-(void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Loaded ad for interstatial view");
    [interstitialAd showWithController:self.findViewController];
    [self success];
}

-(void)onNoAdWithReason:(NSString *)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"No ads for interstatial view: %@", reason);
    [self fail:reason];
}

-(void)onDisplayWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Interstatial ad shown");
}

-(void)onClickWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Interstatial ad clicked");
}

-(void)onCloseWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Interstatial ad closed");
}

-(void)onVideoCompleteWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Video completed");
}

@end

