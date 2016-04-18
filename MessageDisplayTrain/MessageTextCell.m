//
//  MessageTextCell.m
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import "MessageTextCell.h"
#import "UIImage+PG.h"

@implementation MessageTextCell
{
    UIImageView * _bubbleView;
    UILabel * _lb;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUpSubViews];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReloadAct:) name:@"messageReload" object:nil];
    }
    return self;
}

-(void)messageReloadAct:(NSNotification *)noti
{
	NSDictionary * dic = noti.userInfo;
	MessageFrame * messageFrame = dic[@"messageFrame"];
	if (messageFrame.message.messageID != self.messageFrame.message.messageID) {
		return;
	}
	self.messageFrame = messageFrame;
}

-(void)makeUpSubViews
{
    _bubbleView = [[UIImageView alloc]init];
    [self.contentView addSubview:_bubbleView];
    
    _lb = [[UILabel alloc]init];
    _lb.numberOfLines =0;
    _lb.font = kChatTextFont;
    [_bubbleView addSubview:_lb];
}

-(void)setMessageFrame:(MessageFrame *)messageFrame
{
    [super setMessageFrame:messageFrame];
    _bubbleView.frame = self.messageFrame.bubbleF;
    _lb.frame = self.messageFrame.labelF;
    _lb.text = self.messageFrame.message.messageContent[@"text"];
    
    if (self.messageFrame.message.postUid == kCurUid) {
        _bubbleView.image = [UIImage reSizeImageWithNamed:@"chat_bubble_by_me"];
        _lb.textColor = [UIColor whiteColor];
    }else{
        _bubbleView.image = [UIImage reSizeImageWithNamed:@"chat_bubble_by_other"];
        _lb.textColor = [UIColor darkTextColor];
    }
    
    switch (self.messageFrame.message.sendState) {
        case kZCMessageWillSend:
            _bubbleView.backgroundColor = [UIColor purpleColor];
            break;
        case kZCMessageSueecssSend:
            _bubbleView.backgroundColor = [UIColor clearColor];
            break;

        case kZCMessageFailSend:
            _bubbleView.backgroundColor = [UIColor redColor];
            break;

        default:
            break;
    }
    
}
@end
