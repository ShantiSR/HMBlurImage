//
//  HMBlurImage.h
//
//  Created by hugo mazet on 07/03/2014.


#import <Foundation/Foundation.h>

@interface HMBlurImage : NSObject

+ (void)setImageToBlur: (UIImageView *)imageView
            blurRadius: (CGFloat)blurRadius;

@end
