//
//  URLEncodeString.h
//  YueBao
//
//  <%= @project_name %> by <%= @developer.capitalize %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncode) 
+ (NSString *)URLEncodeString:(NSString *)string; 
- (NSString *)URLEncodeString; 
- (BOOL) isWhitespace;
@end  