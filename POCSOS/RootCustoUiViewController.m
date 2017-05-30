//
//  RootCustoUiViewController.m
//  POCSOS
//
//  Created by Erwan Yhuellou on 09/05/2017.
//  Copyright © 2017 Erwan Yhuellou. All rights reserved.
//

#import "RootCustoUiViewController.h"
@import ServiceCore;
@import ServiceSOS;

@interface RootCustoUiViewController ()

@end

@implementation RootCustoUiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SOSOptions *options = [SOSOptions optionsWithLiveAgentPod:@"d.la1-c1-frf.salesforceliveagent.com"
                                                        orgId:@"00D58000000OfKl"
                                                 deploymentId:@"0NW58000000CaWO"];
    
    [options setFeatureClientBackCameraEnabled: NO];
    [options setFeatureClientFrontCameraEnabled: YES];
    [options setFeatureClientScreenSharingEnabled: NO];
    [options setInitialCameraType: SOSCameraTypeFrontFacing];
    
    // Register a custom onboarding view controller
    [options setViewControllerClass:[CustoUiViewController class] for:SOSUIPhaseScreenSharing];
    
    [[SCServiceCloud sharedInstance].sos startSessionWithOptions:options];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
