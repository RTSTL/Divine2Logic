//
//  GlobalStore.h
//  Snappy
//
//  Created by USER on 10/08/16.
//  Copyright © 2016 Arindam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalStore : NSObject

/* Personal Data */

@property(nonatomic,strong)	NSString *id_enc;
@property(nonatomic,strong)	NSString *member_id;
@property(nonatomic,strong)	NSString *member_type;
@property(nonatomic,strong)	NSString *name;
@property(nonatomic,strong)	NSString *org_mem_id;
@property(nonatomic,strong) NSString *pic_id;


+(GlobalStore*)getInstance;

@end
