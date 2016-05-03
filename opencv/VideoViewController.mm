//
//  VideoViewController.m
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import "VideoViewController.h"
#import "UIImage2OpenCV.h"
#import "OptionsTableView.h"

#import <opencv2/videoio/cap_ios.h>

#define kTransitionDuration	0.75

@interface VideoViewController ()<CvVideoCameraDelegate,UIScrollViewDelegate>
{
    cv::Mat outputFrame;
    BOOL outputProcessedData;
    BOOL processImage;
}
@property (nonatomic, strong) CvVideoCamera* videoSource;

@property (strong, nonatomic) UIBarButtonItem *pauseButton;
@end

@implementation VideoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.videoSource = [[CvVideoCamera alloc] initWithParentView:self.containerView];
    self.videoSource.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoSource.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
    _videoSource.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoSource.defaultFPS = 30;
    //self.videoSource.imageWidth = 1280;
    //self.videoSource.imageHeight = 720;
    self.videoSource.delegate = self;
    self.videoSource.recordVideo = NO;
    self.videoSource.grayscaleMode = NO;
    _scrollerView.delegate=self;
    outputProcessedData = false;
    processImage = false;
    _pauseButton = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                    target:self
                    action:@selector(stopProcessedVideo:)];
    
    
    self.actionSheet = [UIAlertController alertControllerWithTitle:@"Save Photo"
                                                           message:nil
                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:kSaveImageActionTitle
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self.videoSource stop];
                                                              UIImage * image = [UIImage imageWithMat:outputFrame.clone() andDeviceOrientation:[[UIDevice currentDevice] orientation]];
                                                              [self saveImage:image withCompletionHandler: ^{ [self.videoSource start]; }];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.actionSheet addAction:firstAction];
    [self.actionSheet addAction:cancelAction];
}




- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"capture session loaded: %d", [self.videoSource captureSessionLoaded]);
    
    _toggleCameraButton.enabled = true;
    _captureReferenceFrameButton.enabled = self.currentSample.isReferenceFrameRequired;
    _clearReferenceFrameButton.enabled   = self.currentSample.isReferenceFrameRequired;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.videoSource start];
    
    //[self.videoSource adjustLayoutToInterfaceOrientation:self.interfaceOrientation];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.videoSource stop];
}

#pragma mark - scrollview delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _containerView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

- (void) configureView
{
    [super configureView];
    
    self.optionsView = [[OptionsTableView alloc] initWithFrame:_scrollerView.frame
                                                         style:UITableViewStyleGrouped
                                                        sample:self.currentSample
                                         notificationsDelegate:nil];
    
    
}

-(void)stopProcessedVideo:(id)sender
{
    self.navigationItem.rightBarButtonItem = _processButton;
    outputProcessedData = false;
    processImage = NO;
}

-(void)showProcessedVideo:(id)sender
{
    self.navigationItem.rightBarButtonItem = _pauseButton;
    outputProcessedData = true;
    processImage = YES;
}

- (IBAction)toggleCameraPressed:(id)sender
{
    [self.videoSource switchCameras];
}

- (IBAction)showActionSheet:(id)sender
{
    [self presentViewController:self.actionSheet animated:YES completion:nil];
}





- (IBAction)showOptions:(id)sender
{

    if ([self.optionsView superview])
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView transitionFromView:self.optionsView
                            toView:_scrollerView
                          duration:kTransitionDuration
                           options:UIViewAnimationOptionTransitionCurlDown
                        completion:^(BOOL)
         {
         }];
    }
    else
    {
        
        CGRect frame = _scrollerView.frame;
        frame.origin.y = 0;
        frame.size.height += 67;
        [self.optionsView setFrame:frame];
        [self.optionsView setNeedsLayout];
        
        [UIView transitionFromView:_scrollerView
                            toView:self.optionsView
                          duration:kTransitionDuration
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL)
         {
             [self.optionsView reloadData];
             [self.navigationController setNavigationBarHidden:YES animated:YES];
         }];
    }

}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void) processImage:(cv::Mat&)image
{
    // Do some OpenCV stuff with the image
    if (processImage) {
        [self.currentSample processFrame:image into:outputFrame];
    }
    else{
        image.copyTo(outputFrame);
    }
    
    if (outputProcessedData) {
        outputFrame.copyTo(image);
    }
    
}
#endif

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation: fromInterfaceOrientation];
    [self.videoSource adjustLayoutToInterfaceOrientation:self.interfaceOrientation];
}

#pragma mark - Capture reference frame

- (IBAction) captureReferenceFrame:(id) sender
{
    dispatch_async( dispatch_get_main_queue(),
                   ^{
                       [self.currentSample setReferenceFrame:outputFrame];
                   });
}

#pragma mark - Clear reference frame

- (IBAction) clearReferenceFrame:(id) sender
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.currentSample resetReferenceFrame];
                   });
}

@end