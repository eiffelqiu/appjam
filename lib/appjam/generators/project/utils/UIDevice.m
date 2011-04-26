//
//  UIDevice.m
//  EarthShake
//
//  Created by eiffel on 10-4-2.
//  Copyright 2010 www.likenote.com. All rights reserved.
//

#import "UIDevice.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation UIDevice (DeviceConnectivity)

+(BOOL)connectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}



+(BOOL)cellularConnected{
	// EDGE or GPRS 
	SCNetworkReachabilityFlags	flags = 0; 
	SCNetworkReachabilityRef	netReachability; 
	netReachability	= SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.google.com" UTF8String]); 
	if(netReachability){
		SCNetworkReachabilityGetFlags(netReachability, &flags); 
		CFRelease(netReachability);
	} 
	if(flags & kSCNetworkReachabilityFlagsIsWWAN){
		return YES;
	}
	return NO;
}
 
+(BOOL)networkConnected { 
	SCNetworkReachabilityFlags flags = 0; 
	SCNetworkReachabilityRef  netReachability; 
	BOOL retrievedFlags = NO;
	netReachability	= SCNetworkReachabilityCreateWithName( CFAllocatorGetDefault(), [@"www.google.com" UTF8String]);
	if(netReachability){ 
		retrievedFlags	= SCNetworkReachabilityGetFlags(netReachability, &flags); 
		CFRelease(netReachability);
	} 
	if (!retrievedFlags || !flags){
		return NO; 
	}
	return YES;
}

+(BOOL) wiFiConnected
{
	if([self cellularConnected]){
		return NO;
	} 
	return [self networkConnected];
}

@end
