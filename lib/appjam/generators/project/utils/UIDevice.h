//
//  UIDevice.h
//  EarthShake
//
//  <%= @project_name %> by <%= @developer.capitalize %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (DeviceConnectivity)
+(BOOL)cellularConnected; 
+(BOOL)wiFiConnected; 
+(BOOL)networkConnected;
+(BOOL)connectedToNetwork;
@end
