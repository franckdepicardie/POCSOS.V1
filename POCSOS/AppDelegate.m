//
//  AppDelegate.m
//  POCSOS
//
//  Created by Erwan Yhuellou on 04/05/2017.
//  Copyright © 2017 Erwan Yhuellou. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ViewController.h" // #import "RestAPIExplorerViewController.h"



//PROD : static NSString * const RemoteAccessConsumerKey = @"3MVG98_Psg5cppyYFWH3msukDdUeEjlVlW6UMq8_ID.L56iOCfvhNossR0SNwlZt2Vk6KLV8h5RvbfDdRAqev";
//REC :
static NSString * const RemoteAccessConsumerKey = @"3MVG92u_V3UMpV.iafsw913291peQiO6CpQxpuyMVSHlpTpW0XyxxKD2Wy0gYmZz1KI6sQCDIDcpSil0XBK3B";

//PROD : static NSString * const OAuthRedirectURI = @"https://login.salesforce.com/services/oauth2/success";
//REC :
static NSString * const OAuthRedirectURI = @"https://test.salesforce.com/services/oauth2/success";

static SFOAuthCoordinator *coordinator;

@import ServiceSOS;

@interface AppDelegate () <SOSDelegate>

@end

@implementation AppDelegate


- (id)init
{
    self = [super init];
    if (self) {
#if defined(DEBUG)
        [SFLogger sharedLogger].logLevel = SFLogLevelDebug;
#else
        [SFLogger sharedLogger].logLevel = SFLogLevelInfo;
#endif
        [SalesforceSDKManager sharedManager].connectedAppId = RemoteAccessConsumerKey;
        [SalesforceSDKManager sharedManager].connectedAppCallbackUri = OAuthRedirectURI;
        [SalesforceSDKManager sharedManager].authScopes = @[ @"web", @"api", @"refresh_token" , @"offline_access", @"id", @"profile", @"email", @"address", @"phone" ];
        __weak typeof(self) weakSelf = self;
        [SalesforceSDKManager sharedManager].postLaunchAction = ^(SFSDKLaunchAction launchActionList) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //
            // If you wish to register for push notifications, uncomment the line below.  Note that,
            // if you want to receive push notifications from Salesforce, you will also need to
            // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
            //
            //[[SFPushNotificationManager sharedInstance] registerForRemoteNotifications];
            //
            [strongSelf log:SFLogLevelInfo format:@"Post-launch: launch actions taken: %@", [SalesforceSDKManager launchActionsStringRepresentation:launchActionList]];
            NSLog(@"HERE: AppDelegate.m - init - B");
            [strongSelf setupRootViewController];
            NSLog(@"HERE: AppDelegate.m - init - E");
        };
        [SalesforceSDKManager sharedManager].launchErrorAction = ^(NSError *error, SFSDKLaunchAction launchActionList) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf log:SFLogLevelError format:@"Error during SDK launch: %@", [error localizedDescription]];
            [strongSelf initializeAppViewState];
            [[SalesforceSDKManager sharedManager] launch];
        };
        [SalesforceSDKManager sharedManager].postLogoutAction = ^{
            [weakSelf handleSdkManagerLogout];
        };
        [SalesforceSDKManager sharedManager].switchUserAction = ^(SFUserAccount *fromUser, SFUserAccount *toUser) {
            [weakSelf handleUserSwitch:fromUser toUser:toUser];
        };
    }
    
    return self;
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //
    // Uncomment the code below to register your device token with the push notification manager
    //
    //[[SFPushNotificationManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    //if ([SFUserAccountManager sharedInstance].currentUser.credentials.accessToken != nil) {
    //    [[SFPushNotificationManager sharedInstance] registerForSalesforceNotifications];
    //}
    //
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // Respond to any push notification registration errors here.
}

#pragma mark - Private methods

- (void)initializeAppViewState
{
    /*
    self.window.rootViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    */
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initializeAppViewState];
        });
        return;
    }
    
    self.window.rootViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    
    
    
}

- (void)setupRootViewController
{
    
    NSLog(@"HERE: AppDelegate.m - setupRootViewController - B");
    NSBundle *bundle = [NSBundle  mainBundle];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:bundle];
    ViewController *rootView = (ViewController*)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
    self.window.rootViewController = rootView;
    NSLog(@"HERE: AppDelegate.m - setupRootViewController - E");
    
}





- (void)resetViewState:(void (^)(void))postResetBlock
{
    if ([self.window.rootViewController presentedViewController]) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            postResetBlock();
        }];
    } else {
        postResetBlock();
    }
}

- (void)handleSdkManagerLogout
{
    [self log:SFLogLevelDebug msg:@"SDK Manager logged out.  Resetting app."];
    [self resetViewState:^{
        [self initializeAppViewState];
        
        // Multi-user pattern:
        // - If there are two or more existing accounts after logout, let the user choose the account
        //   to switch to.
        // - If there is one existing account, automatically switch to that account.
        // - If there are no further authenticated accounts, present the login screen.
        //
        // Alternatively, you could just go straight to re-initializing your app state, if you know
        // your app does not support multiple accounts.  The logic below will work either way.
        NSArray *allAccounts = [SFUserAccountManager sharedInstance].allUserAccounts;
        if ([allAccounts count] > 1) {
            SFDefaultUserManagementViewController *userSwitchVc = [[SFDefaultUserManagementViewController alloc] initWithCompletionBlock:^(SFUserManagementAction action) {
                [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
            }];
            [self.window.rootViewController presentViewController:userSwitchVc animated:YES completion:NULL];
        } else {
            if ([allAccounts count] == 1) {
                [SFUserAccountManager sharedInstance].currentUser = ([SFUserAccountManager sharedInstance].allUserAccounts)[0];
            }
            [[SalesforceSDKManager sharedManager] launch];
        }
    }];
}

- (void)handleUserSwitch:(SFUserAccount *)fromUser toUser:(SFUserAccount *)toUser
{
    [self log:SFLogLevelInfo format:@"SFUserAccountManager changed from user %@ to %@.  Resetting app.", fromUser.userName, toUser.userName];
    [self resetViewState:^{
        [self initializeAppViewState];
        [[SalesforceSDKManager sharedManager] launch];
        
        
    }];
}

#pragma mark - Unit test helpers

- (void)exportTestingCredentials {
    /*
    //collect credentials and copy to pasteboard
    SFOAuthCredentials *creds = [SFUserAccountManager sharedInstance].currentUser.credentials;
    NSMutableDictionary *configDict = [NSMutableDictionary dictionaryWithDictionary:@{@"test_client_id": RemoteAccessConsumerKey,
                                                                                      @"test_login_domain": [SFAuthenticationManager sharedManager].loginHost,
                                                                                      @"test_redirect_uri": OAuthRedirectURI,
                                                                                      @"refresh_token": creds.refreshToken,
                                                                                      @"instance_url": [creds.instanceUrl absoluteString],
                                                                                      @"identity_url": [creds.identityUrl absoluteString],
                                                                                      @"access_token": @"__NOT_REQUIRED__"}];
    if (creds.communityUrl != nil) {
        configDict[@"community_url"] = [creds.communityUrl absoluteString];
    }
    
    NSString *configJSON = [SFJsonUtils JSONRepresentation:configDict];
    UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setValue:configJSON forPasteboardType:(NSString*)kUTTypeUTF8PlainText];
     
     
     */
}


// ------------------------------- //



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"HERE : Launching");
    
    [[[SCServiceCloud sharedInstance] sos] addDelegate:self];
    //self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]; // ADDED FOR AUTHENT
    //[self initializeAppViewState]; // ADDED FOR AUTHENT
    [[SalesforceSDKManager sharedManager] launch ];
    
    return YES;
}

// All errors will come through this method. You can log them or ignore them. If you only wish to handle fatal errors you can use
// [SOSDelegate sos:didStopWithReason:error:].
- (void)sos:(SOSSessionManager *)sos didError:(NSError *)error {
    NSLog(@"Logged an error: %@", error);
}

// You can check for fatal errors with this delegate method. Any error which results in [SOSDelegate sos:didStopWithReason:error:] being
// executed is considered fatal.
- (void)sos:(SOSSessionManager *)sos didStopWithReason:(SOSStopReason)reason error:(NSError *)error {
    [self handleNormalStop:reason];
    [self handleError:error];
}

- (void)handleNormalStop:(SOSStopReason)reason {
    NSString *description = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *configuredViewControllers = settings[@"Custom ViewControllers"];
    
    switch(reason) {
        case SOSStopReasonAgentDisconnected: {
            description = @"The agent has ended the session";
            break;
        }
        case SOSStopReasonUserDisconnected: {
            description = @"You have ended your sos session";
            break;
        }
            
        default: {
            break;
        }
    }
    
    if (!description) {
        return;
    }
    
    if ([configuredViewControllers[@"Alerts"] boolValue]) {
        // NSLog @"SOS" subTitle:description closeButtonTitle:@"dismiss" duration:0.0f];
        
    } else {
        // Use generic alert controller
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SOS" message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)handleError:(NSError *)error {
    if (!error) {
        return;
    }
    
    NSString *description = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SOSSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSDictionary *configuredViewControllers = settings[@"Custom ViewControllers"];
    
    // You can do conditional error messages based on the type of error. Here we'll handle the No Agents Available error and display a custom message
    // if there is no error (it's nil) then these statements should be implicitly ignored.
    switch (error.code) {
        case SOSNoAgentsAvailableError: {
            description = @"Hey it looks like there are no agents available. Please try again later!";
            break;
        }
        case SOSInsufficientNetworkError: {
            description = @"Your network connection is not strong enough to handle an SOS session right now";
            break;
        }
        default: {
            break;
        }
    }
    
    if ([configuredViewControllers[@"Errors"] boolValue]) {
        // Use a custom class to handle alerts.
        //SCLAlertView *alertView = [[SCLAlertView alloc] initWithNewWindow];
        //[alertView showError:@"Something went wrong!" subTitle:description closeButtonTitle:@"Dismiss" duration:0.0f];
        
    } else {
        // Use generic alert controller
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SOS" message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
