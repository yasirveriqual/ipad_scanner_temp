//
//  NavigationController.h
//  iPadScanner
//
//  Created by Adeel on 1/23/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface NavigationController : UINavigationController <MainViewControllerDelegate>

@property (nonatomic, retain) MainViewController *mainViewController;

- (void)didLogout;
@end
