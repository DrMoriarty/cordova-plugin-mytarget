//
//  AdContainerView.m
//  NativeAdExample
//
//  Created by Anton Bulankin on 06.04.15.
//  Copyright (c) 2015 Mail.ru Group. All rights reserved.
//

#import "AdContainerView.h"

@implementation AdContainerView{
    MTRGBaseNativeAdView * _adView;
}

-(void) setAdView:(MTRGBaseNativeAdView *)adView{
    if (_adView){
        [_adView removeFromSuperview];
    }
    _adView = adView;
    [self addSubview:_adView];
}

-(MTRGBaseNativeAdView*)adView{
    return _adView;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGRect containerFrame = self.frame;
    [_adView setFixedWidth:containerFrame.size.width];
    CGRect adFrame = _adView.frame;
    containerFrame.origin.y -= (adFrame.size.height - containerFrame.size.height);
    if (containerFrame.origin.y < 100) containerFrame.origin.y = 100;
    containerFrame.size.height = adFrame.size.height;
    self.frame = containerFrame;
}

@end
