//
//  IDPalSDK.h
//  IDPalSDK
//
//  Created by Anilkumar on 04/07/18.
//  Copyright © 2018 ID-Pal. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IDPalSDK.
FOUNDATION_EXPORT double IDPalSDKVersionNumber;

//! Project version string for IDPalSDK.
FOUNDATION_EXPORT const unsigned char IDPalSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IDPalSDK/PublicHeader.h>
@protocol AcuantFacialCaptureDelegate;
@class AcuantMobileSDKController;

#import "IDPalSDKController.h"
#import "AcuantCardProcessRequestOptions.h"
#import "AcuantCardRegion.h"
#import "AcuantCardResult.h"
#import "AcuantCardType.h"
//#import "AcuantMobileSDK/AcuantDeviceLocationTestResult.h"
#import "AcuantDriversLicenseCard.h"
#import "AcuantError.h"
#import "AcuantFacialCaptureDelegate.h"
#import "AcuantFacialData.h"
#import "AcuantFacialRecognitionViewController.h"
#import "AcuantMedicalInsuranceCard.h"
#import "AcuantMobileSDKController.h"
#import "AcuantPassaportCard.h"
#import "SDAVAssetExportSession.h"
