//
//  ImageViewController.m
//  opencv
//
//  Created by WeiChen on 4/27/16.
//  Copyright © 2016 WeiChen. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImage2OpenCV.h"
#import "SampleOptionsTableViewDelegate.h"
#import "NSString+StdString.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#define kTransitionDuration	0.75

#define kSaveImageActionTitle  @"Save image"

@interface ImageViewController ()<UIScrollViewDelegate>
{
    UIImage     * currentImage;

}

- (void) configureView;
- (void) updateImageView;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;


@end

@implementation ImageViewController


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    

   
    
    
    // create the initial image view
    self.imageView = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    [self.imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    _imageView.image = [UIImage imageNamed:@"taphere.jpg"];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];

    _scrollView.delegate=self;
    [_scrollView addSubview:_imageView];
//    [self.containerView addSubview:self.imageView];
    
    
    self.actionSheet = [UIAlertController alertControllerWithTitle:@"Save Photo"
                                                           message:nil
                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [_actionSheet addAction:cancelAction];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:kSaveImageActionTitle
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self saveImage:self.imageView.image withCompletionHandler:nil];
                                                          }];
    [self.actionSheet addAction:firstAction];
}
#pragma mark - scrollview delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

#pragma mark - Sample management

- (void) setImage:(UIImage*) image
{
    currentImage = image;
    [self updateImageView];
}

- (void) configureView
{
    [super configureView];
    
    self.optionsView = [[OptionsTableView alloc] initWithFrame:_containerView.frame
                                                         style:UITableViewStyleGrouped
                                                        sample:self.currentSample
                                         notificationsDelegate:self];
    
    [self updateImageView];
}

- (void) updateImageView
{
    if (self.currentSample && currentImage)
    {
        [_scrollView setZoomScale:1 animated:YES];
        self.imageView.image = [self.currentSample processFrame:currentImage];
    }
}

#pragma mark - Handling user interaction

- (IBAction) selectPictureForProcessing:(id)sender
{

    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

- (IBAction)presentOptionsView:(id)sender
{
    if ([self.optionsView superview])
    {
        if (_scrollView == nil) {
            NSLog(@"oh no the scrollview is nil");
        }
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView transitionFromView:self.optionsView
                            toView:_scrollView
                          duration:kTransitionDuration
                           options:UIViewAnimationOptionTransitionCurlDown
                        completion:^(BOOL)
         {
             const OptionsMap& options = [self.currentSample getOptions];
             SampleOption * option = options.begin()->second[0];
             StringEnumOption* opt = dynamic_cast<StringEnumOption*>(option);
             NSString *text = [NSString stringWithStdString:opt->getValue()];
             self.title = text;
             [self updateImageView];
         }];
    }
    else
    {
        CGRect frame = self.containerView.frame;
        frame.origin.y = -46;
        frame.size.height += 46;
        [self.optionsView setFrame:frame];
        [self.optionsView setNeedsLayout];
        
        if (_scrollView == nil) {
            NSLog(@"oh no scrollview is nil");
        }
        [UIView transitionFromView:_scrollView
                            toView:_optionsView
                          duration:kTransitionDuration
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL)
         {

             [self.optionsView reloadData];
             
             NSLog(@"Visible cells count %lu" , (unsigned long)[[self.optionsView visibleCells] count]);
             NSLog(@"Options view size %fx%f" , self.optionsView.bounds.size.width, self.optionsView.bounds.size.height);
             [self.navigationController setNavigationBarHidden:YES animated:YES];
         }];
        
    }
    
}

- (IBAction)selectAction:(id)sender
{
    [self presentViewController:self.actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [picker dismissViewControllerAnimated:YES completion:nil];


    
    UIImage * editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (editImage != nil)
    {
        [self setImage:editImage];
        return;
    }
    
    UIImage * origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (origImage != nil)
    {
        [self setImage:origImage];
        return;
    }
    
    NSURL * imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (imageUrl != nil)
    {
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            
            if (iref != nil)
            {
                NSLog(@"Loaded image from assets library");
                UIImage * pickedImage = [[UIImage alloc] initWithCGImage:iref];
                [self setImage:pickedImage];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror)
        {
            NSLog(@"failed");
        };
        
        [assetLibrary assetForURL:imageUrl
                      resultBlock:resultblock
                     failureBlock:failureblock];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - OptionCellDelegate implementation

- (void) optionDidChanged:(SampleOption*) option
{
    //[self updateImageView];
}
@end

