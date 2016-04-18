//
//  Message.h
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kZCMessageText = 1,
    kZCMessageImage,
    kZCMessageLoc,
    kZCMessageVoice
} MessageType;

typedef enum {
    kZCMessageWillSend = 1,
    kZCMessageSueecssSend,
    kZCMessageFailSend
} MessageSendState;

@interface Message : NSObject

@property(nonatomic,assign)NSInteger messageID;

@property(nonatomic,assign)NSInteger postUid;
@property(nonatomic,assign)MessageType messageType;
@property(nonatomic,strong)NSDictionary * messageContent;
@property(nonatomic,assign)MessageSendState sendState;

@end
