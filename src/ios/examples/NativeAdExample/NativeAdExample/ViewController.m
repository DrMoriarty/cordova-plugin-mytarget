//
//  ViewController.m
//  NativeAdExample
//
//  Created by Anton Bulankin on 03.04.15.
//  Copyright (c) 2015 Mail.ru Group. All rights reserved.
//

#import "ViewController.h"
#import <MyTargetSDK/MyTargetSDK.h>
#import "AdContainerView.h"

@interface ViewController ()<MTRGNativePromoAdDelegate, MTRGNativeTeaserAdDelegate, MTRGNativeImageAdDelegate>

@property IBOutlet UIButton * contentStreamButton;
@property IBOutlet UIButton * chatListButton;
@property IBOutlet UIButton * newsFeedButton;
@property IBOutlet UIButton * contentWallButton;
@property IBOutlet AdContainerView * adContainerView;

@end

@implementation ViewController{
    MTRGNativePromoAd *_promoAd;
    MTRGNativeTeaserAd * _chatListTeaserAd;
    MTRGNativeTeaserAd * _newsFeedTeaserAd;
    MTRGNativeImageAd * _imageAd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyleForButton:_chatListButton];
    [self setStyleForButton:_newsFeedButton];
    [self setStyleForButton:_contentStreamButton];
    [self setStyleForButton:_contentWallButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setStyleForButton:(UIButton*)button{
    button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05];
    button.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.6;
}

-(IBAction)loadContentStream:(id)sender{
    _promoAd = [[MTRGNativePromoAd alloc]initWithSlotId:@"30294"];
    _promoAd.delegate = self;
    [_promoAd load];
}

-(IBAction)loadNewsFeed:(id)sender{
    _newsFeedTeaserAd = [[MTRGNativeTeaserAd alloc] initWithSlotId:@"6591"];
    _newsFeedTeaserAd.delegate = self;
    [_newsFeedTeaserAd load];
}

-(IBAction)loadChatList:(id)sender{
    _chatListTeaserAd = [[MTRGNativeTeaserAd alloc] initWithSlotId:@"6591"];
    _chatListTeaserAd.delegate = self;
    [_chatListTeaserAd load];
}

-(IBAction)loadContentWall:(id)sender{
    _imageAd = [[MTRGNativeImageAd alloc] initWithSlotId:@"6592"];
    _imageAd.delegate = self;
    [_imageAd load];
}


-(void) showAdView:(MTRGBaseNativeAdView*)adView{
    _adContainerView.adView = adView;
}


#pragma mrak -- MTRGNativePromoAdDelegate

-(void)onLoadWithNativePromoBanner:(MTRGNativePromoBanner *)promoBanner promoAd:(MTRGNativePromoAd *)promoAd{
    MTRGContentStreamAdView * adView = [MTRGNativeViewsFactory createContentStreamViewWithBanner:promoBanner];
    [promoAd registerView:adView withController:self];
    [adView loadImages];
    [self showAdView:adView];
}

-(void)onNoAdWithReason:(NSString *)reason promoAd:(MTRGNativePromoAd *)promoAd{
    NSLog(@"No ad");
}

-(void)onAdClickWithNativePromoAd:(MTRGNativePromoAd *)promoAd{
    
}

#pragma mark -- MTRGNativeTeaserAdDelegate


-(void)onLoadWithNativeTeaserBanner:(MTRGNativeTeaserBanner *)teaserBanner teaserAd:(MTRGNativeTeaserAd *)teaserAd{
    if (teaserAd == _newsFeedTeaserAd){
        MTRGNewsFeedAdView * adView = [MTRGNativeViewsFactory createNewsFeedViewWithBanner:teaserBanner];
        [teaserAd registerView:adView withController:self];
        [adView loadImages];
        [self showAdView:adView];
    }
    if (teaserAd == _chatListTeaserAd){
        MTRGNewsFeedAdView * adView = [MTRGNativeViewsFactory createNewsFeedViewWithBanner:teaserBanner];
        [teaserAd registerView:adView withController:self];
        [adView loadImages];
        [self showAdView:adView];
    }
    

}

-(void)onNoAdWithReason:(NSString *)reason teaserAd:(MTRGNativeTeaserAd *)teaserAd{
    NSLog(@"No ad");
}

-(void)onAdClickWithNativeTeaserAd:(MTRGNativeTeaserAd *)teaserAd{

}

#pragma mark -- MTRGNativeImageAdDelegate

-(void)onLoadWithNativeImageBanner:(MTRGNativeImageBanner *)imageBanner imageAd:(MTRGNativeImageAd *)imageAd{
    MTRGContentWallAdView * adView = [MTRGNativeViewsFactory createContentWallViewWithBanner:imageBanner];
    [imageAd registerView:adView withController:self];
    [adView loadImages];
    [self showAdView:adView];
}

-(void)onNoAdWithReason:(NSString *)reason imageAd:(MTRGNativeImageAd *)imageAd{
    NSLog(@"No ad");
}

-(void)onAdClickWithNativeImageAd:(MTRGNativeImageAd *)imageAd{

}

@end
