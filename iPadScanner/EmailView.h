//
//  EmailView.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/14/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmailViewDelegate <NSObject>
- (void)emailViewDidSearchEmail:(NSString *)email;
@end


@interface EmailView : UIView

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, assign) IBOutlet id <EmailViewDelegate> delegate;

- (IBAction)scanClicked;
- (IBAction)cancelClicked;

@end
