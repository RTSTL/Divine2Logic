//
//  VendorID.m
//  Storytime
//
//  Created by Ved Prakash on 6/11/13.
//
//

#import "VendorID.h"
#import "KeychainItemWrapper.h"

@implementation VendorID


+(NSString *)getUUID {
    //Initialize the keychain
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
    
    NSString *uuid = [NSString stringWithString:[wrapper objectForKey:((__bridge id)kSecAttrAccount)]];
    
    if ((uuid == nil) || (uuid.length == 0)) {
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        
        // Get the string representation of CFUUID object.
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
        CFRelease(uuidObject);
        
        //Save into keychain
        [wrapper setObject:uuid forKey:(__bridge id)kSecAttrAccount];
    }
    NSString *str=[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str=[str lowercaseString];
    
     str = [str substringToIndex:25];
    NSLog(@"uuidLenght%lu", (unsigned long)str.length);
    return str;
}

//+(NSString*)getUUID
//{
//    
//    NSString* identifier = nil;
//    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
//        // iOS 6+
//        identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    } else {
//        // before iOS 6, so just generate an identifier and store it
//        identifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"identiferForVendor"];
//        if( !identifier ) {
//            CFUUIDRef uuid = CFUUIDCreate(NULL);
//            identifier = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
//            CFRelease(uuid);
//            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"identifierForVendor"];
//        }
//    }
//    return identifier;
//}

@end
