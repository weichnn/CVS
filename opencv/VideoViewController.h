//
//  VideoViewController.h
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleBase.h"
#import "BaseSampleViewController.h"

@interface VideoViewController : BaseSampleViewController

@property (strong, nonatomic) IBOutlet UIImageView *containerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleCameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *options;

@property (nonatomic, strong) UITableView * optionsView;
@property (nonatomic, strong) UIViewController * optionsViewController;

@property (nonatomic, strong) UIAlertController * actionSheet;

- (IBAction)toggleCameraPressed:(id)sender;
- (IBAction)showOptions:(id)sender;
- (IBAction)captureReferenceFrame:(id)sender;
- (IBAction)clearReferenceFrame:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionSheetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *captureReferenceFrameButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearReferenceFrameButton;

- (IBAction)showActionSheet:(id)sender;
- (IBAction)showProcessedVideo:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *processButton;

@end

