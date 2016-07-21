//
//  MainView.m
//  AdViewExample
//
//  Created by Anton Bulankin on 03.11.15.
//  Copyright © 2015 Mail.Ru Group. All rights reserved.
//

#import "MainView.h"
#import "AdContainerView.h"

@implementation MainView

-(void) layoutSubviews{
    [super layoutSubviews];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[AdContainerView class]]){
            CGRect frame = view.frame;
            frame.size.height = 50;
            frame.origin.y = self.frame.size.height - frame.size.height;
            frame.origin.x = 0;
            frame.size.width = self.frame.size.width;
            view.frame = frame;
        }
        
        if (view == self.loadButton){
            CGRect frame = view.frame;
            frame.origin.x = 0.5 * (self.frame.size.width - frame.size.width);
            frame.origin.y = self.titleView.frame.origin.y + self.titleView.frame.size.height + 40;
            view.frame = frame;
        }
    }
}

@end
