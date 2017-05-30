//
//  ViewController.m
//  POCSOS
//
//  Created by Erwan Yhuellou on 04/05/2017.
//  Copyright © 2017 Erwan Yhuellou. All rights reserved.
//

#import "ViewController.h"
#import "CustoUiViewController.h"
@import ServiceCore;
@import ServiceSOS;

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)launchCustoButton:(id)sender {

    NSLog(@">> Launching with launchCustoButton");
    
    /* Pour PROD :
    SOSOptions *options = [SOSOptions optionsWithLiveAgentPod:@"d.la1-c1-frf.salesforceliveagent.com"
                                                        orgId:@"00D58000000OfKl"
                                                 deploymentId:@"0NW58000000CaWO"];
    */
    
    // Pour REC :
    SOSOptions *options = [SOSOptions optionsWithLiveAgentPod:@"d.la1-c1cs-lon.salesforceliveagent.com"
                                                        orgId:@"00D7E0000008qj8"
                                                 deploymentId:@"0NW58000000CaWO"];

    
    [options setFeatureClientBackCameraEnabled:NO];
    [options setFeatureClientFrontCameraEnabled:YES];
    [options setFeatureClientScreenSharingEnabled: YES];
    
    // Pour PROD : NSMutableDictionary *myCustomData = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"5005800000AHy7u", @"CaseId", nil];
    
    // Pour REC :
    NSMutableDictionary *myCustomDataContact = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Philippe", @"Contact_case_POc__c", nil];
    [options setCustomFieldData:myCustomDataContact];
    
    [myCustomDataContact setObject:@"5007E0000052Kpv" forKey:@"CaseId"];
    [myCustomDataContact setObject:@"Zakaria Dupont" forKey:@"Case_Owner_Poc__c"];
    [myCustomDataContact setObject:@"Philippe" forKey:@"Contact_case_POc__c"];
    
    [options setViewControllerClass:[CustoUiViewController class] for:SOSUIPhaseScreenSharing];
    
    [[SCServiceCloud sharedInstance].sos startSessionWithOptions:options];
    
}

- (IBAction)launchSOS:(id)sender {
/* NOT USED ANYMORE
 
    // PROD
    // SOSOptions *options = [SOSOptions optionsWithLiveAgentPod:@"d.la1-c1-frf.salesforceliveagent.com"
    // orgId:@"00D58000000OfKl"
    // deploymentId:@"0NW58000000CaWO"];
     
    // REC
    SOSOptions *options = [SOSOptions optionsWithLiveAgentPod:@"d.la1-c1cs-lon.salesforceliveagent.com"
                                                        orgId:@"00D7E0000008qj8"
                                                 deploymentId:@"0NW58000000CaWO"];
    
    [options setFeatureClientBackCameraEnabled: NO];
    [options setFeatureClientFrontCameraEnabled: YES];
    [options setFeatureClientScreenSharingEnabled: NO];
    [options setInitialCameraType: SOSCameraTypeFrontFacing];
    
    [[SCServiceCloud sharedInstance].sos startSessionWithOptions:options];
 */
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"HERE: ViewController - initWithNibName");
        //self.view.frame = [[UIScreen mainScreen] bounds]];
        self.view.bounds = [[UIScreen mainScreen] bounds];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad loaded successfully");
    
    NSLog(@"viewDidAppear loaded successfully");
    
    self.view.bounds = [[UIScreen mainScreen] bounds];
    
    
    NSURL *tmpURL = [NSURL URLWithString:@"https://envint-societegenerale.cs83.force.com/EERAD/"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:tmpURL];
    
    [_webView loadRequest:request];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
