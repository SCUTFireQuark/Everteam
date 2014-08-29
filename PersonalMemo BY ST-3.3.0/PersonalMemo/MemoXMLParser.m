//
//  MemoXMLParser.m
//  PersonalMemo
//
//  Created by mac on 14-8-25.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import "MemoXMLParser.h"

@implementation MemoXMLParser

-(void)start:(NSString *) memoString
{
    
    _jsonString=[NSMutableString new];
    NSData* xmlData = [memoString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser =[[NSXMLParser alloc]initWithData:xmlData];
    parser.delegate=self;
    [parser parse];
}
//在文档开始的时候触发
-(void) parserDidStartDocument:(NSXMLParser *)parser
{
    //_notes=[NSMutableArray new];
}
//在遇到第一个开始标签时触发
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentTagName=elementName;
    //把<string xmlns>的属性值输出
    /*if ([_currentTagName isEqualToString:@"string"])
    {
        NSString *string =[attributeDict objectForKey:@"xmlns"];
        NSLog(@"****string:%@",string);
    
      }
     */
}
//在遇到字符串时触发
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //由于xml太长，解析会把开始标签和结束标签之间的string分开若干段，因此采用拼接到_jsonString的方法
    [_jsonString appendString:string];
    //NSLog(@"parser:string:%@",string);
   
}
//在遇到结束标签时触发
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentTagName=nil;
    //NSLog(@"reach endElement");
}
//在文档结束时触发
-(void)parserDidEndDocument:(NSXMLParser *)parser   {
    //self.notes=nil;
}
@end
