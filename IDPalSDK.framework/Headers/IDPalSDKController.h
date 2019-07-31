
//  IDPalSDKController.h
//  IDPalSDK
//
//  Created by Anilkumar on 03/07/18.
//  Copyright © 2018 Anilkumar. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>
@protocol IDPalApplicationDelegate <NSObject>
@required
-(void) didFinishPreloading:(BOOL)result WithError: (NSString* )message WithProcess:(NSDictionary* ) steps AndDataFields:(NSArray *) fields;
-(void) didComplete:(NSString* ) step WithResult:(NSString* )result AndError:(NSString* )message SubmissionID:(NSNumber* )submissionID PersonalInformation:(NSDictionary*)dataFields Images:(NSDictionary *)imageData IsLastStep:(BOOL)lastStep;
@end


@interface IDPalSDKController : NSObject

@property (strong, nonatomic) id<IDPalApplicationDelegate> Newdelegate;



+(IDPalSDKController*)loadIDPalWithStartScreen:(BOOL)startScreen andConfirmationScreen:(BOOL)confirmScreen andParentViewController:(UIViewController*) vc;
+(IDPalSDKController*)submitForValidationWithViewController:(UIViewController*)vc andDataFields:(NSDictionary*)fields;

+(IDPalSDKController*) abandonProcess;
/*
 The Framework can be initialised using the following function if the user is known and you have a AndCompanyID configured through a GetMessage API call:
 @param key your License Key
 @param parentVC your viewController
 @param companyid your companyid
 @param delegate your delegate
 @return the IDPalSDKController instance
 */




+(IDPalSDKController*)initIDPalSDKWithLicenseKey:(NSString*)key
                         AndCompanyID:(NSString*)companyId delegate:(id<IDPalApplicationDelegate>)delegate ;

/*
 The Framework can be initialised using the following function if the user is known and you have a UUID configured through a GetMessage API call:
 @param key your License Key
 @param parentVC your viewController
 @param UUID your UUID
 @param delegate your delegate
 @return the IDPalSDKController instance
 */

+(IDPalSDKController*)initIDPalSDKWithLicenseKey:(NSString*)key AndUuid:(NSString*)UUID delegate:(id<IDPalApplicationDelegate>)delegate;

/*Name: AIT-iOS
 *Date: 11-02-2019
 *Desc: Changed the method name according the naming standards and added the isLastStep parameter dynamically.
 *Release: 2.4.0*/

-(void) didComplete:(NSString *) step WithResult:(NSString *)result AndError:(NSString *)message SubmissionID:(NSNumber* )submissionID PersonalInformation:(NSDictionary*)scalarData Images:(NSDictionary *)imageData isLastStep:(BOOL)lastStep completion:(void (^_Nullable)(BOOL finished))completion;




@end
