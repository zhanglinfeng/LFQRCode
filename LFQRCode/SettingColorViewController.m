//
//  SettingColorViewController.m
//  LFQRCode
//
//  Created by 张林峰 on 2017/5/16.
//  Copyright © 2017年 张林峰. All rights reserved.
//

#import "SettingColorViewController.h"
#import "UIColor+LF.h"

@interface SettingColorViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *ivColorPicker;
@property (strong, nonatomic) IBOutlet UITextField *tfR;
@property (strong, nonatomic) IBOutlet UITextField *tfG;
@property (strong, nonatomic) IBOutlet UITextField *tfB;
@property (strong, nonatomic) IBOutlet UITextField *tfO;
@property (strong, nonatomic) IBOutlet UISlider *sliderR;
@property (strong, nonatomic) IBOutlet UISlider *sliderG;
@property (strong, nonatomic) IBOutlet UISlider *sliderB;
@property (strong, nonatomic) IBOutlet UISlider *sliderO;
@property (strong, nonatomic) IBOutlet UIView *currentColorView;
@property (strong, nonatomic) UIColor *currentColor;

@end

@implementation SettingColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tapColor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColor:)];
    [_ivColorPicker addGestureRecognizer:tapColor];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downTheKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

//选取颜色
- (void)selectColor:(UITapGestureRecognizer*)recognizer {
    CGPoint tapPoint = [recognizer locationInView:self.ivColorPicker];
    CGPoint pointInImage = CGPointMake(tapPoint.x * self.ivColorPicker.image.size.width/self.ivColorPicker.frame.size.width, tapPoint.y * self.ivColorPicker.image.size.height/self.ivColorPicker.frame.size.height);
    NSLog(@"x=%f,y=%f",tapPoint.x,tapPoint.y);
    //这个判断防止点到边缘
    if (tapPoint.x > 1 && tapPoint.x < self.ivColorPicker.frame.size.width - 1 && tapPoint.y > 1 && tapPoint.y < self.ivColorPicker.frame.size.height) {
        
    }
    self.currentColor = [UIColor colorFromImage:self.ivColorPicker.image atPoint:pointInImage];
    [self updateUI];
    
}

-(void)downTheKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)OnSliderR:(id)sender {
    self.currentColor = [UIColor colorWithRed:_sliderR.value/255.0f green:_sliderG.value/255.0f blue:_sliderB.value/255.0f alpha:_sliderO.value];
    [self updateUI];
}

- (IBAction)OnSliderG:(id)sender {
    self.currentColor = [UIColor colorWithRed:_sliderR.value/255.0f green:_sliderG.value/255.0f blue:_sliderB.value/255.0f alpha:_sliderO.value];
    [self updateUI];

}

- (IBAction)OnSliderB:(id)sender {
    self.currentColor = [UIColor colorWithRed:_sliderR.value/255.0f green:_sliderG.value/255.0f blue:_sliderB.value/255.0f alpha:_sliderO.value];
    [self updateUI];
}

- (IBAction)OnSliderO:(id)sender {
    self.currentColor = [UIColor colorWithRed:_sliderR.value/255.0f green:_sliderG.value/255.0f blue:_sliderB.value/255.0f alpha:_sliderO.value];
    [self updateUI];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OK:(id)sender {
    if (self.selectColorBlock) {
        self.selectColorBlock(self.currentColor);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Method

- (void)updateUI {
    self.currentColorView.backgroundColor = self.currentColor;
    
    //获取UIColor的RGB
    CGFloat R = 0.0, G = 0.0, B = 0.0, A = 1.0;
    [self.currentColor getRed:&R green:&G blue:&B alpha:&A];
    
    _tfR.text=[NSString stringWithFormat:@"%0.2f",R*255];
    _tfG.text=[NSString stringWithFormat:@"%0.2f",G*255];
    _tfB.text=[NSString stringWithFormat:@"%0.2f",B*255];
    _tfO.text=[NSString stringWithFormat:@"%0.2f",A];
    _sliderR.value = R*255;
    _sliderG.value = G*255;
    _sliderB.value = B*255;
    _sliderO.value = A;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.currentColor = [UIColor colorWithRed:_tfR.text.floatValue/255.0f green:_tfG.text.floatValue/255.0f blue:_tfB.text.floatValue/255.0f alpha:_tfO.text.floatValue];
    [self updateUI];
}

@end
