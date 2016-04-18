//
//  UIImage+PG.m
//  PogongWeibo
//
//  Created by qianfeng on 14-10-4.
//  Copyright (c) 2014年 Pogong. All rights reserved.
//

#import "UIImage+PG.h"

#define kMaxHDNomalWH 1280
#define kMinHDUnNomalWH 400

#define kMaxTHNomalWH 400

@implementation UIImage (PG)


+(UIImage *)reSizeImageWithNamed:(NSString *)name
{
    return [UIImage reSizeImageWithNamed:name left:0.5 top:0.5];
}

+(UIImage *)reSizeImageWithNamed:(NSString *)name left:(float)left top:(float)top
{
    UIImage * image=[self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*left topCapHeight:image.size.height*top];
}

-(UIViewContentMode )setContentModeWithImageSize{
    CGFloat imageW = self.size.width;
    CGFloat imageH = self.size.height;
    if(imageW/imageH >= 3){
        return UIViewContentModeScaleAspectFill;
    }else if(imageH/imageW >= 3){
        return UIViewContentModeScaleAspectFill;
    }else{
        return UIViewContentModeScaleToFill;
    }
}

+(CGSize)setShowSizeWithImageSize:(CGSize)imageSize
{
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    
    if(imageW/imageH >= 3){
        return CGSizeMake(150, 50);//横
    }else if(imageH/imageW >= 3){
        return CGSizeMake(50, 150);
    }else{
        if (imageW > imageH) {
            return  CGSizeMake(150, 150*imageH/imageW);//横
        }else{
            return CGSizeMake(150*imageW/imageH, 150);
        }
    }
}

@end
