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

static double remap(double value, double inputMin, double inputMax, double outputMin, double outputMax)
{
    return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

@implementation ViewController
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CALayer *rectLayer = [CALayer layer];
    rectLayer.bounds = (CGRect){0, 0, 50, 70};
    rectLayer.anchorPoint = (CGPoint){0.5, 1.0};
    rectLayer.position = (CGPoint){160, 480};
    rectLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:rectLayer];
    
    float time = CACurrentMediaTime();
    //フェーズ１
    const float PHESE1_DURATION = 1.0;
    //縮むアニメーション
    [rectLayer bindBasicAnimationWithKeyPath:@"bounds" construction:^(CABasicAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE1_DURATION;
        animation.fromValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 70}];
        animation.toValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 20}];
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0:0.7:0.3:1.0];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];
    time += PHESE1_DURATION;
    
    //フェーズ２
    const float PHESE2_DURATION = 0.05f;
    //はじけるアニメーション
    [rectLayer bindBasicAnimationWithKeyPath:@"bounds" construction:^(CABasicAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE2_DURATION;
        animation.fromValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 20}];
        animation.toValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 70}];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];
    time += PHESE2_DURATION;
    
    //フェーズ３
    //ジャンプアニメーション
    const float PHESE3_DURATION = 1.0;
    [rectLayer bindKeyframeAnimationWithKeyPath:@"position.y" construction:^(CAKeyframeAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE3_DURATION;
        animation.values = @[@480, @160, @480];
        animation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
        ];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];
    
    [rectLayer bindKeyframeAnimationWithKeyPath:@"anchorPoint" construction:^(CAKeyframeAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE3_DURATION;
        animation.values = @[
            [NSValue valueWithCGPoint:(CGPoint){0.5, 1.0}],
            [NSValue valueWithCGPoint:(CGPoint){0.5, 0.5}],
            [NSValue valueWithCGPoint:(CGPoint){0.5, 0.0}],
        ];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];
    
    [rectLayer bindKeyframeAnimationWithKeyPath:@"transform" construction:^(CAKeyframeAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE3_DURATION;
        animation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DIdentity],
            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 0.5, 0, 0, 1)],
            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI - FLT_EPSILON, 0, 0, 1)],
        ];
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.65:0.0:0.35:1.0];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];
    time += PHESE3_DURATION;

    
    //フェーズ４
    const float PHESE4_DURATION = 1.1f;
    [rectLayer bindKeyframeAnimationWithKeyPath:@"bounds" construction:^(CAKeyframeAnimation *animation) {
        animation.beginTime = time;
        animation.duration = PHESE4_DURATION;
        NSMutableArray *values = [NSMutableArray array];
        for(int i = 0 ; i < 45 ; ++i)
        {
            double t = remap(i, 0, 44, 0.0, 1.0);
            
            double h = 70.0 - sin(M_PI * 2.0 * t * 4.0) * (1.0 - t) * 30.0;
            [values addObject:[NSValue valueWithCGRect:(CGRect){0, 0, 50, h}]];
        }
        animation.values = values;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }];

    time += PHESE4_DURATION;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
