////////////////////////////////////////////////////////////////////////////////
// UIGLView.h
//
// Provides UIView for OpenGL drawing on iPhone
//
// Andrew Willmott, September 2007
////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIView.h>
#include <OpenGLES/egl.h>
#import <CoreSurface/CoreSurface.h>



void gluLookAt(float eyeX, float eyeY, float eyeZ, float lookAtX, float lookAtY, float lookAtZ, float upX, float upY, float upZ) ;



////////////////////////////////////////////////////////////////////////////////
// UIGLView
//
// Provides an OpenGL view.
//
// You should override drawRect with something like:
//    [self beginScene];
//    glBlah...
//    [self endScene];
//
// and then call [view setNeedsUpdate]
@interface UIGLView : UIView 
{
    EGLDisplay mEGLDisplay;
    EGLContext mEGLContext;
    EGLSurface mEGLSurface;
    CoreSurfaceBufferRef mScreenSurface;
}

- (id)initWithFrame:(CGRect)frame;

- (void)beginScene;
// call in drawRect, before OpenGL rendering statements
- (void)endScene;
// call in drawRect, after OpenGL rendering statements

@end

////////////////////////////////////////////////////////////////////////////////
// Provides a UIGLView with built-in view controls:
//
//   single-finger drag: rotate around and up/down
//   double-finger drag (or anchor one finger and drag the second up and down): zoom in/out
//   triple-finger drag (anchor two fingers, drag the other left/right or up/down): translate viewpoint
//   two-finger tap: reset view
//
// In drawRect, call positionCamera when you need to set the camera matrices.
@interface UIGLCameraView : UIGLView
{
    bool    mZUp;               // Set to 0 or 1 to indicate whether we do Z-up or Y-up
    
    // Camera internals
    GLfloat  mCameraTheta;
    GLfloat  mCameraPhi;
    GLfloat  mCameraDistance;
    GLfloat  mCameraOffsetX;
    GLfloat  mCameraOffsetY;
    GLfloat  mCameraFOV;

    // dragging internals
    GLfloat  mStartCameraTheta;
    GLfloat  mStartCameraPhi;
    GLfloat  mStartCameraDistance;
    GLfloat  mStartCameraOffsetX;
    GLfloat  mStartCameraOffsetY;

    int      mButtonDown;
    
    float    mMouseX;
    float    mMouseY;
    float    mMouseDownX;
    float    mMouseDownY;
}

- (void) positionCamera;
// Call to set camera matrices

- (void) resetView;
// override this to provide your own initial settings for mCamera* above.
// also, call to manually reset the view.
@end

