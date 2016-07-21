//
//  MTRGNativeBaseAd.h
//  myTargetSDK 4.4.9
//
//  Created by Anton Bulankin on 18.11.14.
//  Copyright (c) 2014 Mail.ru Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MyTargetSDK/MTRGCustomParams.h>

@interface MTRGNativeBaseAd : NSObject

//Если флаг уставновлен, то картинки будут загружены
@property (nonatomic) BOOL autoLoadImages;
//Загрузить банер (будут вызваны методы делегата)
-(void) load;
//Зарегистрировать view
-(void) registerView:(UIView*)view withController:(UIViewController*)controller;
-(void) unregisterView;

//Дополнительный параметры настройки запроса
@property (nonatomic, strong, readonly) MTRGCustomParams * customParams;

-(instancetype) initWithSlotId:(NSString*)slotId;

@end
