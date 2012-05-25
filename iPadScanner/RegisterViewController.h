//
//  RegisterViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "ViewController.h"
#import "Employee.h"

@protocol RegisterViewControllerDelegate <NSObject>
- (void)emailViewDidSearchEmail:(NSString *)email;
@end

@interface RegisterViewController : ViewController  <UIAlertViewDelegate, UITextFieldDelegate> {
	Employee *objEmployee;
}

@property (nonatomic, retain) NSString *cardNo;
@property (nonatomic, retain) NSString *employeeEmail;
@property (readwrite) BOOL isManualScan;

@property (nonatomic, retain) IBOutlet UILabel *lblCardNo;
@property (nonatomic, retain) IBOutlet UITextField *txtFirstName;
@property (nonatomic, retain) IBOutlet UITextField *txtLastName;
@property (nonatomic, retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextField *txtFloor;
@property (nonatomic, retain) IBOutlet UITextField *txtCubicle;

@property (nonatomic, retain) IBOutlet UIButton *btnSearch;
@property (nonatomic, retain) IBOutlet UIButton *btnUnlock;

@property (nonatomic, retain) IBOutlet UIView *innerView;
@property (nonatomic, retain) IBOutlet UIImageView *lockImage;

@property (nonatomic, assign) id<RegisterViewControllerDelegate> delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cardNo:(NSString *)_cardNo employeeEmail:(NSString *)_employeeEmail isManualScan:(BOOL)_isManualScan;

- (IBAction)searchClicked;
- (IBAction)unlockClicked;

@end
