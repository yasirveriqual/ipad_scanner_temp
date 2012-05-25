//
//  FileManager.h
//  IncidentTracker
//
//  Created by Yasir Ali on 9/9/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject 

+ (void)setupData;

/**
 Return path of plist in Main Bundle
 @param plistName Name of Plist
 @return path of Plist
 */
+ (NSString*)bundlePathForPlist:(NSString*)plistName;

/**
 Return path of file in Main Bundle
 @param fileName Name of File
 @param extention of File
 @return path of File
 */
+ (NSString*)bundlePathForFile:(NSString*)fileName withExtention:(NSString *)extention;

/**
 Return path of file in Document Directory
 @param plistName Name of Plist
 @return path of Plist
 */
+ (NSString*)documentPathForPlist:(NSString*)plistName;

/**
 Return path of file in Document Directory
 @param fileName Name of File
 @param extention of File
 @return path of File
 */
+ (NSString*)documentPathForFile:(NSString*)fileName withExtention:(NSString *)extention;

+ (BOOL)removeFileFromDocuments:(NSString*)filePath;

@end
