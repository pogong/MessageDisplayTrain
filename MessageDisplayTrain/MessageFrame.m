//
//  MessageFrame.m
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import "MessageFrame.h"
#define kChat_Air_Space 10

#define kMinVoiceW 320/4
#define kMaxVoiceW 320/3*1.8

#define kIconHW 40

#define kMinCellHeight kIconHW + 2*kChat_Air_Space
@implementation MessageFrame

-(void)setMessage:(Message *)message
{
    _message = message;
    switch (message.messageType) {
        case 1:{
            [self calculateTextMessageFrame];
        }break;
            
        default:
            break;
    }
}

-(void)calculateTextMessageFrame
{
    NSString * zcContentString = [NSString stringWithFormat:@"%@",_message.messageContent[@"text"]];
    CGSize labelSize ;
    if (MAIN_SCREEN_W > 320) {
        labelSize = [zcContentString sizeWithFont:kChatTextFont constrainedToSize:CGSizeMake(MAIN_SCREEN_W - 140 - 30, MAXFLOAT)];
    }else{
        labelSize = [zcContentString sizeWithFont:kChatTextFont constrainedToSize:CGSizeMake(MAIN_SCREEN_W - 140 , MAXFLOAT)];
    }
    
    CGFloat singleLineFix = 0;
    
    if (labelSize.height < 21) {  //单行
        
        singleLineFix = (40 - labelSize.height)/2 - kChat_Air_Space;
        
    }else{                       //多行
        
        if (MAIN_SCREEN_W > 320) {
            labelSize.width = MAIN_SCREEN_W - 140 - 30;
        }else{
            labelSize.width = MAIN_SCREEN_W - 140;
        }
        
    }
    
    CGSize bubbleSize = CGSizeMake((labelSize.width + 3*kChat_Air_Space)>50?(labelSize.width + 3*kChat_Air_Space):50,
                                   (labelSize.height + 2*kChat_Air_Space)>40?(labelSize.height + 2*kChat_Air_Space):40);
    
    if (_message.postUid == kCurUid) {
        _labelF = (CGRect){{kChat_Air_Space,kChat_Air_Space + singleLineFix },labelSize};
        _bubbleF = (CGRect){{MAIN_SCREEN_W - bubbleSize.width - (kChat_Air_Space/2 + kIconHW + kChat_Air_Space), kChat_Air_Space},bubbleSize};
    }else{
        _labelF = (CGRect){{kChat_Air_Space+kChat_Air_Space,kChat_Air_Space + singleLineFix},labelSize};
        _bubbleF = (CGRect){{kChat_Air_Space+kIconHW+kChat_Air_Space/2,kChat_Air_Space},bubbleSize};
    }
    _cellHeight = _bubbleF.size.height > kIconHW? kChat_Air_Space + _bubbleF.size.height + kChat_Air_Space : kMinCellHeight;
    
}

@end
