//
//  MTRGImageData.h
//  myTargetSDK 4.8.0
//
//  Created by Anton Bulankin on 17.11.14.
//  Copyright (c) 2014 Mail.ru Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MyTargetSDK/MTRGMediaData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTRGImageData : MTRGMediaData

@property(nonatomic, readonly, nullable) UIImage *image;

- (nullable instancetype)initWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
