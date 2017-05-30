//
//  CustoUiViewController.m
//  POCSOS
//
//  Created by Erwan Yhuellou on 09/05/2017.
//  Copyright © 2017 Erwan Yhuellou. All rights reserved.
//

#import "CustoUiViewController.h"
#import <SalesforceSDKCore/SFAuthenticationManager.h>


@interface CustoUiViewController ()

@property (weak, nonatomic)  UIView *drawView;
@property (weak, nonatomic)  UIView *agentStreamView;

@property (strong, nonatomic)  UIView *agentContainer;
@property (strong, nonatomic)  UIView *drawContainer;


@property (strong, nonatomic) UIImagePickerController *picker;

@end



static const CGFloat kAgentSize = 120.f;

@implementation CustoUiViewController

@synthesize picker = _picker;

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

// -------------------------------------------------------------------
// Custom code added here ********************************************
// -------------------------------------------------------------------

// This determines whether or not you wish to display an agent stream in your view.
// If you return NO you will not receive a view containing the agent video feed.
- (BOOL)willHandleAgentStream {
    
    // Our example UI will exclude the agent UI.
    return YES;
}

// When this returns yes you will receive updates about the audio level you can use
// to implement an audio meter.
- (BOOL)willHandleAudioLevel {
    return NO;
}

- (BOOL)willHandleLineDrawing {
    return YES;
}

// When this returns yes you will receive screen space coordinates which represent
// the center of where the agent has moved the view. You can use this to update
// the position of your containing view.
- (BOOL)willHandleRemoteMovement {
    return NO;
}

- (void)didReceiveLineDrawView:(UIView * _Nonnull __weak)drawView {
    /*
    CGRect PROSPECT_RECT = CGRectMake(0, self.view.frame.size.height - 250 - 167, self.view.frame.size.width, 250);
    
    NSLog(@">> Call to didReceiveLineDrawView.");
    _drawView = drawView;
    [_drawView setFrame:PROSPECT_RECT];
    */
    
    
    CGRect PROSPECT_RECT = CGRectMake(0, self.view.frame.size.height - 250 - 167, self.view.frame.size.width, 250);
    
    [_drawView setFrame:PROSPECT_RECT];
    
    _picker = [[UIImagePickerController alloc] init] ;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.delegate = self;
    _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    _picker.showsCameraControls = NO;
    _picker.navigationBarHidden = YES;
    _picker.toolbarHidden = YES;
    _picker.view.frame = PROSPECT_RECT;
    _picker.cameraOverlayView = _drawView;
    
    /*
     CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
     _picker.cameraViewTransform = translate;
     CGAffineTransform scale = CGAffineTransformScale(translate, 0.53333, 0.53333);
     _picker.cameraViewTransform = scale;
     */
    [_picker viewWillAppear:YES];
    [_picker viewDidAppear:YES];
    [self.drawView addSubview:self.picker.view];
    [self presentViewController:_picker animated:YES completion:nil];
    //[self presentViewController:_picker animated:YES completion:nil];
    
    
    
}


- (void)didReceiveAgentStreamView:(UIView * _Nonnull __weak)agentStreamView {
    
    NSLog(@">> Call to didReceiveAgentStreamView.");
    _agentStreamView = agentStreamView;
    [_agentStreamView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 250 - 167)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect PROSPECT_RECT = CGRectMake(0, self.view.frame.size.height - 250 - 167, self.view.frame.size.width, 250);
    
    [_drawView setFrame:PROSPECT_RECT];
    
        _picker = [[UIImagePickerController alloc] init] ;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.delegate = self;
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        _picker.showsCameraControls = NO;
        _picker.navigationBarHidden = YES;
        _picker.toolbarHidden = YES;
        _picker.view.frame = PROSPECT_RECT;
    _picker.cameraOverlayView = _drawView;
    
    /*
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    _picker.cameraViewTransform = translate;
    CGAffineTransform scale = CGAffineTransformScale(translate, 0.53333, 0.53333);
    _picker.cameraViewTransform = scale;
     */
    [_picker viewWillAppear:YES];
    [_picker viewDidAppear:YES];
    [self.drawView addSubview:self.picker.view];
    [self presentViewController:_picker animated:YES completion:nil];
    

    NSLog(@">> viewDidAppear - HERE");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect PROSPECT_RECT = CGRectMake(0, self.view.frame.size.height - 250 - 167, self.view.frame.size.width, 250);

    
    NSLog(@">> viewWillAppear - Beginning drawing...");
    
    NSLog(@">> viewWillAppear - self.view.frame.size.height :%@", [NSString stringWithFormat: @"%.2f", self.view.frame.size.height]);
    NSLog(@">> viewWillAppear - self.view.frame.size.width :%@", [NSString stringWithFormat: @"%.2f", self.view.frame.size.width]);
    
    
    _agentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 250 - 167)];
    [_agentContainer setBackgroundColor:[UIColor redColor]];
    [_agentContainer addSubview:_agentStreamView];
    
    _drawContainer = [[UIView alloc] initWithFrame:PROSPECT_RECT];
    [_drawContainer setBackgroundColor:[UIColor redColor]];
    [_drawContainer addSubview:_drawView];
    
    [_picker viewWillAppear:YES];
    [_picker viewDidAppear:YES];
    
    //[_drawView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // If you set userInteractionEnabled to YES the drawing will clear on any touch.
    //[_drawView setUserInteractionEnabled:YES];
    //[_drawView setFrame:[self view].frame];
    
    [self setupToolBar];
    [[self view] addSubview:_agentContainer];
    //[[self view] addSubview:_drawContainer];
    [[self view] addSubview:_picker.view];
    
    
    NSLog(@">> viewWillAppear - Endinf drawing.");
    
}

- (void)setupToolBar {
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 167, self.view.frame.size.width, 167);
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(handlePause:)];
    
    //UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(handleCameraTransition:)];
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(pb_takeSnapshotX:)];
    
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleClose)];
    
    UIBarButtonItem *muteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(handleMute:)];
    
    UIBarButtonItem *drawButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sos_button"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleDrawing)];
    
    UIBarButtonItem *agentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleAgent)];
    
    //NSArray *buttonItems = [NSArray arrayWithObjects:drawButton, flexibleItem, agentButton, flexibleItem, muteButton, flexibleItem, pauseButton, flexibleItem, cameraButton, flexibleItem, closeButton, nil];
    
    NSArray *buttonItems = [NSArray arrayWithObjects: flexibleItem, agentButton, flexibleItem, muteButton, flexibleItem, pauseButton, flexibleItem, cameraButton, flexibleItem, closeButton, nil];
    
    [toolbar setItems:buttonItems];
    
    [[self view] addSubview:toolbar];
}

- (void)toggleDrawing {
    
}

- (void)toggleAgent {
    
}

- (void)handleClose {
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"didFinishPickingMediaWithInfo - button tapped");
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    // SENDING ATTEMPT
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *b64 = [imageData base64EncodedStringWithOptions:0 ];
    
    NSDictionary *fields = @{
                             @"Name": @"sc.jpg",
                             @"Body": b64,
                             @"ParentId": @"5007E0000052JJA"
                             };
    
    SFRestRequest *attachmentRequest = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Attachment" fields:fields];
    
    [[SFRestAPI sharedInstance] sendRESTRequest:attachmentRequest failBlock:^(NSError *e) {
        NSLog(@"Error");
    } completeBlock:^(id dict){
        NSLog(@"Uploaded");
    }];
    
}




// can specify UIBarButtonItem instead of id for this case
-(IBAction)pb_takeSnapshotX:(UIBarButtonItem*)btn
{
    
    //[[[SFRestAPI sharedInstance] coordinator] revokeAuthentication];
    //[[[SFRestAPI sharedInstance] coordinator] authenticate];
    
    NSLog(@"pb_takeSnapshotX");
    NSLog(@"button tapped BEFORE");
    [_picker takePicture];
    
    NSLog(@"button tapped AFTER");
    
}

/*
- (UIImage *)pb_takeSnapshot  {
    
    // SNAPSHOT
    
    UIGraphicsBeginImageContextWithOptions( _agentStreamView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [_agentStreamView drawViewHierarchyInRect:_agentStreamView.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // SENDING ATTEMPT
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *b64 = [imageData base64EncodedStringWithOptions:0 ];
    
    NSDictionary *fields = @{
                             @"Name": @"sc.jpg",
                             @"Body": b64,
                             @"ParentId": @"5007E0000052JJA"
                             };
    
    SFRestRequest *attachmentRequest = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Attachment" fields:fields];
    
    [[SFRestAPI sharedInstance] sendRESTRequest:attachmentRequest failBlock:^(NSError *e) {
     NSLog(@"Error");
     } completeBlock:^(id dict){
     NSLog(@"Uploaded");
     }];
     
     
    
    return image;
}
*/



@end
