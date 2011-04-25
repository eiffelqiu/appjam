//
//  URLEncodeString.h
//  YueBao
//
//  Created by eiffel on 10-4-27.
//  Copyright 2010 www.likenote.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncode) 
+ (NSString *)URLEncodeString:(NSString *)string; 
- (NSString *)URLEncodeString; 
- (BOOL) isWhitespace;
@end  