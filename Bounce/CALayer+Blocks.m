//
//  CALayer+Blocks.m
//  AnimationBlocks
//
//  Created by 吉村 篤 on 2012/10/23.
//  Copyright (c) 2012年 吉村 篤. All rights reserved.
//

#import "CALayer+Blocks.h"

@interface BlocksPlaceholder : NSObject
@property (nonatomic, copy) void (^completion)(CALayer *);
@property (weak, nonatomic) CALayer *layer;
@end
@implementation BlocksPlaceholder
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.completion)
        self.completion(self.layer);
}
@end

@implementation CALayer (Blocks)
- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key completion:(void(^)(CALayer *me))completion
{
    BlocksPlaceholder *placeholder = [[BlocksPlaceholder alloc] init];
    placeholder.completion = completion;
    placeholder.layer = self;
    anim.delegate = placeholder;
    [self addAnimation:anim forKey:key];
    [self setValue:placeholder forKey:[key stringByAppendingString:@"Placeholder"]];
}
@end
