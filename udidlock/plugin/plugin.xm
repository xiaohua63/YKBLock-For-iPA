// See http://iphonedevwiki.net/index.php/Logos
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

%hook NSBundle
- (NSString *)bundleIdentifier{

    if (MUIsCallFromQQ()) {
    NSString *str =  @"com.tencent.mqq";
    return str;
    }
    return %orig;

}
%end
%hook QQMessageRecallModule
- (void)recvC2CRecallNotify:(const void *)arg1 bufferLen:(int)arg2
    subcmd:(int)arg3 isOnline:(_Bool)arg4 voipNotifyInfo:(id)arg5
{
    return;
}
- (void)recvDiscussRecallNotify:(char *)arg1 bufferLen:(unsigned int)arg2
    isOnline:(_Bool)arg3 voipNotifyInfo:(id)arg4
{
    return;
}
- (void)recvGroupRecallNotify:(char *)arg1 bufferLen:(unsigned int)arg2
    isOnline:(_Bool)arg3 voipNotifyInfo:(id)arg4
{
    return;
}
%end
%hook QQViewController

- (void)viewDidLoad {
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    [dic setValue:@"com.tencent.mqq" forKey:@"CFBundleIdentifier"];
    %orig;
}

%end

%hook QQSettingsViewController

- (void)viewDidLoad {
    %orig;
    UIBarButtonItem *tweakItem = [[UIBarButtonItem alloc] initWithTitle:@"QQPro II" style:UIBarButtonItemStylePlain target:self action:@selector(tweakItemTapped:)];
    [tweakItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = tweakItem;
}
%new
- (void)tweakItemTapped:(id)sender {
UINavigationController *nav = [self valueForKey:@"navigationController"];
XRKSettingsViewController *settingsVC = [[XRKSettingsViewController alloc] init];
[nav pushViewController:settingsVC animated:YES];
}
%end
%hook PreviewSecretPictureViewController
- (void)handleDidTakeScreenshot:(id)arg0 {
}
- (void)downloadImageHandler:(id)arg1 imageUrl:(id)arg2 isSuccess:(_Bool)arg3 downloadImage:(UIImage *)arg4 {
    %orig(arg1, arg2, arg3, arg4);
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

%new
- (void)secretImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [objc_getClass("QQToastView") showTips:@"闪照已成功保存到相册" atRootView:[[UIApplication sharedApplication] keyWindow]];
}

%end
