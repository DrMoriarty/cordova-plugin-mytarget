//
//  ViewController.m
//  InterstitialAdExample
//
//  Created by Anton Bulankin on 27.03.15.
//  Copyright (c) 2015 Anton Bulankin. All rights reserved.
//

#import "ViewController.h"
#import <MyTargetSDK/MyTargetSDK.h>


@interface ViewController ()<MTRGInterstitialAdDelegate>

@property IBOutlet UILabel *statusLabel;
@property IBOutlet UIButton *showIntertitialButton;
@property IBOutlet UIButton *loadButton;

@end

@implementation ViewController{
    MTRGInterstitialAd * _interstitialAd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _showIntertitialButton.hidden = YES;
    [self setStyleForButton:_loadButton];
    [self setStyleForButton:_showIntertitialButton];
}

-(void) setStyleForButton:(UIButton*)button{
    button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05];
    button.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.6;
}

-(IBAction)loadButtonClick:(id)sender{
    _showIntertitialButton.hidden = YES;
    _interstitialAd = [[MTRGInterstitialAd alloc]initWithSlotId:@"6899"];
    _interstitialAd.delegate = self;
    [_interstitialAd load];
    
    _statusLabel.text = @"loading...";
    _statusLabel.textColor = [UIColor grayColor];
}
-(IBAction)showInterstitialButtonClick:(id)sender{
    [_interstitialAd showWithController:self];
}


#pragma mark --- MTRGInterstitialAdDelegate

-(void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd{
    _showIntertitialButton.hidden = NO;
    _statusLabel.text = @"loaded complete";
    _statusLabel.textColor = [UIColor greenColor];
}
-(void)onNoAdWithReason:(NSString*)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd{
    _showIntertitialButton.hidden = YES;
    _statusLabel.text = @"loaded error";
    _statusLabel.textColor = [UIColor blackColor];
}

-(void)onClickWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd{
    
}
-(void)onCloseWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd{
    
}


@end
