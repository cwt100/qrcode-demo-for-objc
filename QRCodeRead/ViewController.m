//
//  ViewController.m
//  QRCodeRead
//
//  Created by Cheng Wan Ting on 2020/5/7.
//  Copyright © 2020 Cheng Wan Ting. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma Browser
- (IBAction)onBrowserFileClick:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (info == nil) {
        NSLog(@"QRCode failed: info is nil");
        return;
    }

    UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (pickedImage == nil) {
        NSLog(@"QRCode failed: pick image failed");
        return;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:pickedImage];
    NSDictionary *options;
    CIContext *context = [CIContext context];
    options = @{CIDetectorAccuracy: CIDetectorAccuracyHigh};
    
    CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                                context:context
                                                options:options];
    if ([[ciImage properties] valueForKey:(NSString *) kCGImagePropertyOrientation] == nil) {
        options = @{CIDetectorImageOrientation: @1};
        NSLog(@"CIDetectorImageOrientation: @1");
    }else {
        options = @{CIDetectorImageOrientation: [[ciImage properties] valueForKey:(NSString *) kCGImagePropertyOrientation]};
        NSLog(@"CIDetectorImageOrientation: [[ciImage properties] valueForKey:(NSString *) kCGImagePropertyOrientation]");
    }
    
    NSArray *features = [qrDetector featuresInImage:ciImage options:options];
    if (features == nil) {
        NSLog(@"QR Code failed: no qr code");
        return;
    }
    
    if (features.count == 0) {
        NSLog(@"QR Code failed: decode fail");
        return;
    }
    
    CIQRCodeFeature *qrcodeFeature = (CIQRCodeFeature *) features[0];
    NSLog(@"QR Code feature: %@", qrcodeFeature.messageString);

}
@end
