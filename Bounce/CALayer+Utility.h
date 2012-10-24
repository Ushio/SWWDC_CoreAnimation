//
//  CALayer+Blocks.h
//  AnimationBlocks
//
//  Created by 吉村 篤 on 2012/10/23.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Utility)
- (void)bindBasicAnimationWithKeyPath:(NSString *)keyPath
                         construction:(void(^)(CABasicAnimation *animation))construction;

- (void)bindKeyframeAnimationWithKeyPath:(NSString *)keyPath
                            construction:(void(^)(CAKeyframeAnimation *animation))construction;
@end
