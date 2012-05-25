//
//  DateDropDownTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "DateDropDownTableViewCell.h"

@implementation DateDropDownTableViewCell
@synthesize delegate;
@synthesize dropdownController;



- (IBAction)dropdownButtonClicked   {
    
    if (self.dropdownController == nil) {
        DatePickerDropdownViewController *viewController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.textField] autorelease];
		viewController.delegate = self;
        self.dropdownController = viewController;
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:self.dropdownController] autorelease];
    }
    
    [self.popover presentPopoverFromRect:CGRectMake(self.imageView.frame.origin.x+8, (self.imageView.frame.origin.y+self.imageView.frame.size.height-5), 290, 250) inView:self permittedArrowDirections:0 animated:YES];
}

- (void)setDictionary:(NSMutableDictionary *)dictionary    {
    [super setDictionary:dictionary];
    
    if ([dictionary valueForKey:@"value"] != nil)   {
        self.textField.text = [dictionary valueForKey:@"value"];
    }
    
}



- (void)dateSelected:(NSDate *)selectedValue	{
    if ([delegate dateSelected:selectedValue forDictionary:self.dictionary])
        [self.dictionary setValue:selectedValue forKey:@"value"];
    else    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                            message:@"To Date should be greater or equal to from date" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

@end