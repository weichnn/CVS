//
//  ImageViewController.h
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleBase.h"
#import "OptionsTableView.h"
#import "OptionCell.h"
#import "BaseSampleViewController.h"


@interface ImageViewController : BaseSampleViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, OptionCellDelegate>

- (void) setImage:(UIImage*) image;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) OptionsTableView *optionsView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIViewController * optionsViewController;
@property (nonatomic, strong) UIAlertController * actionSheet;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

- (IBAction) presentOptionsView:(id)sender;
- (IBAction) selectPictureForProcessing:(id) sender;
- (IBAction) selectAction:(id)sender;


@end