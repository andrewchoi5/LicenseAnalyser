//
//  DocAuthESP.h
//  NexID
//
//  Created by Yanrui Ma on 1/14/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SoapElement : NSObject
@property (nonatomic, strong) NSString* Name;
@property (nonatomic, strong) NSString* Value;
@property (nonatomic, strong) NSArray* SubElements;
- (NSArray*)getElementsFromPath:(NSString*)path;
- (NSString*)getElementsValuesFromPath:(NSString*)path;
- (SoapElement*)getElementFromPath:(NSString*)path;
- (NSString*)getElementValueFromPath:(NSString*)path;
- (NSString*)toString;
@end

typedef NS_ENUM(NSUInteger, TrueIDServiceEnvType){
    TrueIDServiceEnvProd = 0,
    TrueIDServiceEnvCert = 1,
};

@interface DocAuthESP : NSObject
-(id)init:(TrueIDServiceEnvType)ServiceEnv UserName:(NSString*)UserName PassWord:(NSString*)PassWord;
-(NSError*)sendRequest:(NSData*)FrontImage BackImage:(NSData*)BackImage;
-(NSError*)sendOCROnlyRequest:(NSData*)FrontImage BackImage:(NSData*)BackImage;
-(NSString*)getResponseString;
-(SoapElement*)getResponseElement;
@end
