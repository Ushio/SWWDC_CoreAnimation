//
//  ViewController.m
//  Bounce
//
//  Created by 吉村 篤 on 2012/10/22.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Utility.h"
/**
 *ユーティリティ関数
 */

/**
 *マップ変換
 *@param value 入力値
 *@param inputMin 入力値の基準最小値
 *@param inputMax 入力値の基準最大値
 *@param outputMin 出力値の基準最小値
 *@param outputMax 出力値の基準最大値
 * ex)
 * remap(5, 0, 10, 0, 100) -> 50
 */
static double remap(double value, double inputMin, double inputMax, double outputMin, double outputMax)
{
    return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

/**
 *範囲繰り返し
 *@param value 入力値
 *@param rangeMin 繰り返し開始値
 *@param rangeMax 繰り返し終了値
 * ex)
 * rolled_over(1.5, 0, 1) -> 0.5
 * rolled_over(2.5, 0, 1) -> 0.5
 */
static double rolled_over(double value, double rangeMin, double rangeMax)
{
    if(rangeMin <= value && value <= rangeMax)
    {
        return value;
    }
    
    double step = rangeMax - rangeMin;
    if(value < rangeMin)
    {
        double shortage = rangeMin - value;
        int count = (int)(floor(shortage / step) + 1.0);
        return value + step * count;
    }
    
    if(rangeMax < value)
    {
        double above = value - rangeMax;
        int count = (int)(floor(above / step) + 1.0);
        return value - step * count;
    }
    return 0;
}
/**
 *クラス実装
 */
@implementation ViewController
{
    __weak IBOutlet UIButton *startButton;
    
    NSArray *rects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*背景のグラデーション*/
    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
    gradientlayer.frame = self.view.bounds;
    gradientlayer.colors = @[
        (id)[UIColor colorWithRed:0.91 green:0.87 blue:0.64 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.84 green:0.96 blue:0.91 alpha:1.0].CGColor,
    ];
    gradientlayer.locations = @[@0.0, @1.0];
    gradientlayer.startPoint = CGPointMake(0, 0); /*左上から*/
    gradientlayer.endPoint = CGPointMake(1, 1);   /*右上まで*/
    [self.view.layer addSublayer:gradientlayer];
    
    /*矩形一つ一つのsettei*/
    float hue, saturation, brightness;
    [[UIColor blueColor] getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    
    NSMutableArray *_rects = [NSMutableArray array];
    for(int i = 0 ; i < 5 ; ++i)
    {
        float x = remap(i, 0, 4, 30, 290);
        UIColor *color = [UIColor colorWithHue:rolled_over(hue + 0.2 * i, 0.0, 1.0) saturation:saturation brightness:brightness alpha:1.0];
        
        CALayer *layer = [CALayer layer];
        layer.bounds = (CGRect){0, 0, 50, 70};
        layer.anchorPoint = (CGPoint){0.5, 1.0};
        layer.position = (CGPoint){x, 480};
        layer.backgroundColor = color.CGColor;
        layer.cornerRadius = 4.0;
        layer.borderWidth = 1.0;
        layer.borderColor = [UIColor grayColor].CGColor;
        [self.view.layer addSublayer:layer];
        [_rects addObject:layer];
    }
    rects = _rects;
    
    [self.view bringSubviewToFront:startButton];
}

/**
 *アニメーション開始
 */
- (IBAction)onStartButton:(id)sende
{
    startButton.enabled = NO;
    startButton.alpha = 0.5;
    
    for(int i = 0 ; i < rects.count ; ++i)
    {
        CALayer *layer = rects[i];
        
        //右にいくごとにアニメーション開始が遅延される
        float beginTime = CACurrentMediaTime() + remap(i, 0, rects.count - 1, 0.0, 1.0);
        
        //フェーズ１
        const float PHESE1_DURATION = 1.0;
        //縮むアニメーション
        [layer addBasicAnimationWithKeyPath:@"bounds.size.height" construction:^(CABasicAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE1_DURATION;
            animation.fromValue = @70;
            animation.toValue = @20;
            animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0:0.7:0.3:1.0];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        [layer addBasicAnimationWithKeyPath:@"bounds.size.width" construction:^(CABasicAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE1_DURATION;
            animation.fromValue = @50;
            animation.toValue = @60;
            animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0:0.7:0.3:1.0];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        beginTime += PHESE1_DURATION;
        
        //フェーズ２
        const float PHESE2_DURATION = 0.05f;
        //はじけるアニメーション
        [layer addBasicAnimationWithKeyPath:@"bounds.size.height" construction:^(CABasicAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE2_DURATION;
            animation.fromValue = @20;
            animation.toValue = @70;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        [layer addBasicAnimationWithKeyPath:@"bounds.size.width" construction:^(CABasicAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE2_DURATION;
            animation.fromValue = @60;
            animation.toValue = @50;
            animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0:0.7:0.3:1.0];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        beginTime += PHESE2_DURATION;
        
        //フェーズ３
        //ジャンプアニメーション
        const float PHESE3_DURATION = 1.0;
        [layer addKeyframeAnimationWithKeyPath:@"position.y" construction:^(CAKeyframeAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE3_DURATION;
            animation.values = @[@480, @100, @480];
            animation.timingFunctions = @[
                [CAMediaTimingFunction functionWithControlPoints:0.0:0.6:0.4:1.0],
                [CAMediaTimingFunction functionWithControlPoints:0.6:0.0:1.0:0.4],
            ];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        
        [layer addKeyframeAnimationWithKeyPath:@"anchorPoint.y" construction:^(CAKeyframeAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE3_DURATION;
            animation.values = @[@1.0, @0.5, @0.0];
            animation.timingFunctions = @[
                [CAMediaTimingFunction functionWithControlPoints:0.0:0.6:0.4:1.0],
                [CAMediaTimingFunction functionWithControlPoints:0.6:0.0:1.0:0.4],
            ];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        
        [layer addKeyframeAnimationWithKeyPath:@"transform.rotation.z" construction:^(CAKeyframeAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE3_DURATION;
            animation.values = @[@0.0, @(M_PI)];
            animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7:0.0:0.3:1.0];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        
        beginTime += PHESE3_DURATION;
        
        
        //フェーズ４
        //ぷるぷるアニメーション
        const float PHESE4_DURATION = 1.1f;
        [layer addKeyframeAnimationWithKeyPath:@"bounds" construction:^(CAKeyframeAnimation *animation) {
            animation.beginTime = beginTime;
            animation.duration = PHESE4_DURATION;
            NSMutableArray *values = [NSMutableArray array];
            const double AMPLITUDE = 30.0;
            for(int i = 0 ; i < 45 ; ++i)
            {
                double t = remap(i, 0, 44, 0.0, 1.0);
                
                double h = 70.0 - sin(M_PI * 2.0 * t * 4.0) * (1.0 - t) * AMPLITUDE;
                double w = remap(h - 70, -AMPLITUDE, AMPLITUDE, 60, 40);
                [values addObject:[NSValue valueWithCGRect:CGRectMake(0, 0, w, h)]];
            }
            animation.values = values;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self; /* retain */
            [animation setValue:@(i) forKey:@"layerIndex"];
        }];
        beginTime += PHESE4_DURATION;
    }
}

/**
 *アニメーション完了時
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    int layerIndex = [[anim valueForKey:@"layerIndex"] intValue];
    if(layerIndex == 4)
    {
        for(CALayer *layer in rects)
        {
            [layer removeAllAnimations];
        }
        
        startButton.enabled = YES;
        startButton.alpha = 1.0;
    }
}

@end
