//
//  NSStringWhiteSpace.h
//  YueBao
//
//  Created by eiffel on 10-4-8.
//  Copyright 2010 www.likenote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Whitespace) 

// Note: a category implementation does not have ivars in { }

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator;

@end
