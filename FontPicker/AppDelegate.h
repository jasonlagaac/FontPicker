//
//  AppDelegate.h
//  FontPicker
//
//  Created by Jason Lagaac on 9/08/13.
//  Copyright (c) 2013 Jason Lagaac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>
#import <CoreData/CoreData.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

/** Core Data Context */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/** Managed Object Model */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/** Persistant Store Coordinator */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/** Save Context Actions */
- (void)saveContext;

/** Application Documents Directory Helper */
- (NSURL *)applicationDocumentsDirectory;

@end
