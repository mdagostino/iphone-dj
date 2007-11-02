////////////////////////////////////////////////////////////////////////////////
// UIGLView.m
//
// Andrew Willmott, September 2007
////////////////////////////////////////////////////////////////////////////////

#import "UIGLView.h"

#import <UIKit/UIView-Rendering.h>
#import <LayerKit/LKLayer.h>

#include <OpenGLES/gl.h>

#ifndef GRAPHICSSERVICES_H
#define GRAPHICSSERVICES_H

#import <UIKit/UIKit.h>

struct __GSEvent;
typedef struct __GSEvent GSEvent;
typedef GSEvent *GSEventRef;

struct CGPoint;
struct CGRect;
typedef struct CGPoint CGPoint;
typedef struct CGRect CGRect;

int GSEventIsChordingHandEvent(GSEvent *ev);
int GSEventGetClickCount(GSEvent *ev);
CGRect GSEventGetLocationInWindow(GSEvent *ev);
float GSEventGetDeltaX(GSEvent *ev);
float GSEventGetDeltaY(GSEvent *ev);
CGRect  GSEventGetInnerMostPathPosition(GSEvent *ev);
CGRect GSEventGetOuterMostPathPosition(GSEvent *ev);

void GSEventVibrateForDuration(float secs);

#endif


static void PerspectiveMatrix(float fovy, float aspect, float zNear, float zFar)
{
    float f = 1.0f / tanf(fovy * (M_PI / 360.f));
    float z1 = (zFar + zNear) / (zNear - zFar);
    float z2 = (2 * zFar * zNear) / (zNear - zFar);

    float m[] =
    {
        f / aspect,  0,      0,      0,
        0,           f,      0,      0,
        0,           0,     z1,     -1,
        0,           0,     z2,      0
    };

    glMultMatrixf(m);
}


static CoreSurfaceBufferRef CreateSurface(int w, int h)
{
    int pitch = w * 2, allocSize = 2 * w * h;
    char *pixelFormat = "565L";
    CFMutableDictionaryRef dict;

    dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(dict, kCoreSurfaceBufferGlobal,        kCFBooleanTrue);
    CFDictionarySetValue(dict, kCoreSurfaceBufferMemoryRegion,  CFSTR("PurpleGFXMem"));
    CFDictionarySetValue(dict, kCoreSurfaceBufferPitch,         CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &pitch));
    CFDictionarySetValue(dict, kCoreSurfaceBufferWidth,         CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &w));
    CFDictionarySetValue(dict, kCoreSurfaceBufferHeight,        CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &h));
    CFDictionarySetValue(dict, kCoreSurfaceBufferPixelFormat,   CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, pixelFormat));
    CFDictionarySetValue(dict, kCoreSurfaceBufferAllocSize,     CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &allocSize));

    return CoreSurfaceBufferCreate(dict);
}


@implementation UIGLView

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        EGLDisplay eglDisplay = eglGetDisplay(0);

        EGLint versMajor;
        EGLint versMinor;
        EGLBoolean result = eglInitialize(eglDisplay, &versMajor, &versMinor);
        
        if (result)
        {
            printf("GL version %d.%d\n", versMajor, versMinor);
            
            EGLint configAttribs[] =
            {
                EGL_BUFFER_SIZE, 16,
                EGL_DEPTH_SIZE, 16,
                EGL_SURFACE_TYPE, EGL_PBUFFER_BIT,
                EGL_NONE
            };

            int numConfigs;
            EGLConfig eglConfig;
            if (!eglChooseConfig(eglDisplay, configAttribs, &eglConfig, 1, &numConfigs) || (numConfigs != 1))
                printf("failed to find usable config =(\n");
            else
            {
                GLint configID;
                eglGetConfigAttrib(eglDisplay, eglConfig, EGL_CONFIG_ID, &configID);
            }
                
            EGLContext eglContext = eglCreateContext(eglDisplay, eglConfig, EGL_NO_CONTEXT, 0);
            
            if (eglContext == EGL_NO_CONTEXT)
                printf("failed to allocate context =(\n");
        
            CoreSurfaceBufferRef screenSurface = CreateSurface(frame.size.width, frame.size.height);
            
            CoreSurfaceBufferLock(screenSurface, 3);
            LKLayer* screenLayer = [[LKLayer layer] retain];
            [screenLayer setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [screenLayer setContents: screenSurface];
            [screenLayer setOpaque: YES];
            [_layer addSublayer: screenLayer];
            CoreSurfaceBufferUnlock(screenSurface);
            
            EGLSurface eglSurface = eglCreatePixmapSurface(eglDisplay, eglConfig, screenSurface, 0);
           
            if (eglSurface == EGL_NO_SURFACE)
                printf("failed to create surface =(, %04x\n", eglGetError());

            mEGLDisplay = eglDisplay;
            mEGLContext = eglContext;
            mEGLSurface = eglSurface;
            mScreenSurface = screenSurface;
            
            if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext))
                printf("make current error: %04x\n", eglGetError());
        }
    }
    
    return self;
}

- (void)beginScene
{
    eglWaitNative(EGL_CORE_NATIVE_ENGINE);
    CoreSurfaceBufferLock(mScreenSurface, 3);
    if (!eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext))
        printf("make current error: %04x\n", eglGetError());
}

- (void)endScene
{
    eglWaitGL();
    eglMakeCurrent(mEGLDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    CoreSurfaceBufferUnlock(mScreenSurface);
}

@end





@implementation UIGLCameraView

- (id)initWithFrame:(CGRect)frame 
{
    mZUp = 1;
    
    [self resetView];
    return [super initWithFrame:frame];
}

- (void) resetView
{
    mCameraTheta = 45;
    mCameraPhi = 30;
    mCameraDistance = 7;
    mCameraOffsetX = 0;
    mCameraOffsetY = 0;
    mCameraFOV = 50;

    mStartCameraTheta = 0;
    mStartCameraPhi = 0;
    mStartCameraDistance = 0;
    mStartCameraOffsetX = 0;
    mStartCameraOffsetY = 0;

    mMouseX = 0;
    mMouseY = 0;
    mMouseDownX = 0;
    mMouseDownY = 0;
}

- (void) positionCamera
{
    int tw, th;

    eglQuerySurface(mEGLDisplay, mEGLSurface, EGL_WIDTH,  &tw);
    eglQuerySurface(mEGLDisplay, mEGLSurface, EGL_HEIGHT, &th);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    PerspectiveMatrix(mCameraFOV, (float) tw / (float) th, 0.1f, 1000);
    if (mZUp)
        glRotatef(-90, 1, 0, 0);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    if (mZUp)
        glTranslatef(mCameraOffsetX, mCameraDistance, mCameraOffsetY);
    else
        glTranslatef(mCameraOffsetX, mCameraOffsetY, -mCameraDistance);

    glRotatef(mCameraPhi,   1, 0, 0);
    glRotatef(mCameraTheta, 0, 0, 1);
}


- (void) mouseDown:(GSEvent*)event
{
    CGRect location = GSEventGetLocationInWindow(event);
    float x = CGRectGetMinX(location);
    float y = CGRectGetMinY(location);
    
    int startCount = (int) GSEventGetDeltaX(event);
    if (startCount == 2)    // simultaneous double-finger tap
        [self resetView];
        
    int count = (int) GSEventGetDeltaY(event);

    mMouseDownX = x;
    mMouseDownY = y;
    mButtonDown = count;
    
    mStartCameraTheta    = mCameraTheta;
    mStartCameraPhi      = mCameraPhi;
    mStartCameraDistance = mCameraDistance;
    mStartCameraOffsetX  = mCameraOffsetX;
    mStartCameraOffsetY  = mCameraOffsetY;
}

- (void)mouseUp:(GSEvent*)event
{
    mButtonDown = 0;    // we only ever get one mouse-up event, when the last finger goes up
}


- (void)mouseDragged:(GSEvent*)event
{
    CGRect location = GSEventGetLocationInWindow(event);
    float x = location.origin.x;
    float y = location.origin.y;
    int count = (int) GSEventGetDeltaY(event);

    if (mButtonDown != count)
    {
        [self mouseDown: event];
    }
    
    enum tMode
    {
        kModeRotate,
        kModePanXY,
        kModeZoomX,
        kModeZoomY,
        kModeZoomXY,
        kModeNone
    };

    int mode = kModeNone;

    if (mButtonDown == 3)
        mode = kModePanXY;
    else if (mButtonDown == 2)
        mode = kModeZoomXY;
    else if (mButtonDown == 1)
        mode = kModeRotate;

    float dx = (x - mMouseDownX) / 400.0;
    float dy = (y - mMouseDownY) / 400.0;

    switch (mode)
    {
    case kModePanXY:
        mCameraOffsetX = mStartCameraOffsetX + 4.0 * dx;
        mCameraOffsetY = mStartCameraOffsetY - 4.0 * dy;
        break;
        
    case kModeZoomX:
        mCameraDistance = mStartCameraDistance + 4.0 * dx;
        break;
        
    case kModeZoomY:
        mCameraDistance = mStartCameraDistance - 4.0 * dy;
        break;
        
    case kModeZoomXY:
        mCameraDistance = mStartCameraDistance + 4.0 * (dx - dy);
        break;
        
    case kModeRotate:
        mCameraTheta = mStartCameraTheta + dx * 180;
        mCameraPhi   = mStartCameraPhi   + dy * 180;
        if (mCameraPhi < -90) 
            mCameraPhi = -90;
        if (mCameraPhi >  90) 
            mCameraPhi =  90;
        break;
    }
}

@end



