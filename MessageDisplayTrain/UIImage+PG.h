//
//  UIImage+PG.h
//  PogongWeibo
//
//  Created by qianfeng on 14-10-4.
//  Copyright (c) 2014年 Pogong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PG)

+(UIImage *)reSizeImageWithNamed:(NSString *)name;
+(UIImage *)reSizeImageWithNamed:(NSString *)name left:(float)left top:(float)top;

-(UIViewContentMode )setContentModeWithImageSize;

+(CGSize)setShowSizeWithImageSize:(CGSize)imageSize;

-(UIImage *)makeHDImage;

@end
