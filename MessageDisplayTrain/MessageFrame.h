//
//  MessageFrame.h
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageFrame : NSObject

@property(nonatomic,strong)Message * message;

@property(nonatomic,assign)MessageType messageType;


@property(nonatomic,assign)CGRect iconF;
@property (assign,nonatomic)CGRect bubbleF;
@property (assign,nonatomic)CGRect labelF;
@property (assign,nonatomic)CGFloat cellHeight;

@end
