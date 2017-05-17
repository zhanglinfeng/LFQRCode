//
//  ScanCodeController.m
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "ScanCodeController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LFQRCodeUtil.h"
#import "LFImagePicker.h"

@interface ScanCodeController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) LFImagePicker *imagePicker;

@end

@implementation ScanCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect interestRect = CGRectMake(20, (self.view.frame.size.height - (self.view.frame.size.width - 40))/2.0f, self.view.frame.size.width - 40, self.view.frame.size.width - 40);
    
    
    _scanView = [[LFQRCodeScanner alloc] initWithFrame:self.view.bounds rectOfInterest:interestRect];
    _scanView.imgLine.image = [UIImage imageNamed:@"line"];
    _scanView.scanFilishBlock = ^(AVMetadataMachineReadableCodeObject *result) {
        NSURL * url = [NSURL URLWithString:result.stringValue];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [[UIApplication sharedApplication] openURL: url];
        } else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"非链接结果" message: [NSString stringWithFormat: @"%@", result.stringValue] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
            [alertView show];
        }
    };
    [self.view insertSubview:_scanView atIndex:0];//将扫描view放到底层
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.scanView start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    [self.scanView stop];
}

//从相册拿图片
- (IBAction)pickImageFromAlbum:(id)sender {
    self.imagePicker = [[LFImagePicker alloc] init];
    [self.imagePicker pickSingleImageWithController:self allowsEditing:NO resultBlock:^(UIImage *image) {
        //直接从相册的image扫二维码
        NSString *result = [LFQRCodeUtil readQRCodeFromImage:image];
        NSURL * url = [NSURL URLWithString:result];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [[UIApplication sharedApplication] openURL: url];
        } else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"非链接结果" message: [NSString stringWithFormat: @"%@", result] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

@end
