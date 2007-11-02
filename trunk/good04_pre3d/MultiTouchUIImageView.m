#import "MultiTouchUIImageView.h"

@implementation MultiTouchUIImageView

+ (void)load
{
	printf("* Loading MultiTouchUIImageView\n");
	[self poseAsClass: [UIImageView class]];
}

- (BOOL)ignoresMouseEvents 
{
	return YES;
}

@end

