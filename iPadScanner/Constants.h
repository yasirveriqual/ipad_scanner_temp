//
//  Constants.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//
#import "FileManager.h"


#if TARGET_IPHONE_SIMULATOR


//#define kServerUrl [NSURL URLWithString:@"http://10.10.10.26:3000/api/"]		// Rizwan PC
//#define kServerUrl [NSURL URLWithString:@"http://10.10.10.15:3002/api/"]		// development server, Local IP
//#define kServerUrl [NSURL URLWithString:@"http://125.209.111.6:3002/api/"]		// Development server, Live IP
#define kServerUrl [NSURL URLWithString:@"http://69.33.0.201:3002/api/"]		// Testing server Live IP

#else

//#define kServerUrl [NSURL URLWithString:@"http://10.10.10.26:3000/api/"]		// Rizwan PC
//#define kServerUrl [NSURL URLWithString:@"http://10.10.10.15:3002/api/"]		// development server, Local IP
//#define kServerUrl [NSURL URLWithString:@"http://125.209.111.6:3002/api/"]		// Development server, Live IP
#define kServerUrl [NSURL URLWithString:@"http://69.33.0.201:3002/api/"]		// Testing server Live IP

#endif

#import "iPadScannerAppDelegate.h"
#define APP_DELEGATE (iPadScannerAppDelegate *)[[UIApplication sharedApplication] delegate]


//#define kServerUrl [NSURL URLWithString:@"http://10.10.10.32:3000/api/"]
//#define kLocalUrl [NSURL URLWithString:@"http://203.81.196.133:8005"]


#define kDatabasePath [FileManager documentPathForFile:@"ipad_scanner_db" withExtention:@"sqlite3"]
#define kNetworkError @"Network is not available"
