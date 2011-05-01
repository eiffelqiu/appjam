//
//  URLEncodeString.m
//  YueBao
//
//  Created by <%= @developer.capitalize %> on <%= @created_on %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import "URLEncodeString.h"

@implementation NSString (URLEncode) 

// URL encode a string 
+ (NSString *)URLEncodeString:(NSString *)string { 
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8); 
	
    return [result autorelease]; 
} 

// Helper function 
- (NSString *)URLEncodeString { 
    return [NSString URLEncodeString:self]; 
} 

- (BOOL) isWhitespace{
	return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}

@end  