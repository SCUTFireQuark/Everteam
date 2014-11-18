//
//  BQMemoTransmition.m
//  PersonalMemo
//
//  Created by River on 14-10-23.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "BQMemoTransmition.h"

@interface BQMemoTransmition()

@property(nonatomic) BOOL isStartRequest;
@property (strong,nonatomic) NSMutableData *datas;
@property (strong,nonatomic) NSMutableArray *memoList;

@end

@implementation BQMemoTransmition

- (void)getRequest
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebService.asmx/recordsInDataBase"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req addValue:@"application/x-www-form-urlencoded"
forHTTPHeaderField:@"Content-type"];
    [req setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn) {
        NSLog(@"success");
        _datas = [NSMutableData new];
    }
    
}


- (void)startRequest:(BQMemo *)memoForSend
{
    self.isStartRequest=true;
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.112/WebService.asmx/createMemo"];
    
    
    
    NSString *summary = [[NSString alloc] init];
    summary = memoForSend.summary;
    
    NSLog(@"******************************%@", memoForSend.summary);
    NSString *details = [[NSString alloc] init];
    details = memoForSend.details;
    
    NSString *memoOrder = [[NSString alloc] init];
    memoOrder = nil                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           ;
    
    NSString *createTime = [[NSString alloc] init];
    createTime = memoForSend.createTime;
    
    NSString *theme = [[NSString alloc] init];
    theme = memoForSend.theme;
    
    NSString *remindTime = [[NSString alloc] init];
    NSString *date =[NSString stringWithFormat:@"%@", memoForSend.remindTime];
    remindTime = date;
    
    
    NSString *isHighlight = [[NSString alloc] init];
    isHighlight = @" ";
    
    NSString *isRemind = [[NSString alloc] init];
    isRemind = @"1";
    NSLog(@"%@",createTime);
    NSString *jsonText = [NSString stringWithFormat:@"{\"summary\":\"%@\",\"details\":\"%@\",\"memoOrder\":\"%@\",\"createTime\":\"%@\",\"theme\":\"%@\",\"remindTime\":\"%@\",\"isHighlight\":\"%@\",\"isRemind\":\"%@\",}",summary,details,memoOrder,createTime,theme,remindTime,isHighlight,isRemind];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *postString=[NSString stringWithFormat:@"jsonText=%@",jsonText];
    
    
    NSData *postData=[postString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *msgLength = [NSString stringWithFormat:@"%d",[postString length]];
    [req addValue:@"application/x-www-form-urlencoded"
forHTTPHeaderField:@"Content-type"];
    
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (connection) {
        _datas = [NSMutableData new];
        NSLog(@"success");
    }
    
    
    
}

//发送之后回调的方法
#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.datas appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",[error localizedDescription]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
    NSLog(@"请求完成！");
    NSString *result = [[NSString alloc] initWithData:self.datas encoding:NSUTF8StringEncoding];
    //如果是startRequest调用的
    if (self.isStartRequest) {
        self.isStartRequest=false;
        return;
    }
    NSLog(@"***********result:%@",result);
    MemoXMLParser *parser = [MemoXMLParser new];
    [parser start:result];
    
    NSString *jsonStr = [[NSString alloc] initWithString:parser.jsonString];
    NSLog(@"***********jsonStr:%@",jsonStr);
    
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: jsonData options:
                        NSJSONReadingAllowFragments error:nil];
    self.memoList = [dict objectForKey:@"Memo"];
    NSLog(@"memolist.count:%d",self.memoList.count);
    NSMutableDictionary *memo = [self.memoList objectAtIndex:0];
    NSString *summary = [[NSString alloc] init];
    NSString *details = [[NSString alloc] init];
    summary = [memo objectForKey: @"summary"];
    details = [memo objectForKey:@"details"];
    NSLog(@"summary:%@/n details:%@",summary,details);
    
}



@end
