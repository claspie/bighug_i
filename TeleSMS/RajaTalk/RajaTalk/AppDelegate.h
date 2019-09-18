//
//  AppDelegate.h
//  RajaTalk
//
//  Created by WangYing on 2018/7/6.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

