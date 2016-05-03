//
//  DetailViewController.h
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleFacade.h"
@interface DetailViewController : UIViewController
{
    SampleFacade* currentSample;
    UIImagePickerController * imagePicker;
}

@property (weak, nonatomic) IBOutlet UIImageView *sampleIconView;
@property (weak, nonatomic) IBOutlet UITextView *sampleDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *runOnImageButton;
@property (weak, nonatomic) IBOutlet UIButton *runOnVideoButton;

- (void) setDetailItem:(SampleFacade*) sample;
- (void) configureView;

@end
