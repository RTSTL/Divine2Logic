//
//  MMCommon.h
//
//  Created by Arindam Das on 26/05/15.

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//#import "UIImage+animatedGIF.h"
//#import "UITextView+Placeholder.h"
#import <MessageUI/MessageUI.h>

#define BASE_URL @"http://snappysg.com/api/"
#define IMAGE_BASE_URL @"http://snappysg.com/"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

@interface MMCommon : NSObject
{
   // MFMailComposeViewController *mc;
}

//@property (nonatomic ,retain) UIActivityIndicatorView *uploadingIndicator;
@property (nonatomic ,retain) UIImageView *uploadingIndicator;

@property (nonatomic ,retain) UIView *indicatorView;

+ (MMCommon *)sharedInstance;

+(void) showOnlyAlert:(NSString*)title :(NSString*)message :(UIViewController*)viewController;
-(BOOL)isNullString:(NSString*)_inputString;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validateUen: (NSString *) candidate;
- (BOOL) validateNum: (NSString *) candidate;
- (BOOL) PostalNum: (NSString *) candidate;
-(void)mailFunc:(NSString*)Emailid;
+(void)callFunc:(NSString*)number;


-(void)showfullScreenIndicator:(BOOL)indicator animated:(BOOL)animated;
//-(void)showSnappyindicatior:(bool)show;

@end
