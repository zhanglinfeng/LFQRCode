//
//  CreateQRCodeController.m
//  LFQRCode
//
//  Created by 张林峰 on 2017/4/26.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "CreateQRCodeController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LFQRCodeUtil.h"
#import "UIColor+LF.h"
#import "LFImagePicker.h"
#import "SettingColorViewController.h"

@interface CreateQRCodeController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *ivLogo;
@property (strong, nonatomic) IBOutlet UIButton *btSelectColor;
@property (strong, nonatomic) IBOutlet UISlider *sliderShadow;
@property (strong, nonatomic) IBOutlet UIImageView *ivCodeResult;//生成的二维码
@property (strong, nonatomic) IBOutlet UITextField *tfInput;

@property (strong, nonatomic) UIColor *selectedColor;
@property (nonatomic, strong) LFImagePicker *imagePicker;

@end

@implementation CreateQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    //收起键盘手势
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downTheKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Action

//选取颜色
- (IBAction)selectColor:(id)sender {
    SettingColorViewController *vc = [[SettingColorViewController alloc] init];
    vc.selectColorBlock = ^(UIColor *color) {
        self.selectedColor = color;
        self.btSelectColor.backgroundColor = self.selectedColor;
    };
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)shadowValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.ivCodeResult.layer.shadowOffset = CGSizeMake(self.sliderShadow.value, slider.value);  // 设置阴影的偏移量
}

//相册选logo
- (IBAction)pickLogo:(id)sender {
    self.imagePicker = [[LFImagePicker alloc] init];
    [self.imagePicker pickSingleImageWithController:self allowsEditing:YES resultBlock:^(UIImage *image) {
        self.ivLogo.image = image;
    }];
}

//生成二维码
- (IBAction)creatCode:(id)sender {
    UIImage *imageCode = [LFQRCodeUtil createQRimageString:self.tfInput.text sizeWidth:720 fillColor:self.selectedColor logo:self.ivLogo.image];
    self.ivCodeResult.image = imageCode;
    
    self.ivCodeResult.layer.shadowOffset = CGSizeMake(self.sliderShadow.value, self.sliderShadow.value);  // 设置阴影的偏移量
    self.ivCodeResult.layer.shadowRadius = 1;  // 设置阴影的半径
    self.ivCodeResult.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    self.ivCodeResult.layer.shadowOpacity = 0.4; // 设置阴影的不透明度
}

//保存
- (IBAction)saveCode:(id)sender {
    //Frame较大的临时图片用于截图(不直接截图ivCodeResult，是因为ivCodeResult的Frame太小)
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.ivCodeResult.image.size.width, self.ivCodeResult.image.size.height)];
    tempImageView.backgroundColor = [UIColor clearColor];//注意：背景透明才会有阴影
    tempImageView.layer.shadowOffset = CGSizeMake(self.sliderShadow.value * [UIScreen mainScreen].scale, self.sliderShadow.value * [UIScreen mainScreen].scale);  // 设置阴影的偏移量
    tempImageView.layer.shadowRadius = self.sliderShadow.value * [UIScreen mainScreen].scale;  // 设置阴影的半径
    tempImageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    tempImageView.layer.shadowOpacity = 0.5; // 设置阴影的不透明度
    tempImageView.image = self.ivCodeResult.image;
    
    //因为tempImageView是透明背景，这里不能直接截图tempImageView，否则会出现空隙部分是黑色。处理办法是将tempImageView放到另一个tempView中且tempView不能透明，然后保存tempView的截图
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ivCodeResult.image.size.width, self.ivCodeResult.image.size.height)];
    tempView.backgroundColor = [UIColor whiteColor];
    [tempView addSubview:tempImageView];
    
    //截图
    UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, YES, 0);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//存入本地相册回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UILabel *lbTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 30, self.view.frame.size.width, 30)];
    lbTips.backgroundColor = [UIColor orangeColor];
    lbTips.textColor = [UIColor whiteColor];
    lbTips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbTips];
    if (error) {
        lbTips.text = @"保存失败";
    } else {
        lbTips.text = @"保存成功";
    }
    [UIView animateWithDuration:0.5 animations:^{
        lbTips.frame = CGRectMake(0, 64, self.view.frame.size.width, 30);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:3 options:0 animations:^{
            lbTips.frame = CGRectMake(0, 64 - 30, self.view.frame.size.width, 30);
        } completion:^(BOOL finished) {
            [lbTips removeFromSuperview];
        }];
    }];
}

//收键盘
-(void)downTheKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - 手势回调

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.view]) {
        return NO;
    }
    return YES;
}

@end
