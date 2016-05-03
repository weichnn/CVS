//
//  BaseSampleViewController.m
//  OpenCV Tutorial
//
//  Created by BloodAxe on 7/20/12.
//  Copyright (c) 2012 computer-vision-talks.com. All rights reserved.
//

#import "BaseSampleViewController.h"
#import "NSString+StdString.h"
#import "UIImage2OpenCV.h"

@interface BaseSampleViewController ()

@end

@implementation BaseSampleViewController
@synthesize currentSample = _currentSample;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void) setSample:(SampleFacade*) sample
{
  _currentSample = sample;
  
  [self configureView];
}

- (void) configureView
{
  if (self.currentSample)
  {
      const OptionsMap& options = [_currentSample getOptions];

      if (options.begin()->second[0] != nil){
          SampleOption * option = options.begin()->second[0];
          StringEnumOption* opt = dynamic_cast<StringEnumOption*>(option);
          NSString *text = [NSString stringWithStdString:opt->getValue()];
          self.title = text;

      }
    //self.title = [self.currentSample title];
  }
}

#pragma mark - Image Saving

- (void) saveImage:(UIImage *) image   withCompletionHandler: (SaveImageCompletionHandler) handler
{
  UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  if (handler)
    handler();
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  if (error != NULL)
  {
    NSLog(@"Error during saving image: %@", error);    
  }
}




@end
