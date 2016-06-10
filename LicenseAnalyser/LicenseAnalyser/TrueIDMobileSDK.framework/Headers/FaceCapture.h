//
//  FaceCapture.h
//  TrueIDMobileSDK
//
//  Created by Yanrui Ma on 10/22/15.
//  Copyright © 2015 LexisNexis Risk Solutions. All rights reserved.
//

#ifndef FaceCapture_h
#define FaceCapture_h

@protocol FaceCamDelegate
- (void) faceImageTaken : (UIImage*)image;
@end

@interface FaceCapture : NSObject
-(void) startCapture : (id<FaceCamDelegate>)delegate CallingVC:(UIViewController*)callingvc;
@end

#endif /* FaceCapture_h */
