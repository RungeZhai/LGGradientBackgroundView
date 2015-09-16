//
//  LGGradientBackgroundView.h
//  LGGradientBackgroundView
//
//  Created by liuge on 8/2/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef IB_DESIGNABLE
IB_DESIGNABLE
#endif

#ifndef IBInspectable
#define IBInspectable
#endif

typedef enum : NSUInteger {
    LGGradientBGViewImplementMethodCAGradientLayer,
    LGGradientBGViewImplementMethodCGGradientRef,
    LGGradientBGViewImplementMethodCoreImage,
} LGGradientBackgroundViewImplementMethod;


@interface LGGradientBackgroundView : UIView

@property (nonatomic) IBInspectable int implementMethod;

/* Both points are
 * defined in a unit coordinate space that is then mapped to the
 * view's bounds rectangle when drawn. (I.e. [0,0] is the top-left
 * corner of the view, [1,1] is the bottom-right corner.) */
@property (nonatomic) IBInspectable CGPoint inputPoint0;
@property (nonatomic) IBInspectable CGPoint inputPoint1;

@property (nonatomic) IBInspectable UIColor *inputColor0;
@property (nonatomic) IBInspectable UIColor *inputColor1;

@end
