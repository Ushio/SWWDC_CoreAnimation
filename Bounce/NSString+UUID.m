//
//  NSString+NSString_UUID.m
//  AdvancedCoreData
//
//  Created by yoshimura on 12/05/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)
+ (NSString *)stringWithUuid
{
    CFUUIDRef uuidObj = CFUUIDCreate(NULL); /*create*/
    CFStringRef cfstring = CFUUIDCreateString(nil, uuidObj); /*create*/
    NSString *string = (__bridge_transfer NSString *)cfstring;
    CFRelease(uuidObj);
    return string;
}
@end
