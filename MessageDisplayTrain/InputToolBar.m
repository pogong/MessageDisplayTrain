//
//  InputToolBar.m
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import "InputToolBar.h"

@interface InputToolBar ()<UITextViewDelegate>

@end

@implementation InputToolBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self setUpSubViews];
    }
    return self;
}
-(void)setUpSubViews
{
    UITextView * inTextView = [[UITextView alloc]init];
    _inTextView = inTextView;
    _inTextView.delegate = self;
    _inTextView.returnKeyType = UIReturnKeySend;
    _inTextView.layer.borderWidth = 0.1;
    _inTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _inTextView.layer.cornerRadius = 5.0;
    _inTextView.layer.masksToBounds = YES;
    _inTextView.frame = CGRectMake(7, 7, MAIN_SCREEN_W - 14, 36);
    [self addSubview:_inTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0){
        
    }else{
        if ([@"\n" isEqualToString:text]) {//点击 回车
            [[NSNotificationCenter defaultCenter] postNotificationName:@"keyBoardSend" object:nil];
            return NO;
        }else{
            
        }
    }
    return YES;
}

@end
