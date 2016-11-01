//
//  AppDelegate.h
//  Data Transfer Rate(DTR)
//
//  Created by Anindya Das on 11/1/16.
//  Copyright © 2016 AppsInception. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

