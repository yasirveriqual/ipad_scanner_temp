//
//  FileManager.m
//  IncidentTracker
//
//  Created by Yasir Ali on 9/9/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "FileManager.h"


@implementation FileManager

+ (void)setupData	{
	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"documentsCopied"] == nil)	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"documentsCopied"];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *directPath = [paths objectAtIndex:0];
		NSArray *documents = [fileManager contentsOfDirectoryAtPath:directPath error:nil];
		if ([documents count] > 0)	{
			for (NSString *str in documents)	{
				[fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directPath, str] error:nil];
			}
		}
		
		[fileManager copyItemAtPath:[self bundlePathForFile:@"ipad_scanner" withExtention:@"sqlite3"]
							 toPath:[self documentPathForFile:@"ipad_scanner_db" withExtention:@"sqlite3"] 
							  error:nil];
        
        [fileManager copyItemAtPath:[self bundlePathForPlist:@"settings"]
							 toPath:[self documentPathForPlist:@"settings"] 
							  error:nil];
        
        [fileManager copyItemAtPath:[self bundlePathForPlist:@"base-location"]
							 toPath:[self documentPathForPlist:@"base-location"] 
							  error:nil];
        
		[fileManager release];
	}
}

+ (NSString*)bundlePathForPlist:(NSString*)plistName	{
	return [self bundlePathForFile:plistName withExtention:@"plist"];
}

+ (NSString*)bundlePathForFile:(NSString*)fileName withExtention:(NSString *)extention	{
	return [NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] bundlePath], fileName, extention];
}

+ (NSString*)documentPathForPlist:(NSString*)plistName	{
	return [self documentPathForFile:plistName withExtention:@"plist"];
}

+ (NSString*)documentPathForFile:(NSString*)fileName withExtention:(NSString *)extention	{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *directPath = [paths objectAtIndex:0];
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@.%@", directPath, fileName, extention]);
	return [NSString stringWithFormat:@"%@/%@.%@", directPath, fileName, extention];
}


+ (BOOL)removeFileFromDocuments:(NSString*)filePath {
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
