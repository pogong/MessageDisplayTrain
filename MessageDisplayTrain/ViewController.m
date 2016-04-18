//
//  ViewController.m
//  MessageDisplayTrain
//
//  Created by 张三弓 on 15/10/11.
//  Copyright (c) 2015年 张三弓. All rights reserved.
//

#import "ViewController.h"
#import "MessageDisplayController.h"
#import "ZCMessageDisplayController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"toChat" style:UIBarButtonItemStyleDone target:self action:@selector(toChatAct)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"toZCChat" style:UIBarButtonItemStyleDone target:self action:@selector(toZCChatAct)];
    
}
-(void)toChatAct
{
    MessageDisplayController * chat = [[MessageDisplayController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
}
-(void)toZCChatAct
{
    ZCMessageDisplayController * chat = [[ZCMessageDisplayController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
}

@end
