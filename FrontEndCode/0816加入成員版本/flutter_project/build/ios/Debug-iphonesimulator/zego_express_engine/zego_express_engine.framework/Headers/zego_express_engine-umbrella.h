#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ZegoEffectsPixelBufferHelper.h"
#import "ZegoExpressEngineEventHandler.h"
#import "ZegoExpressEngineMethodHandler.h"
#import "ZegoLog.h"
#import "ZegoPlatformView.h"
#import "ZegoPlatformViewFactory.h"
#import "ZegoTextureRenderer.h"
#import "ZegoTextureRendererController.h"
#import "ZegoUtils.h"
#import "ZegoCustomVideoCaptureManager.h"
#import "ZegoCustomVideoDefine.h"
#import "ZegoCustomVideoProcessManager.h"
#import "ZegoCustomVideoRenderManager.h"
#import "ZegoExpressEnginePlugin.h"
#import "ZegoMediaPlayerBlockDataManager.h"
#import "ZegoMediaPlayerVideoManager.h"

FOUNDATION_EXPORT double zego_express_engineVersionNumber;
FOUNDATION_EXPORT const unsigned char zego_express_engineVersionString[];

