//
//  CustoUiViewController.h
//  POCSOS
//
//  Created by Erwan Yhuellou on 09/05/2017.
//  Copyright © 2017 Erwan Yhuellou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SalesforceSDKCore/SFRestAPI.h>
#import <SalesforceSDKCore/SFRestAPI+Files.h>
#import <SalesforceSDKCore/SFRestAPI+Blocks.h>

@import ServiceCore;
@import ServiceSOS;

@interface CustoUiViewController : SOSScreenSharingBaseViewController <SFRestDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
//#import <SCLAlertView-Objective-C/SCLAlertView.h>


@end

