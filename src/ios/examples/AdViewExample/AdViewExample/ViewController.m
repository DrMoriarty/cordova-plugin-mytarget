//
//  ViewController.m
//  AdViewExample
//
//  Created by Anton Bulankin on 30.03.15.
//  Copyright (c) 2015 Mail.ru Group. All rights reserved.
//

#import "ViewController.h"
#import <MyTargetSDK/MyTargetSDK.h>
#import "AdContainerView.h"
#import "MainView.h"

@interface ViewController ()<MTRGAdViewDelegate>

@property IBOutlet UIView * titleView;
@property IBOutlet UIButton *loadButton;
@property IBOutlet AdContainerView *adContainerView;

@property (readonly) MainView * mainView;

@end

@implementation ViewController{
    MTRGAdView *_adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyleForButton:_loadButton];
    self.mainView.loadButton = _loadButton;
    self.mainView.titleView = _titleView;
    [self.view layoutSubviews];
}

-(MainView*)mainView{
    return (MainView*)self.view;
}

-(void) setStyleForButton:(UIButton*)button{
    button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05];
    button.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.6;
}

-(IBAction)loadButtonClick:(id)sender{
    if (_adView){
        [_adView removeFromSuperview];
        _adContainerView.adView = nil;
    }
    _adView = [[MTRGAdView alloc]initWithSlotId:@"30268"];
    _adView.delegate = self;
    _adView.viewController = self;
    [_adView load];
    
    //Debug info enabled
    [MTRGManager setLoggingEnabled:YES];
}


#pragma mark -- MTRGAdViewDelegate

-(void)onLoadWithAdView:(MTRGAdView *)adView{
    _adContainerView.adView = _adView;
    [_adContainerView addSubview:_adView];
    
    [_adView start];
}
-(void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView{
    NSLog(@"No ad");
}

-(void)onAdClickWithAdView:(MTRGAdView *)adView{
//
}

@end
