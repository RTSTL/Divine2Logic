//
//  GlobalStore.m
//  Snappy
//
//  Created by USER on 10/08/16.
//  Copyright © 2016 Arindam. All rights reserved.
//

#import "GlobalStore.h"

@implementation GlobalStore

+ (id)getInstance {
    static GlobalStore *_getInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _getInstance = [[GlobalStore alloc] init];
    });
    return _getInstance;
}
@end
