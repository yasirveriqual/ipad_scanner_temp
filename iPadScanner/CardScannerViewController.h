//
//  CardScannerViewController.h
//  iPadScanner
//
//  Created by Adeel Rehman on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface CardScannerViewController : ViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *txtCardNo;

@end
