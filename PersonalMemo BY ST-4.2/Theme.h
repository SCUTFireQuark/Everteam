//
//  Theme.h
//  PersonalMemo
//
//  Created by st on 14-9-29.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Theme : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *themeID;

@end
