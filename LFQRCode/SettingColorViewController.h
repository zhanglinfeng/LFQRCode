//
//  SettingColorViewController.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/5/16.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingColorViewController : UIViewController

@property (nonatomic, copy) void(^selectColorBlock)(UIColor *color);

@end
