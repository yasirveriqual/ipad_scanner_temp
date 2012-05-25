//
//  ViewController.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceManager.h"
#import "Bluetooth.h"
#import "ActivityView.h"

@interface ViewController : UIViewController <ServiceManagerDelegate, BluetoothDelegate>    {
    ActivityView *activityView;
}

@property (nonatomic, retain) ServiceManager *serviceManager;


- (void)showActivity;
- (void)hideActivity;


@end
