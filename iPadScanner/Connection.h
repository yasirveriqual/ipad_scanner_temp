//
//  Connection.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Model.h"

@interface Connection : Model

@property (nonatomic, retain) NSString *host;
@property (nonatomic, retain) NSString *port;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;


@end
