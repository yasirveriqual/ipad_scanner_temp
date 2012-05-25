//
//  LoginViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "ViewController.h"

@class NavigationController;
@interface LoginViewController : ViewController <UITextFieldDelegate, UINavigationControllerDelegate> {
    BOOL isKeyboardShown;
}

@property (nonatomic, retain) NSTimer *menuTimer;

@property (nonatomic, retain) IBOutlet UIView *innerView;
@property (nonatomic, retain) IBOutlet UIView *loginView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UIButton *menuButton;

@property (nonatomic, retain) NavigationController *navController;

@property (nonatomic, retain) IBOutlet UIButton *btnLogin;

- (IBAction)loginPressed:(id)sender;
- (IBAction)logoutClicked;

- (IBAction)menuClicked;
@end
