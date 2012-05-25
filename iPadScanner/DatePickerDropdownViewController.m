//
//  DatePickerDropdownViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/4/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "DatePickerDropdownViewController.h"

@implementation DatePickerDropdownViewController

@synthesize datePicker, textField;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil textField:(UITextField *)_textField
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.textField = _textField;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - IBActions

- (IBAction)dateValueChanged:(id)sender {
    self.textField.text = [self.datePicker.date stringValue];

	if ([delegate respondsToSelector:@selector(dateSelected:)])	{
		[delegate dateSelected:self.datePicker.date];
	}
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(300, 216);
    //self.datePicker.maximumDate = [NSDate date];
    
    if (self.textField.text.length > 0) {
        self.datePicker.date = [NSDate dateFromString:self.textField.text];
    }
    else {
        self.datePicker.date = [NSDate date];
        [self dateValueChanged:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
