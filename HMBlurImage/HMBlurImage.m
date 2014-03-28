//
//  HMBlurImage.m
//
//  Created by hugo mazet on 07/03/2014.


#import "HMBlurImage.h"

@implementation HMBlurImage

+ (void)setImageToBlur: (UIImageView *)imageView
            blurRadius: (CGFloat)blurRadius
{
    CIContext *context   = [CIContext contextWithOptions:nil];
    CIImage *sourceImage = [CIImage imageWithCGImage:imageView.image.CGImage];
    
    // Apply clamp filter:
    // this is needed because the CIGaussianBlur when applied makes
    // a trasparent border around the image
    
    NSString *clampFilterName = @"CIAffineClamp";
    CIFilter *clamp = [CIFilter filterWithName:clampFilterName];
    
    if (!clamp)
        return;
    
    [clamp setValue:sourceImage
             forKey:kCIInputImageKey];
    
    CIImage *clampResult = [clamp valueForKey:kCIOutputImageKey];
    
    // Apply Gaussian Blur filter
    
    NSString *gaussianBlurFilterName = @"CIGaussianBlur";
    CIFilter *gaussianBlur           = [CIFilter filterWithName:gaussianBlurFilterName];
    
    if (!gaussianBlur)
        return;
    
    
    [gaussianBlur setValue:clampResult
                    forKey:kCIInputImageKey];
    [gaussianBlur setValue:[NSNumber numberWithFloat:blurRadius]
                    forKey:@"inputRadius"];
    
    CIImage *gaussianBlurResult = [gaussianBlur valueForKey:kCIOutputImageKey];
    
    __weak UIImageView *selfWeak = imageView;
    
    // THREAD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGImageRef cgImage = [context createCGImage:gaussianBlurResult
                                           fromRect:[sourceImage extent]];
        
        UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            selfWeak.image = blurredImage;
        });
    });
}


@end
