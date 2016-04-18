//
//  ZCMessageDisplayController.m
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import "ZCMessageDisplayController.h"
#import "InputToolBar.h"
#import "MessageFrame.h"
#import "MessageTextCell.h"

#define kTextInputHeight 50.0

#define kBoardInputHeight 215.0

@interface ZCMessageDisplayController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    InputToolBar * _inputToolBar;
    NSMutableArray * _dataArr;
}
@end

@implementation ZCMessageDisplayController

-(void)dealloc
{
    [_inputToolBar removeObserver:self forKeyPath:@"frame"];
    [_inputToolBar.inTextView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray * arr = @[@"000000000000000000000",
                      @"111111111111111111111111111111111111111111111111111111111111111111111111",
                      @"22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222",
                      @"333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333",
                      @"444444",
                      @"555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555",
                      @"66666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666",
                      @"777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777",
                      @"888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888",
                      @"99999999999999999999999999999999999999999999999999999999999999999999999999999999"];
    _dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < arr.count; i++) {
        Message * message = [Message new];
        message.messageType = kZCMessageText;
        message.messageContent = @{@"type":@1,@"text":arr[i]};
        if (i%2==0) {
            message.postUid = 1111;
        }else{
            message.postUid = 1112;
        }
        MessageFrame * messageFrame = [MessageFrame new];
        messageFrame.message = message;
        [_dataArr addObject:messageFrame];
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardSendAct:) name:@"keyBoardSend" object:nil];
    
    [self setUpTableView];
    [self setUpInputBar];
    
}

-(void)keyBoardSendAct:(NSNotification *)noti
{
    Message * message = [Message new];
    message.messageType = kZCMessageText;
    message.messageContent = @{@"type":@1,@"text":_inputToolBar.inTextView.text};
    message.postUid = 1111;
    
    MessageFrame * messageFrame = [MessageFrame new];
    messageFrame.message = message;
    
    [_inputToolBar.inTextView setText:nil];
    
    [self performSelector:@selector(netPartWorkWithMessage:) withObject:messageFrame afterDelay:0.15];
    
}

-(void)netPartWorkWithMessage:(MessageFrame *)messageFrame
{
    if (_dataArr.count%2) {
        messageFrame.message.sendState = kZCMessageSueecssSend;
    }else{
        messageFrame.message.sendState = kZCMessageFailSend;
    }
    [self addMessage:messageFrame];
}

- (void)finishSendMessageWithBubbleMessageType:(MessageType)messageType {
    switch (messageType) {
        case kZCMessageText: {
            [_inputToolBar.inTextView setText:nil];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                _inputToolBar.inTextView.enablesReturnKeyAutomatically = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _inputToolBar.inTextView.enablesReturnKeyAutomatically = YES;
                    [_inputToolBar.inTextView reloadInputViews];
                });
            }
            break;
        }
        case kZCMessageImage: {
            break;
        }
        case kZCMessageLoc: {
            break;
        }
        default:
            break;
    }
}

//
- (void)addMessage:(MessageFrame *)messageFrame
{
    WS(weakSelf);
    [self exChangeMessageDataSourceQueue:^{
        [_dataArr addObject:messageFrame];
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexPaths addObject:[NSIndexPath indexPathForRow:_dataArr.count - 1 inSection:0]];
        
        [weakSelf exMainQueue:^{
            [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf scrollToLastCell:YES];
        }];
    }];
}

- (void)exChangeMessageDataSourceQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), queue);
}

- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark setUpAct
-(void)setUpInputBar
{
    _inputToolBar = [[InputToolBar alloc]initWithFrame:CGRectZero];
    _inputToolBar.inTextView.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:_inputToolBar];
    _inputToolBar.inTextView.enablesReturnKeyAutomatically = YES;
    
    [_inputToolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    _inputToolBar.frame =  CGRectMake(0, MAIN_SCREEN_H - 64 - kTextInputHeight, MAIN_SCREEN_W, kTextInputHeight);
    
    [_inputToolBar.inTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        UIEdgeInsets insets = UIEdgeInsetsZero;
        insets.bottom = MAIN_SCREEN_H - 64 - _inputToolBar.frame.origin.y;
        _tableView.contentInset = insets;
        [self scrollToLastCell:NO];
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        NSValue * newV = change[@"new"];
        NSValue * oldV = change[@"old"];
        
        CGFloat newH = [newV CGSizeValue].height;
        CGFloat oldH = [oldV CGSizeValue].height;
        
        if (oldH < 36.0) {
            return;
        }
        
        [self zcLayoutAndAnimateMessageInputTextViewWithNewContenth:newH oldContenth:oldH];
        
    }
}

-(void)zcLayoutAndAnimateMessageInputTextViewWithNewContenth:(CGFloat)newContenth oldContenth:(CGFloat)oldContenth
{
    CGFloat maxHeight = 93.0;
    
    CGFloat changeInHeight = MIN(maxHeight, newContenth) - MIN(maxHeight, oldContenth);
    
    if(!(changeInHeight > 0.0&&maxHeight + 14 <= _inputToolBar.frame.size.height)){
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             CGRect inputFrame = _inputToolBar.frame;
                             inputFrame.size.height = MIN(maxHeight, _inputToolBar.inTextView.contentSize.height)  + 14;
                             inputFrame.origin.y = inputFrame.origin.y - changeInHeight;
                             _inputToolBar.frame = inputFrame;
                             
                             CGRect textViewFrame = _inputToolBar.inTextView.frame;
                             textViewFrame.size.height = MIN(maxHeight, _inputToolBar.inTextView.contentSize.height);
                             _inputToolBar.inTextView.frame = textViewFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    if (newContenth > maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f,_inputToolBar.inTextView.contentSize.height - _inputToolBar.inTextView.frame.size.height);
                           [_inputToolBar.inTextView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

-(void)setUpTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor redColor];
    
    //timemark
    [_tableView registerClass:[MessageTextCell class] forCellReuseIdentifier:@"MessageTextCell"];
    
}

-(void)scrollToLastCell:(BOOL)animated
{
    NSInteger count = [_tableView numberOfRowsInSection:0];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void)keyboardShow:(NSNotification *)noti
{
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float time=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:time animations:^{
        CGRect inputFrame = _inputToolBar.frame;
        inputFrame.origin.y = MAIN_SCREEN_H - 64 - frame.size.height - inputFrame.size.height;
        _inputToolBar.frame = inputFrame;
    }];
    [self scrollToLastCell:YES];
}
-(void)keyboardHide:(NSNotification *)noti
{
    float time=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:time animations:^{
        CGRect inputFrame = _inputToolBar.frame;
        inputFrame.origin.y = MAIN_SCREEN_H - 64 - inputFrame.size.height;
        _inputToolBar.frame = inputFrame;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrame * messageFrame = _dataArr[indexPath.row];
    return messageFrame.cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTextCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"MessageTextCell"];
    MessageFrame * messageFrame = _dataArr[indexPath.row];
    cell.messageFrame = messageFrame;
    return cell;
}

@end

