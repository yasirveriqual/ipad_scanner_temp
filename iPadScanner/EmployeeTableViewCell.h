//
//  PersonTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@protocol EmployeeTableViewDelegate;

@interface EmployeeTableViewCell : UITableViewCell <UITextFieldDelegate>  {
    IBOutlet UIView *activityView;
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic, retain) IBOutlet UITextField *idTextField;
@property (nonatomic, retain) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;

@property (nonatomic, retain) Employee *employee;
@property (nonatomic, assign) id<EmployeeTableViewDelegate> delegate;

- (void)stopActivity;

@end

@protocol EmployeeTableViewDelegate<NSObject>

@optional
- (BOOL)employeeTableViewCell:(EmployeeTableViewCell *)employeeTableViewCell didSearchRfid:(NSString *)rfid withDictionary:(NSDictionary **)dictionary;
- (void)addEmployee:(Employee *)emp;
- (void)reloadScansData;
@end