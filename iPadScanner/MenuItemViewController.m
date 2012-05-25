//
//  MenuItemViewController.m
//  iPadScanner
//
//  Created by Adeel on 3/13/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "MenuItemViewController.h"

@interface MenuItemViewController ()

@end

@implementation MenuItemViewController

@synthesize delegate;
@synthesize segmentedControl;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(197, 43);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - IBActions

- (IBAction)segmentedControlValueChanged	{
	if (segmentedControl.selectedSegmentIndex == 0)	{
		[delegate editScanAtIndex:self.index];
	}	else {
		[delegate scanLocationAtIndex:self.index];
	}
}

@end
