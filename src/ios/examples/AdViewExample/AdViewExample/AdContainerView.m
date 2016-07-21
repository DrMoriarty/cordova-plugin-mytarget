//
//  AdContainerView.m
//  AdViewExample
//
//  Created by Anton Bulankin on 30.03.15.
//  Copyright (c) 2015 Mail.ru Group. All rights reserved.
//

#import "AdContainerView.h"

@implementation AdContainerView

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    if (frame.size.height < 50){
        frame.size.height = 50;
        self.frame = frame;
    }    
    CGRect frame1 = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _adView.frame = frame1;
}


@end
