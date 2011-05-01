//
//  URLEncodeString.h
//  YueBao
//
//  Created by <%= @developer.capitalize %> on <%= created_on %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncode) 
+ (NSString *)URLEncodeString:(NSString *)string; 
- (NSString *)URLEncodeString; 
- (BOOL) isWhitespace;
@end  