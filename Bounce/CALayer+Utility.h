//
//  CALayer+Blocks.h
//  AnimationBlocks
//
//  Created by 吉村 篤 on 2012/10/23.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/**
 *blocksを使って使いやすく
 */
@interface CALayer (Utility)
- (void)addBasicAnimationWithKeyPath:(NSString *)keyPath
                         construction:(void(^)(CABasicAnimation *animation))construction;

- (void)addKeyframeAnimationWithKeyPath:(NSString *)keyPath
                            construction:(void(^)(CAKeyframeAnimation *animation))construction;
@end
