//
//  TableView.m
//  iPadScanner
//
//  Created by Adeel on 1/18/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "TableView.h"

@implementation TableView

@synthesize tableViewDelegate;


- (void)reloadData {
    [super reloadData];
    
    [tableViewDelegate tableViewDidFinishLoading];
}

@end
