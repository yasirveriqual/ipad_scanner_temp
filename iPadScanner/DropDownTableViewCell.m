//
//  DropDownTableViewCell.m
//  
//
//  Created by Yasir Ali on 12/7/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "DropDownTableViewCell.h"
#import "FileManager.h"

@implementation DropDownTableViewCell

@synthesize imageView;
@synthesize dropdownButton;
@synthesize popover;
@synthesize dropdownController;
@synthesize source;

- (IBAction)dropdownButtonClicked   {
    
    if (dropdownController == nil) {
        ItemDropdownViewController *viewContorller = [[[ItemDropdownViewController alloc] initWithTextField:self.textField] autorelease];
        viewContorller.source = self.source;
        viewContorller.delegate = self;
        self.dropdownController = viewContorller;
        self.popover = [[[UIPopoverController alloc] initWithContentViewController:dropdownController] autorelease];
        viewContorller.popoverController = self.popover;
    }
    
    [self.popover presentPopoverFromRect:CGRectMake(self.imageView.frame.origin.x+8, (self.imageView.frame.origin.y+self.imageView.frame.size.height+15), 190, 170) inView:self permittedArrowDirections:0 animated:YES];
}

- (void)setDictionary:(NSMutableDictionary *)dictionary    {
    [super setDictionary:dictionary];
    if ([dictionary valueForKey:@"source"] != nil)
        self.source = [NSArray arrayWithContentsOfFile:[FileManager bundlePathForPlist:[dictionary valueForKey:@"source"]]];
    
    if ([dictionary valueForKey:@"value"] != nil)   {
        NSInteger index = [[dictionary valueForKey:@"value"] integerValue];
        if (index < 0 || index >= source.count)
            index = 0;
        self.textField.text = [source objectAtIndex:index];
    }
    
}

- (NSUInteger)selectedIndex {
    if ([source indexOfObject:self.textField.text] == NSIntegerMax) {
        return NSUIntegerMax;
    }
    return [source indexOfObject:self.textField.text];
}


- (void)itemSelected:(NSString *)selectedValue {
    [self.dictionary setValue:[NSString stringWithFormat:@"%i", self.selectedIndex] forKey:@"value"];
}

- (void)reloadItems {
    self.dropdownController.source = self.source;
    [self.dropdownController.tableView reloadData];
}

@end
