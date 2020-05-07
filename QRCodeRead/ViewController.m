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

    CIImage *ciImage = [pickedImage CIImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:ciImage];
    if (features == nil) {
        NSLog(@"QRCode failed: no qr code");
        return;
    }

    if (features.count == 0) {
        //TODO: QR Code decode fail.
        NSLog(@"QRCode failed: decode fail");
        return;
    }

    CIQRCodeFeature *qrcodeFeature = (CIQRCodeFeature *) features[0];
    NSLog(@"QRCode feature: %@", qrcodeFeature.messageString);
}
@end
