//
//  NSStringWhiteSpace.m
//  <%= @project_name %>
//
//  Created by <%= @developer.capitalize %> on <%= @created_on %>
//  Copyright(c) <%= Time.now.year %>, All rights reserved.
//

#import "NSStringWhiteSpace.h"


@implementation NSString (Whitespace)

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator
{
	NSArray *comps = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSMutableArray *nonemptyComps = [[[NSMutableArray alloc] init] autorelease];
	
	// only copy non-empty entries
	for (NSString *oneComp in comps)
	{
		if (![oneComp isEqualToString:@""])
		{
			[nonemptyComps addObject:oneComp];
		}
		
	}
	
	return [nonemptyComps componentsJoinedByString:seperator];  // already marked as autoreleased
}
@end