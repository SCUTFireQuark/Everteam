//
//  STMemo.h
//  PersonalMemo
//
//  Created by River on 14-8-28.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQMemo : NSObject

@property   NSString *summary;
@property   NSString *details;
@property   NSDate *remindTime;
@property   NSString *theme;
@property   NSNumber *isRemind;
@property   NSNumber *isHighlight;
@property   NSString *memoOrder;
@property   NSString *createTime;

@end
