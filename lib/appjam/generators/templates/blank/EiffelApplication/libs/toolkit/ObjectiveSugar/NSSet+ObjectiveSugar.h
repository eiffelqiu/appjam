//
//  NSSet+Accessors.h
//  SampleProject
//
//  Created by Marin Usalj on 11/23/12.
//  Copyright (c) 2012 @mneorr | mneorr.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Accessors)

@property(readonly) id first;
@property(readonly) id last;

- (void)each:(void (^)(id object))block;
- (void)eachWithIndex:(void (^)(id object, int index))block;

- (NSArray *)map:(id (^)(id object))block;

@end
