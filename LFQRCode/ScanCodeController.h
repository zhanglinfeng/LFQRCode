//
//  ScanCodeController.h
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFQRCodeScanner.h"

@interface ScanCodeController : UIViewController

@property (nonatomic, strong) LFQRCodeScanner *scanView;

@end
