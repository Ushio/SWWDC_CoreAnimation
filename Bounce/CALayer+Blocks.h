//
//  CALayer+Blocks.h
//  AnimationBlocks
//
//  Created by 吉村 篤 on 2012/10/23.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Blocks)
- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key completion:(void(^)(CALayer *me))completion;
@end
