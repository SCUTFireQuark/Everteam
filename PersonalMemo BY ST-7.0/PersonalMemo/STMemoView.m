//
//  STMemoView.m
//  SimpleView
//
//  Created by st2 on 15/1/9.
//  Copyright (c) 2015年 ST. All rights reserved.
//

#import "STMemoView.h"


@implementation STMemoView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //添加放大手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomUp:)];
        [self addGestureRecognizer:tap];
        //是否放大开关的初始化
        self.isZoomUp = false;
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10 , 60 , 250, 43)];
        textView.backgroundColor = [UIColor greenColor];
        textView.text = self.detail.text;
        textView.font = [UIFont systemFontOfSize:14];
        textView.editable = NO;
        textView.selectable = NO;
        self.detail = textView;
        [self addSubview:textView];

        
        
    }
    return self;
   
}
- (IBAction)changeMemoState:(id)sender {
    
    //判断当前的事“我的任务”还是“我发出的”
    if(self.delegate.selectMemoKindBar.selectedSegmentIndex==0)
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你真的确定你完成了成了任务？？" delegate:self cancelButtonTitle:@"我好虚，好像还没完成" otherButtonTitles:@"没完成我切jj", nil];
    [alert show];
    }
    
    if(self.delegate.selectMemoKindBar.selectedSegmentIndex==2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你真的确定你要给这个sb 通过审核？？" delegate:self cancelButtonTitle:@"开玩笑的，当然要他背锅背久点" otherButtonTitles:@"尼玛他是我dick to dick的好基友当然通过啊", nil];
        [alert show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
       //判断当前的事“我的任务”还是“我发出的”
      //1是确定
      if(buttonIndex==1&&self.delegate.selectMemoKindBar.selectedSegmentIndex==0)
      {
        NSLog(@"草泥马");
        //完成按钮失效
        self.finishBtn.backgroundColor=[UIColor grayColor];
        self.finishBtn.enabled=NO;
        
        self.memoStateLabel.text=@"待审查..";
        
        self.TR=[[BQMemoTransmition alloc] init];
        [self.TR  stateChangewithmemoID:self.memoID currentstate:@"待审查.."];
        
       }
      if(buttonIndex==1&&self.delegate.selectMemoKindBar.selectedSegmentIndex==2)
      {
        NSLog(@"草泥马");
        //完成按钮失效
        self.finishBtn.backgroundColor=[UIColor grayColor];
        self.finishBtn.enabled=NO;
        
        self.memoStateLabel.text=@"已通过";
       
        self.TR=[[BQMemoTransmition alloc] init];
        [self.TR  stateChangewithmemoID:self.memoID currentstate:@"已通过"];
        
       }
 
    
}

-(void)zoomUp:(UITapGestureRecognizer*)tap{
    if (!self.isZoomUp) {
    //放大
    //放大的大小
    int fixed = [self captureFixedHeight];
    self.fixHeight = fixed;
    //整体放大
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, fixed + self.frame.size.height);
    
    [self.detail setFrame:CGRectMake(10 , 60 , 250, 43 + fixed)];
        
        
    //隐藏简略的detail
    //self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y, self.detail.frame.size.width, fixed + self.detail.frame.size.height);
    //self.detail.font = [UIFont systemFontOfSize:14];
        
    //self.detail.hidden = YES;
        
//    //生成一个大的完整的view来展示detail
//    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(self.detail.frame.origin.x , self.detail.frame.origin.y , self.detail.frame.size.width, fixed +self.detail.frame.size.height)];
//    textView.backgroundColor = [UIColor greenColor];
//    textView.text = self.detail.text;
//    
//    textView.font = [UIFont systemFontOfSize:14];
//    textView.editable = NO;
//    textView.selectable = NO;
//    self.detailTextView = textView;
//    
//    [self addSubview:textView];
//        
    [self.delegate delegate_memoIsZoomUpWithOrder:self.order fixed:fixed];
        
    //设置开关
    self.isZoomUp = true;

    }else{
        
    //恢复初始
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 150);
    //设置detail
    [self.detail setFrame:CGRectMake(10 , 60 , 250, 43)];
        
    [self.delegate delegate_memoIsZoomDownWithOrder:self.order fixed:self.fixHeight];
    //关闭开关
    self.isZoomUp = false;
    }
    
    
    
}

-(int)captureFixedHeight{
    //获取detail的内容
    NSString *detail = self.detail.text;
    //制作字体大小字典
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    
    //算出适当的大小
    CGSize detailSize = [detail boundingRectWithSize:CGSizeMake(250, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    //算出需要增大的数值
    int height = detailSize.height - 40 + 20;
    return  height;

}

@end
