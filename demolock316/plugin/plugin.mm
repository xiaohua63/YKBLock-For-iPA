#line 1 "/Users/yuayu/Downloads/BCPULS/plugin/plugin.xm"

#import "ZJHURLProtocol.h"
#import <UIKit/UIKit.h>
#import <substrate.h>
#import <sys/sysctl.h>
#import "XVC.h"
#import "AESCrypt.h"
#import "RSA.h"
#import "fishhook.h"
#include <dlfcn.h>

@interface QQViewController : UIViewController
@end

@interface QQSettingsViewController : UIViewController
- (void)tweakItemTapped:(id)sender;
@end

@interface PreviewSecretPictureViewController : UIViewController
- (void)secretImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@interface QQToastView : UIView
+ (void)showTips:(NSString *)arg1 atRootView:(UIView *)arg2;
@end



BOOL MUIsCallFromQQ() {
    NSArray *address = [NSThread callStackReturnAddresses];
    Dl_info info = {0};
    if(dladdr((void *)[address[2] longLongValue], &info) == 0) return NO;
    NSString *path = [NSString stringWithUTF8String:info.dli_fname];
    if ([path hasPrefix:NSBundle.mainBundle.bundlePath]) {
        if ([path.lastPathComponent isEqualToString:@"plugin.dylib"]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class QQMessageRecallModule; @class QQViewController; @class QQSettingsViewController; @class PreviewSecretPictureViewController; @class NSBundle; 
static NSString * (*_logos_orig$_ungrouped$NSBundle$bundleIdentifier)(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$NSBundle$bundleIdentifier(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$QQMessageRecallModule$recvC2CRecallNotify$bufferLen$subcmd$isOnline$voipNotifyInfo$)(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, const void *, int, int, _Bool, id); static void _logos_method$_ungrouped$QQMessageRecallModule$recvC2CRecallNotify$bufferLen$subcmd$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, const void *, int, int, _Bool, id); static void (*_logos_orig$_ungrouped$QQMessageRecallModule$recvDiscussRecallNotify$bufferLen$isOnline$voipNotifyInfo$)(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, char *, unsigned int, _Bool, id); static void _logos_method$_ungrouped$QQMessageRecallModule$recvDiscussRecallNotify$bufferLen$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, char *, unsigned int, _Bool, id); static void (*_logos_orig$_ungrouped$QQMessageRecallModule$recvGroupRecallNotify$bufferLen$isOnline$voipNotifyInfo$)(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, char *, unsigned int, _Bool, id); static void _logos_method$_ungrouped$QQMessageRecallModule$recvGroupRecallNotify$bufferLen$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST, SEL, char *, unsigned int, _Bool, id); static void (*_logos_orig$_ungrouped$QQViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL QQViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$QQViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL QQViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$QQSettingsViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL QQSettingsViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$QQSettingsViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL QQSettingsViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$QQSettingsViewController$tweakItemTapped$(_LOGOS_SELF_TYPE_NORMAL QQSettingsViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$PreviewSecretPictureViewController$handleDidTakeScreenshot$)(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$PreviewSecretPictureViewController$handleDidTakeScreenshot$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$)(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST, SEL, id, id, _Bool, UIImage *); static void _logos_method$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST, SEL, id, id, _Bool, UIImage *); static void _logos_method$_ungrouped$PreviewSecretPictureViewController$secretImage$didFinishSavingWithError$contextInfo$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST, SEL, UIImage *, NSError *, void *); 

#line 45 "/Users/yuayu/Downloads/BCPULS/plugin/plugin.xm"

static NSString * _logos_method$_ungrouped$NSBundle$bundleIdentifier(_LOGOS_SELF_TYPE_NORMAL NSBundle* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){

    if (MUIsCallFromQQ()) {
    NSString *str =  @"com.tencent.mqq";
    return str;
    }
    return _logos_orig$_ungrouped$NSBundle$bundleIdentifier(self, _cmd);

}




static void _logos_method$_ungrouped$QQMessageRecallModule$recvC2CRecallNotify$bufferLen$subcmd$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, const void * arg1, int arg2, int arg3, _Bool arg4, id arg5) {
    return;
}


static void _logos_method$_ungrouped$QQMessageRecallModule$recvDiscussRecallNotify$bufferLen$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, char * arg1, unsigned int arg2, _Bool arg3, id arg4) {
    return;
}


static void _logos_method$_ungrouped$QQMessageRecallModule$recvGroupRecallNotify$bufferLen$isOnline$voipNotifyInfo$(_LOGOS_SELF_TYPE_NORMAL QQMessageRecallModule* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, char * arg1, unsigned int arg2, _Bool arg3, id arg4) {
    return;
}



static void _logos_method$_ungrouped$QQViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL QQViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    [dic setValue:@"com.tencent.mqq" forKey:@"CFBundleIdentifier"];
    _logos_orig$_ungrouped$QQViewController$viewDidLoad(self, _cmd);
}





static void _logos_method$_ungrouped$QQSettingsViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL QQSettingsViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$_ungrouped$QQSettingsViewController$viewDidLoad(self, _cmd);
    UIBarButtonItem *tweakItem = [[UIBarButtonItem alloc] initWithTitle:@"QQPro II" style:UIBarButtonItemStylePlain target:self action:@selector(tweakItemTapped:)];
    [tweakItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = tweakItem;
}

static void _logos_method$_ungrouped$QQSettingsViewController$tweakItemTapped$(_LOGOS_SELF_TYPE_NORMAL QQSettingsViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id sender) {
UINavigationController *nav = [self valueForKey:@"navigationController"];
XRKSettingsViewController *settingsVC = [[XRKSettingsViewController alloc] init];
[nav pushViewController:settingsVC animated:YES];
}


static void _logos_method$_ungrouped$PreviewSecretPictureViewController$handleDidTakeScreenshot$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg0) {
}
static void _logos_method$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, _Bool arg3, UIImage * arg4) {
    _logos_orig$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$(self, _cmd, arg1, arg2, arg3, arg4);
    if (arg3) {
        if (arg4 != nil)
        {
            id enabledVal = [[NSUserDefaults standardUserDefaults] objectForKey:@"szEnabled"];
            if (!enabledVal) {
                enabledVal = @(YES);
            }
            if (NO == [enabledVal boolValue]) {
                return;
            }
            id s_arg4 = objc_getAssociatedObject(self, _cmd);
            if (s_arg4) {
                return;
            }
            objc_setAssociatedObject(self, _cmd, arg4, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            UIImageWriteToSavedPhotosAlbum(arg4, self, @selector(secretImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


static void _logos_method$_ungrouped$PreviewSecretPictureViewController$secretImage$didFinishSavingWithError$contextInfo$(_LOGOS_SELF_TYPE_NORMAL PreviewSecretPictureViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIImage * image, NSError * error, void * contextInfo) {
    [objc_getClass("QQToastView") showTips:@"闪照已成功保存到相册" atRootView:[[UIApplication sharedApplication] keyWindow]];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$NSBundle = objc_getClass("NSBundle"); { MSHookMessageEx(_logos_class$_ungrouped$NSBundle, @selector(bundleIdentifier), (IMP)&_logos_method$_ungrouped$NSBundle$bundleIdentifier, (IMP*)&_logos_orig$_ungrouped$NSBundle$bundleIdentifier);}Class _logos_class$_ungrouped$QQMessageRecallModule = objc_getClass("QQMessageRecallModule"); { MSHookMessageEx(_logos_class$_ungrouped$QQMessageRecallModule, @selector(recvC2CRecallNotify:bufferLen:subcmd:isOnline:voipNotifyInfo:), (IMP)&_logos_method$_ungrouped$QQMessageRecallModule$recvC2CRecallNotify$bufferLen$subcmd$isOnline$voipNotifyInfo$, (IMP*)&_logos_orig$_ungrouped$QQMessageRecallModule$recvC2CRecallNotify$bufferLen$subcmd$isOnline$voipNotifyInfo$);}{ MSHookMessageEx(_logos_class$_ungrouped$QQMessageRecallModule, @selector(recvDiscussRecallNotify:bufferLen:isOnline:voipNotifyInfo:), (IMP)&_logos_method$_ungrouped$QQMessageRecallModule$recvDiscussRecallNotify$bufferLen$isOnline$voipNotifyInfo$, (IMP*)&_logos_orig$_ungrouped$QQMessageRecallModule$recvDiscussRecallNotify$bufferLen$isOnline$voipNotifyInfo$);}{ MSHookMessageEx(_logos_class$_ungrouped$QQMessageRecallModule, @selector(recvGroupRecallNotify:bufferLen:isOnline:voipNotifyInfo:), (IMP)&_logos_method$_ungrouped$QQMessageRecallModule$recvGroupRecallNotify$bufferLen$isOnline$voipNotifyInfo$, (IMP*)&_logos_orig$_ungrouped$QQMessageRecallModule$recvGroupRecallNotify$bufferLen$isOnline$voipNotifyInfo$);}Class _logos_class$_ungrouped$QQViewController = objc_getClass("QQViewController"); { MSHookMessageEx(_logos_class$_ungrouped$QQViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$QQViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$QQViewController$viewDidLoad);}Class _logos_class$_ungrouped$QQSettingsViewController = objc_getClass("QQSettingsViewController"); { MSHookMessageEx(_logos_class$_ungrouped$QQSettingsViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$QQSettingsViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$QQSettingsViewController$viewDidLoad);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$QQSettingsViewController, @selector(tweakItemTapped:), (IMP)&_logos_method$_ungrouped$QQSettingsViewController$tweakItemTapped$, _typeEncoding); }Class _logos_class$_ungrouped$PreviewSecretPictureViewController = objc_getClass("PreviewSecretPictureViewController"); { MSHookMessageEx(_logos_class$_ungrouped$PreviewSecretPictureViewController, @selector(handleDidTakeScreenshot:), (IMP)&_logos_method$_ungrouped$PreviewSecretPictureViewController$handleDidTakeScreenshot$, (IMP*)&_logos_orig$_ungrouped$PreviewSecretPictureViewController$handleDidTakeScreenshot$);}{ MSHookMessageEx(_logos_class$_ungrouped$PreviewSecretPictureViewController, @selector(downloadImageHandler:imageUrl:isSuccess:downloadImage:), (IMP)&_logos_method$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$, (IMP*)&_logos_orig$_ungrouped$PreviewSecretPictureViewController$downloadImageHandler$imageUrl$isSuccess$downloadImage$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIImage *), strlen(@encode(UIImage *))); i += strlen(@encode(UIImage *)); memcpy(_typeEncoding + i, @encode(NSError *), strlen(@encode(NSError *))); i += strlen(@encode(NSError *)); _typeEncoding[i] = '^'; _typeEncoding[i + 1] = 'v'; i += 2; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$PreviewSecretPictureViewController, @selector(secretImage:didFinishSavingWithError:contextInfo:), (IMP)&_logos_method$_ungrouped$PreviewSecretPictureViewController$secretImage$didFinishSavingWithError$contextInfo$, _typeEncoding); }} }
#line 129 "/Users/yuayu/Downloads/BCPULS/plugin/plugin.xm"
