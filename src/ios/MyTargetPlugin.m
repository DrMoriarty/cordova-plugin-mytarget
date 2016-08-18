//
//  MyTargetPlugin.m

#import "MyTargetPlugin.h"

@implementation MyTargetPlugin {
    MTRGAdView *bannerView;
    MTRGInterstitialAd *fullscreenAd;
    CDVInvokedUrlCommand *loadBannerCommand, *showBannerCommand, *loadFullscreenCommand, *showFullscreenCommand;
}

-(void)success:(NSString*)result command:(CDVInvokedUrlCommand*)command
{
    if(!result) result = @"Ok";
    if(!command) {
        NSLog(@"Success result '%@' with no command", result);
        return;
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)fail:(NSString*)error command:(CDVInvokedUrlCommand*)command
{
    if(!error) error = @"Error";
    if(!command) {
        NSLog(@"Error result '%@' with no command", error);
        return;
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(UIViewController*)findViewController
{
    id vc = self.webView;
    do {
        vc = [vc nextResponder];
    } while([vc isKindOfClass:UIView.class]);
    return vc;
}

- (void)loadBanner:(CDVInvokedUrlCommand*)command
{
    if(bannerView != nil) {
        [self fail:@"Banner view already created" command:command];
    } else {
        loadBannerCommand = command;
        NSString *slotId = [command.arguments objectAtIndex:0];
        bannerView = [[MTRGAdView alloc]initWithSlotId:slotId];
        bannerView.delegate = self;
        bannerView.viewController = [self findViewController];
        [bannerView load];
    }
}

- (void)showBanner:(CDVInvokedUrlCommand*)command
{
    if(!bannerView) {
        [self fail:@"You should load banner before call showBanner" command:command];
    } else {
        showBannerCommand = command;
        UIView *view = self.findViewController.view;
        // Устанавливаем размер
        bannerView.frame = CGRectMake((view.frame.size.width-320)/2,view.frame.size.height-50,320,50);
        // Добавляем на экран
        [view addSubview: bannerView];
        // Запускаем показ рекламных объявлений
        [bannerView start];
    }
}

- (void)removeBanner:(CDVInvokedUrlCommand*)command
{
    if(bannerView != nil) {
        [bannerView removeFromSuperview];
        bannerView = nil;
        [self success:nil command:command];
        if(showBannerCommand) {
            [self fail:@"Banner removed" command:showBannerCommand];
            showBannerCommand = nil;
        }
    } else {
        [self fail:@"No banner view" command:command];
    }
}

- (void)loadFullscreen:(CDVInvokedUrlCommand*)command
{
    loadFullscreenCommand = command;
    NSString *slotId = [command.arguments objectAtIndex:0];

    // Создаем экземпляр MTRGInterstitialAd
    fullscreenAd = [[MTRGInterstitialAd alloc]initWithSlotId:slotId];
    // Устанавливаем делегат
    fullscreenAd.delegate = self;
    // Запускаем загрузку данных
    [fullscreenAd load];
}

- (void)showFullscreen:(CDVInvokedUrlCommand*)command
{
    if(fullscreenAd) {
        showFullscreenCommand = command;
        [fullscreenAd showWithController:self.findViewController];
    } else {
        [self fail:@"You should call loadFullScreen before showFullScreen" command:command];
    }
}

#pragma mark - MTRGAdViewDelegate

-(void)onLoadWithAdView:(MTRGAdView *)adView
{
    // return from loadBanner
    [self success:nil command:loadBannerCommand];
    loadBannerCommand = nil;
}

-(void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView
{
    NSLog(@"No ad for banner: %@\n%@", reason, adView);
    [self fail:reason command:loadBannerCommand];
    loadBannerCommand = nil;
}

-(void)onAdClickWithAdView:(MTRGAdView *)adView
{
    NSLog(@"Click on ad view: %@", adView);
    // return from showBanner
    [self success:@"Banner clicked" command:showBannerCommand];
    showBannerCommand = nil;
}

#pragma mark - MTRGInterstitialAdDelegate

-(void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Loaded ad for interstatial view");
    [self success:nil command:loadFullscreenCommand];
    loadFullscreenCommand = nil;
}

-(void)onNoAdWithReason:(NSString *)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"No ads for interstatial view: %@", reason);
    [self fail:reason command:loadFullscreenCommand];
    loadFullscreenCommand = nil;
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
    [self success:@"Fullscreen ad closed" command:showFullscreenCommand];
    showFullscreenCommand = nil;
}

-(void)onVideoCompleteWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd
{
    NSLog(@"Video completed");
}

@end

