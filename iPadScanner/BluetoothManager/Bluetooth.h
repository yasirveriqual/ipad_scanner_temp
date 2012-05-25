//
//  Bluetooth.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/25/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BluetoothDelegate <NSObject>

- (void)bluetoothDidStartChanging;
- (void)bluetoothDidTurnOn;
- (void)bluetoothDidTurnOff;

@end


@interface Bluetooth : NSObject

@property (nonatomic, assign) id <BluetoothDelegate> delegate;

+ (void)turnOn;
+ (void)turnOff;
+ (BOOL)isTurnedOn;

+ (Bluetooth *)getInstance;
+ (void)releaseInstance;

@end
