//
//  DetailViewController.m
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import "DetailViewController.h"
#import "VideoViewController.h"
#import "ImageViewController.h"
#import "NSString+StdString.h"

@interface DetailViewController ()


@property (weak, nonatomic) ImageViewController * activeImageController;
@property (weak, nonatomic) VideoViewController * activeVideoController;

- (void)configureView;
@end

@implementation DetailViewController

- (void)setDetailItem:(SampleFacade*) sample
{
    if (currentSample != sample)
    {
        currentSample = sample;
        [self configureView];
    }
    
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (currentSample)
    {
        self.sampleDescriptionTextView.text = [currentSample description];

        self.title = [currentSample title];
        self.sampleIconView.image = [currentSample largeIcon];
        
        if (self.activeImageController)
            [self.activeImageController setSample:currentSample];
        if (self.activeVideoController)
            [self.activeVideoController setSample:currentSample];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"processVideo"])
    {
        VideoViewController * sampleController = [segue destinationViewController];
        [sampleController setSample:currentSample];
        self.activeVideoController = sampleController;
    }
    else if ([[segue identifier] isEqualToString:@"processImage"])
    {
        ImageViewController * sampleController = [segue destinationViewController];
        [sampleController setSample:currentSample];
        self.activeImageController = sampleController;
    }
}

@end
