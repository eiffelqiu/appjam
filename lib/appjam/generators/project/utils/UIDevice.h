//
//  UIDevice.h
//  EarthShake
//
//  Created by eiffel on 10-4-2.
//  Copyright 2010 www.likenote.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (DeviceConnectivity)
+(BOOL)cellularConnected; 
+(BOOL)wiFiConnected; 
+(BOOL)networkConnected;
+(BOOL)connectedToNetwork;
@end
