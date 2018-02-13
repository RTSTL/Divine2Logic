//
//  GlobalStore.h
//  Snappy
//
//  Created by USER on 10/08/16.
//  Copyright © 2016 Intersoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalStore : NSObject
#define max_character 500;

/* Personal Data */

@property(nonatomic,strong)	NSString *userTypeId;   // usertypeid
//@property(nonatomic,strong)	NSString *block;
@property(nonatomic,strong)	NSString *contactNo;    // usercontactno
@property(nonatomic,strong)	NSString *country;      // usercountry
@property(nonatomic,strong)	NSString *countrycode;      // usercountry

@property(nonatomic,strong)	NSString *emailId;     // useremailid
@property(nonatomic,strong)	NSString *firstName;   // firstname
@property(nonatomic,strong)	NSString *lastName;    // lastname
//@property(nonatomic,strong)	NSString *state;
@property(nonatomic,strong)	NSString *street;      // userstreet
@property(nonatomic,strong)	NSString *unitExt;     // userunitno
//@property(nonatomic,strong)	NSString *unitNo;
@property(nonatomic,strong)	NSString *userId;     // userid
@property(nonatomic,strong)	NSString *zipCode;    // userzip
@property(nonatomic,strong)	NSString *logoPath;   // logopath
//@property(nonatomic,strong)	NSString *password;   // password
@property(nonatomic,strong)	NSString *userName;   // username
@property(nonatomic,strong)	NSString *secEmailId;   // usersecondaryemailid

/* Company Data */

@property(nonatomic,strong)	NSString *companyName;    // company
@property(nonatomic,strong)	NSString *secContactNo;   // usersecondarycontactno
@property(nonatomic,strong)	NSString *UEN;            // regno
@property(nonatomic,strong)	NSString *gender;
@property(nonatomic,strong)	NSString *bithdate;
/* Company Service Data */

//@property(nonatomic,strong)	NSString *businessId;
//@property(nonatomic,strong)	NSString *feestype;
//@property(nonatomic,strong)	NSString *location;
//@property(nonatomic,strong)	NSString *paymentType;
@property(nonatomic,strong)	NSString *services;          // businessservice
@property(nonatomic,strong)	NSString *serviceLocations;  // businesslocation

@property(nonatomic,strong)	NSMutableArray *serviceList;
@property(nonatomic,strong)	NSMutableArray *newrequestList;

@property(nonatomic,strong)	NSMutableArray *serviceRequestList;
@property(nonatomic,strong)	NSMutableArray *confimed_pendingjobs;
@property(nonatomic,strong)	NSMutableArray *upcomingjoblist;
@property(nonatomic,strong)	NSMutableArray *myjobrequestlist;
@property(nonatomic,strong)	NSMutableArray *myfeedbacklist;

@property(nonatomic,strong)	NSMutableArray *quotereceviedlist;
@property(nonatomic)bool back_navigate;



+(GlobalStore*)getInstance;

@end
