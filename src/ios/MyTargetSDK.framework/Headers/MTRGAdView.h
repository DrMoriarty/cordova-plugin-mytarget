//
//  MTRGAdView.h
//  myTargetSDK 4.4.9
//
//  Created by Anton Bulankin on 05.03.15.
//  Copyright (c) 2015 Mail.ru Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MyTargetSDK/MTRGCustomParams.h>

@class MTRGAdView;

@protocol MTRGAdViewDelegate <NSObject>

-(void)onLoadWithAdView:(MTRGAdView *)adView;
-(void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView;

@optional

-(void)onAdClickWithAdView:(MTRGAdView *)adView;

@end


@interface MTRGAdView : UIView

-(instancetype) initWithSlotId:(NSString*)slotId;
-(instancetype) initWithSlotId:(NSString*)slotId withRefreshAd:(BOOL)refreshAd;

-(void) load;

-(void) start;
-(void) stop;

@property (nonatomic, weak) id<MTRGAdViewDelegate> delegate;
@property (nonatomic, strong, readonly) MTRGCustomParams * customParams;
@property (nonatomic, weak) UIViewController * viewController;

@end
