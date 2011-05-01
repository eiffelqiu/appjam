//
//  UIDevice.h
//  EarthShake
//
//  Created by <%= @developer.capitalize %> on <%= created_on %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (DeviceConnectivity)
+(BOOL)cellularConnected; 
+(BOOL)wiFiConnected; 
+(BOOL)networkConnected;
+(BOOL)connectedToNetwork;
@end
