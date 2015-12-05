//
//  UIImage+DominantColor.m
//
//  Created by nikolai on 28.08.12.
//  Copyright (c) 2012 Savoy Software. All rights reserved.
//
//	Re-made by Sassoty to make it easier to import in your projects (git submodule, etc.)
//

#import "UIImage+DominantColor.h"

@implementation UIImage (DominantColor)

- (UIColor *)dominantColor
{
    CGImageRef rawImageRef = [self CGImage];

    // This function returns the raw pixel values
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(rawImageRef));
    const UInt8 *rawPixelData = CFDataGetBytePtr(data);

    NSUInteger imageHeight = CGImageGetHeight(rawImageRef);
    NSUInteger imageWidth  = CGImageGetWidth(rawImageRef);
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(rawImageRef);
	NSUInteger stride = CGImageGetBitsPerPixel(rawImageRef) / 8;

    // Here I sort the R,G,B, values and get the average over the whole image
    unsigned int red   = 0;
    unsigned int green = 0;
    unsigned int blue  = 0;

	for (int row = 0; row < imageHeight; row++) {
		const UInt8 *rowPtr = rawPixelData + bytesPerRow * row;
		for (int column = 0; column < imageWidth; column++) {
            red    += rowPtr[0];
            green  += rowPtr[1];
            blue   += rowPtr[2];
			rowPtr += stride;

        }
    }
	CFRelease(data);

	CGFloat f = 1.0f / (255.0f * imageWidth * imageHeight);
	return [UIColor colorWithRed:(f * red)  green:(f * green) blue:(f * blue) alpha:1];
}

@end
