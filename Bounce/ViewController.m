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
@implementation ViewController
{
    NSArray *rects;
    NSTimer *animationControllTimer;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    layer.colors = @[
        (id)[UIColor colorWithRed:0.91 green:0.87 blue:0.64 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.84 green:0.96 blue:0.91 alpha:1.0].CGColor,
    ];
    layer.locations = @[@0.0, @1.0];
    [self.view.layer addSublayer:layer];
   
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
        [self.view.layer addSublayer:layer];
        [_rects addObject:layer];
    }
    rects = _rects;
    
    animationControllTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(animationTimerTick:) userInfo:nil repeats:YES];
    [self animationTimerTick:animationControllTimer];
}

- (void)animationTimerTick:(NSTimer *)sender
{
    for(int i = 0 ; i < rects.count ; ++i)
    {
        CALayer *layer = rects[i];
        
        float time = CACurrentMediaTime() + remap(i, 0, rects.count - 1, 0.0, 1.0);
        
        //フェーズ１
        const float PHESE1_DURATION = 1.0;
        //縮むアニメーション
        [layer bindBasicAnimationWithKeyPath:@"bounds" construction:^(CABasicAnimation *animation) {
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
        [layer bindBasicAnimationWithKeyPath:@"bounds" construction:^(CABasicAnimation *animation) {
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
        [layer bindKeyframeAnimationWithKeyPath:@"position.y" construction:^(CAKeyframeAnimation *animation) {
            animation.beginTime = time;
            animation.duration = PHESE3_DURATION;
            animation.values = @[@480, @100, @480];
            animation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
            ];
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
        }];
        
        [layer bindKeyframeAnimationWithKeyPath:@"anchorPoint" construction:^(CAKeyframeAnimation *animation) {
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
        
        [layer bindKeyframeAnimationWithKeyPath:@"transform" construction:^(CAKeyframeAnimation *animation) {
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
        [layer bindKeyframeAnimationWithKeyPath:@"bounds" construction:^(CAKeyframeAnimation *animation) {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
