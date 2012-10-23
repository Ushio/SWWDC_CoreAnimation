//
//  ViewController.m
//  Bounce
//
//  Created by 吉村 篤 on 2012/10/22.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+Blocks.h"

static double remap(double value, double inputMin, double inputMax, double outputMin, double outputMax)
{
    return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
}

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CALayer *rect = [CALayer layer];
    rect.bounds = (CGRect){0, 0, 50, 70};
    rect.anchorPoint = (CGPoint){0.5, 1.0};
    rect.position = (CGPoint){160, 480};
    rect.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:rect];
    
    CABasicAnimation *prepareAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    prepareAnimation.fromValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 70}];
    prepareAnimation.toValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 20}];
    prepareAnimation.duration = 1.0;
    prepareAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.0:0.7:0.3:1.0];
    prepareAnimation.removedOnCompletion = NO;
    prepareAnimation.fillMode = kCAFillModeForwards;
    
    [rect addAnimation:prepareAnimation forKey:@"prepareAnimation" completion:^(CALayer *me1) {
        CABasicAnimation *jumpTransAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        jumpTransAnimation.fromValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 20}];
        jumpTransAnimation.toValue = [NSValue valueWithCGRect:(CGRect){0, 0, 50, 70}];
        jumpTransAnimation.duration = 0.1;
        jumpTransAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        jumpTransAnimation.removedOnCompletion = NO;
        jumpTransAnimation.fillMode = kCAFillModeForwards;
        [me1 addAnimation:jumpTransAnimation forKey:@"jumpTransAnimation"];
        
        CAKeyframeAnimation *yAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        yAnimation.values = @[@480, @160, @480];
        yAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
        ];
        yAnimation.removedOnCompletion = NO;
        yAnimation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *anchorPointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
        anchorPointAnimation.values = @[
            [NSValue valueWithCGPoint:(CGPoint){0.5, 1.0}],
            [NSValue valueWithCGPoint:(CGPoint){0.5, 0.5}],
            [NSValue valueWithCGPoint:(CGPoint){0.5, 0.0}],
        ];
        anchorPointAnimation.removedOnCompletion = NO;
        anchorPointAnimation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        rotateAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DIdentity],
            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 0.5, 0, 0, 1)],
            [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI - FLT_EPSILON, 0, 0, 1)],
        ];
        rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.65:0.0:0.35:1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[yAnimation, rotateAnimation, anchorPointAnimation];
        group.duration = 2.0;
        [me1 addAnimation:group forKey:@"ani" completion:^(CALayer *me2) {
            CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
            
            NSMutableArray *values = [NSMutableArray array];
            for(int i = 0 ; i < 45 ; ++i)
            {
                double t = remap(i, 0, 44, 0.0, 1.0);
                
                double h = 70.0 - sin(M_PI * 2.0 * t * 4.0) * (1.0 - t) * 30.0;
                [values addObject:[NSValue valueWithCGRect:(CGRect){0, 0, 50, h}]];
            }
            bounceAnimation.values = values;
            
            bounceAnimation.duration = 1.1;
            bounceAnimation.removedOnCompletion = NO;
            bounceAnimation.fillMode = kCAFillModeForwards;
            [me2 addAnimation:bounceAnimation forKey:@"bounceAnimation" completion:^(CALayer *me) {
                
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
