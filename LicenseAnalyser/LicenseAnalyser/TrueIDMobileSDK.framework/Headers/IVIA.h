//
//  IV.h
//  TrueIDMobileSDK
//
//  Created by Yanrui Ma on 6/11/15.
//  Copyright (c) 2015 LexisNexis Risk Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

// General Classes and Types
typedef NS_ENUM(NSUInteger, IVIAEnvType){
    IVIAEnvUnknown = 0,
    IVIAEnvProd = 1,
    IVIAEnvStaging = 2
};

typedef NS_ENUM(NSUInteger, IVIAStatusType){
    IVIAStatusUnknown = 0,
    IVIAStatusPass = 1,
    IVIAStatusFail = 2,
    IVIAStatusPending = 3,
    IVIAStatusError = 4
};

@interface IVIAInput : NSObject
@property (strong, nonatomic) NSString* FirstName;
@property (strong, nonatomic) NSString* LastName;
@property (strong, nonatomic) NSString* SSN;
@property (strong, nonatomic) NSString* Address;
@property (strong, nonatomic) NSString* City;
@property (strong, nonatomic) NSString* StateCode;
@property (strong, nonatomic) NSString* Zip5;
@property (assign, nonatomic) int DOBYear;
@property (assign, nonatomic) int DOBMonth;
@property (assign, nonatomic) int DOBDay;
@end

// IV Specific Classes
@interface IVResultEntry : NSObject
@property (assign, nonatomic) IVIAStatusType Status;
@property (strong, nonatomic) NSString* Description;
@end

@interface IV : NSObject
@property (strong, nonatomic) IVIAInput* Input;
@property (assign, nonatomic) IVIAStatusType Status;
@property (strong, nonatomic) NSArray* ResultEntries;
@property (strong, nonatomic) NSString* RawResponse;
@property (strong, nonatomic) NSString* ErrorMessage;
- (id) init:(IVIAEnvType)env WorkFlow:(NSString*)workflow UserName:(NSString*)username PassWord:(NSString*)password;
- (void) submit;
- (NSString*) toString;
@end

//IA Specific Classes
@interface IAQuestion : NSObject
@property (strong, nonatomic) NSString* Text;
@property (assign, nonatomic) bool IsFillIn;
@property (strong, nonatomic) NSArray* Choices; //Each Choice is a NSString*
@property (assign, nonatomic) int AnswerChoice;
@property (strong, nonatomic) NSString* AnswerFillIn;
@end

@interface IA : NSObject
@property (strong, nonatomic) IVIAInput* Input;
@property (assign, nonatomic) IVIAStatusType Status;
@property (strong, nonatomic) NSArray* Questions; // Each Question is an IAQuestion
@property (strong, nonatomic) NSString* RawResponse;
@property (strong, nonatomic) NSString* ErrorMessage;
- (id) init:(IVIAEnvType)env WorkFlow:(NSString*)workflow UserName:(NSString*)username PassWord:(NSString*)password;
- (void) generateQuestions;
- (void) submitAnswers;
- (NSString*)toString;
@end

