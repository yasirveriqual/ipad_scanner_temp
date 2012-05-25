//
//  TextFieldTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

@synthesize textField;
@synthesize textLabel;

- (void)awakeFromNib    {
    [super awakeFromNib];
    self.textField.delegate = self;
}

- (void)setDictionary:(NSMutableDictionary *)dictionary    {
    [super setDictionary:dictionary];
    self.textLabel.text = [dictionary valueForKey:@"label"];

    if ([dictionary valueForKey:@"isSecure"] != nil)
        [self.textField setSecureTextEntry: [[dictionary valueForKey:@"isSecure"] boolValue]];
    if ([dictionary valueForKey:@"placeholder"] != nil)
        self.textField.placeholder = [dictionary valueForKey:@"placeholder"];
    self.textField.text = [dictionary valueForKey:@"value"];
}

- (void)textFieldDidEndEditing:(UITextField *)txtField {
    [self.dictionary setValue:txtField.text forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCreateLocaton" object:txtField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)txtField {
    [self.dictionary setValue:txtField.text forKey:@"value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCreateLocaton" object:txtField.text];
    return [txtField resignFirstResponder];
}

@end
