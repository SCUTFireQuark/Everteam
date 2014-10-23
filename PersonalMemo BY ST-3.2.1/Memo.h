//
//  Memo.h
//  PersonalMemo
//
//  Created by st on 14-7-10.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memo : NSManagedObject

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * remindTime;
@property (nonatomic, retain) NSString * theme;
@property (nonatomic, retain) NSNumber * isRemind;
@property (nonatomic, retain) NSNumber * isHighlight;
@property (nonatomic, retain) NSString * memoOrder;
@property (nonatomic, retain) NSString * createTime;

@end
