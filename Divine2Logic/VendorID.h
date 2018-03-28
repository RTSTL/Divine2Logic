//
//  VendorID.h
//  Storytime
//
//  Created by Ved Prakash on 6/11/13.
//
//

#import <Foundation/Foundation.h>

#define VENDOR_UUID [VendorID getUUID]

@interface VendorID : NSObject

+(NSString *)getUUID;

@end
