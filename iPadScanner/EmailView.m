//
//  EmailView.m
//  iPadScanner
//
//  Created by Yasir Ali on 12/14/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "EmailView.h"
//#import "Bluetooth.h"
#import "DeviceManager.h"

@interface EmailView (Private)
- (BOOL)checkFields;
- (BOOL)validateEmail:(NSString *)candidate;
@end


@implementation EmailView

@synthesize emailTextField;
@synthesize delegate;

- (IBAction)scanClicked	{
	[self endEditing:YES];
	
    if ([self checkFields]) {
        [delegate emailViewDidSearchEmail:emailTextField.text];
        [self cancelClicked];
    }
}


- (BOOL)checkFields {
    UIAlertView *av;
    if ([[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Enter Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else if (![self validateEmail:self.self.emailTextField.text]) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Email Address is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
        return NO;
    }
    else {
        return YES;
    }
}


- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 	
    return [emailTest evaluateWithObject:candidate];
}

- (IBAction)cancelClicked	{
    //[Bluetooth turnOn];
	[[DeviceManager currentDevice] enable];
	[self endEditing:YES];
	emailTextField.text = @"";
	self.hidden = YES;
}

@end
