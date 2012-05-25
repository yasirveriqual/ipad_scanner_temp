//
//  iPadScannerAppDelegate.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ActivityView.h"
#import "Bluetooth.h"
#import "Reachability.h"


@interface iPadScannerAppDelegate : NSObject <UIApplicationDelegate> {
    Reachability* internetReachable;
    Reachability* hostReachable;
	NetworkStatus internetStatus;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;
@property (nonatomic, retain) IBOutlet ActivityView *activityView;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readwrite) BOOL isLoggingIn;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)userDidLoggedIn;
- (void)userDidLoggedOut;


@end
