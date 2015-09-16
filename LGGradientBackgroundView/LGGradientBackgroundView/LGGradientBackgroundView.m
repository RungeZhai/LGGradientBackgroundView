//
//  LGGradientBackgroundView.m
//  LGGradientBackgroundView
//
//  Created by liuge on 8/2/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import "LGGradientBackgroundView.h"

@interface LGGradientBackgroundView () {
    CGRect _previousRect;
}

@property (weak, nonatomic) CALayer *gradientLayer;

@end


@implementation LGGradientBackgroundView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_implementMethod == LGGradientBGViewImplementMethodCAGradientLayer) {
        if (!CGRectEqualToRect(self.bounds, _previousRect)) {
            _previousRect = self.bounds;
            
            if (!_gradientLayer) {
                CAGradientLayer *layer = [CAGradientLayer new];
                layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
                layer.startPoint = _inputPoint0;
                layer.endPoint = _inputPoint1;
                layer.frame = self.bounds;
                
                _gradientLayer = layer;
                [self.layer addSublayer:layer];
            }
            
            _gradientLayer.frame = _previousRect;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (_implementMethod == LGGradientBGViewImplementMethodCGGradientRef) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0, 1};
        NSArray *colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
        CGColorSpaceRelease(colorSpace);
        
        CGPoint startPoint = (CGPoint){rect.size.width * _inputPoint0.x, rect.size.height * _inputPoint0.y};
        CGPoint endPoint = (CGPoint){rect.size.width * _inputPoint1.x, rect.size.height * _inputPoint1.y};
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        
        CGGradientRelease(gradient);
        UIGraphicsPopContext();
    } else if (_implementMethod == LGGradientBGViewImplementMethodCoreImage) {
        CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
        
        /*
         * Note that the coordinate used by Core Image ((0, 0) at bottomleft)
         * is different from the one used by CGContext ((0, 0) at topleft).
         */
        CIVector *vector0 = [CIVector vectorWithX:rect.size.width * _inputPoint0.x Y:rect.size.height * (1 - _inputPoint0.y)];
        CIVector *vector1 = [CIVector vectorWithX:rect.size.width * _inputPoint1.x Y:rect.size.height * (1 - _inputPoint1.y)];
        [ciFilter setValue:vector0 forKey:@"inputPoint0"];
        [ciFilter setValue:vector1 forKey:@"inputPoint1"];
        [ciFilter setValue:[CIColor colorWithCGColor:_inputColor0.CGColor] forKey:@"inputColor0"];
        [ciFilter setValue:[CIColor colorWithCGColor:_inputColor1.CGColor] forKey:@"inputColor1"];
        
        CIImage *ciImage = ciFilter.outputImage;
        
        /*
         * Important: Some Core Image filters produce images of infinite extent, 
         * such as those in the CICategoryTileEffect category. 
         * Prior to rendering, infinite images must either be cropped (CICrop filter) 
         * or you must specify a rectangle of finite dimensions for rendering the image.
         * https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html
         * So directly init a UIImage with CIImage using imageWithCIImage is not going to work.
         */
        CIContext* con = [CIContext contextWithOptions:nil];
        CGImageRef resultCGImage = [con createCGImage:ciImage
                                             fromRect:rect];
        UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
        CGImageRelease(resultCGImage);
        
        [resultUIImage drawInRect:rect];
    }
}




@end
