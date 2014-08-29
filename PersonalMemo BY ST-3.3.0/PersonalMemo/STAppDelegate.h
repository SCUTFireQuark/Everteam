//
//  STAppDelegate.h
//  PersonalMemo
//
//  Created by st on 14-7-10.
//  Copyright (c) 2014年 st. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic)NSString *presentThemeName;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
