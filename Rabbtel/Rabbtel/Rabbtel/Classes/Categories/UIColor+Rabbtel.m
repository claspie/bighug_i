//
//  UIColor+Rabbtel.m
//  DucketsSportsCapture
//
//  Created by WangYing on 28/02/2018.
//  Copyright © 2018 Duckets. All rights reserved.
//

#import "UIColor+Rabbtel.h"

#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation UIColor (Duckets)

+ (UIColor*) appColor
{
    return RGB(1, 143, 229);
}

@end

