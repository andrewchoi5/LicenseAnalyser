//
//  TrueIDMobileSDK.h
//  TrueIDMobileSDK
//
//  Created by Yanrui Ma on 1/8/15.
//  Copyright (c) 2015 LexisNexis Risk Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <TrueIDMobileSDK/DocAuthESP.h>
#import <TrueIDMobileSDK/FaceCapture.h>
#import <TrueIDMobileSDK/IVIA.h>

//! Project version number for TrueIDMobileSDK.
FOUNDATION_EXPORT double TrueIDMobileSDKVersionNumber;

typedef NS_ENUM(NSUInteger, TrueIDMobileIDType){
    TrueIDMobileIDTypeUnknown = 0,
    TrueIDMobileIDTypeID, //85.60x53.98 Default ID type. Use this for Driver's License, Passport Card and most of other ID cards.
    TrueIDMobileIDTypeFullPassport, //125x88
    TrueIDMobileIDTypeID2 //105x74
};

@protocol IDCaptureDelegate <NSObject>
-(void)didCaptureImage:(UIImage*)image;
@end

@interface IDCapture : NSObject
-(id)init:(UIViewController*)callingViewController ServiceEnv:(TrueIDServiceEnvType)ServiceEnv UserName:(NSString*)UserName PassWord:(NSString*)PassWord;
-(void)takePicture:(id<IDCaptureDelegate>)delegate;
-(void)cropImage:(UIImage*)image Delegate:(id<IDCaptureDelegate>)delegate;
-(NSData*)prepareImage:(UIImage*)image;
-(UIImage*)normalizeImage:(UIImage*)image;

@property (nonatomic, assign) TrueIDMobileIDType TargetIDType;
@property (nonatomic, assign) float MinClarityScore; //MinClarityScore is between 0.0 and 20.0, default is 4.0
@property (readonly, nonatomic, assign) BOOL IsRegistered;

//Optional properties
@property (nonatomic, assign) BOOL UseManualControls;

@end
