//
//  InputToolBar.h
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kInputToolBarDown = 1,
	kInputToolBarMid,
	kInputToolBarUp
} InputToolBarState;

@interface InputToolBar : UIView

@property(nonatomic,weak)UITextView * inTextView;

@end
