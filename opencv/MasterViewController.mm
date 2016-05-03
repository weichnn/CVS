//
//  MasterViewController.m
//  opencv
//
//  Created by WeiChen on 4/26/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "BaseSampleViewController.h"

#import "AppDelegate.h"

#import "SampleBase.h"
#import "SampleFacade.h"

#import "ContourDetectionSample.h"
#import "EdgeDetectionSample.h"
#import "ImageFiltersSample.h"
#import "ROFSample.h"
#import "CartoonFilter.h"
#import "VideoTracking.hpp"
#import "FeatureDetectionSample.h"
#import "ObjectTrackingSample.h"
#import "DrawingCanvas.h"
#import "CameraCalibrationSample.h"

@interface MasterViewController ()
{
    std::vector<SampleFacade*> allSamples;
}
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new EdgeDetectionSample()]);
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new ImageFiltersSample()]);
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new ContourDetectionSample()]);
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new CartoonFilter()]);
#if ! defined(TARGET_IPHONE_SIMULATOR)
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new VideoTrackingSample()]);
#endif
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new FeatureDetectionSample()]);
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new ObjectTrackingSample()]);
    
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new ROFSample()]);
    allSamples.push_back([[SampleFacade alloc] initWithSample:  new DrawingCanvasSample()]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    return allSamples.size();
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    SampleFacade * sample = allSamples[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [sample title];
    cell.imageView.image = [sample smallIcon];
    
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        SampleFacade * sample = allSamples[indexPath.row];
        
        [[segue destinationViewController] setDetailItem:sample];
    }
}


@end
