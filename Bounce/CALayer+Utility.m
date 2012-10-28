//
//  CALayer+Blocks.m
//  AnimationBlocks
//
//  Created by 吉村 篤 on 2012/10/23.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import "CALayer+Utility.h"
#import "NSString+UUID.h"

@implementation CALayer (Utility)
- (void)addBasicAnimationWithKeyPath:(NSString *)keyPath
                         construction:(void(^)(CABasicAnimation *animation))construction
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    construction(animation);
    [self addAnimation:animation forKey:[NSString stringWithUuid]];
}

- (void)addKeyframeAnimationWithKeyPath:(NSString *)keyPath
                            construction:(void(^)(CAKeyframeAnimation *animation))construction
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    construction(animation);
    [self addAnimation:animation forKey:[NSString stringWithUuid]];
}
@end
