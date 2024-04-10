#import "ZJHSessionConfiguration.h"
#import "ZJHURLProtocol.h"
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "SCLAlertView.h"
#import "LRKeychain.h"
#import "AESCrypt.h"
#import "RSA.h"
static NSString *Errortxt = @"";
static NSString *yzmcode = @"";
@interface ZJHURLProtocol () <NSURLConnectionDelegate,NSURLConnectionDataDelegate, NSURLSessionDelegate>


@end

@implementation ZJHURLProtocol

#pragma mark - Public
+(NSString*)getIDFA
{
    if(![LRKeychain getKeychainDataForKey:@"DeviceId"])
    {
        NSMutableString * deviceID= [NSMutableString stringWithCapacity:15];
        for (int i = 0; i < 15; i++) {
            [deviceID appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
        }
        [LRKeychain addKeychainData:deviceID forKey:@"DeviceId"];
        return deviceID;
    }
    else{
        NSString *deviceID = [LRKeychain getKeychainDataForKey:@"DeviceId"];
        return deviceID;
    }
}
//检测网络状态
+(void)kaishijihuobuzhou{
    NSString *urlStr = @"http://@@@@@@@@@@@@@@@@@@/";
    NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newUrlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString* result1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (result1)
    {
        [self showAlertMsg:@"激活成功"];
    }else {
        [self showAlertMsg:@"请检查网络状态"];
    }

}
+ (void)showAlertMsg:(NSString *)show
{
SCLAlertView *alert =  [[SCLAlertView alloc] initWithNewWindow];
 [alert showInfo:show subTitle:@"信息" closeButtonTitle:@"确定" duration:2];
}
+(void)AlertWithSuccess:(NSDictionary*)dics{
    //验证成功的弹窗
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Errortxt"];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    NSString *sub = [NSString stringWithFormat:@"-卡密是售后唯一凭证请妥善保存-\n\n到期时间：%@", [dics objectForKey:@"expired"]];
    [alert showSuccess:@"激活成功！" subTitle:sub closeButtonTitle:@"好的" duration:0.0f];
    
}
//开始运行请求
+ (void)processActivate
{
    SCLAlertView *alert =  [[SCLAlertView alloc] initWithNewWindow];
    alert.shouldDismissOnTapOutside = NO;
    __block SCLTextView *textF =   [alert addTextField:@"请输入你的激活码" setDefaultText:nil];
    [alert addButton:@"点击粘贴" validationBlock:^BOOL{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        textF.text =pasteboard.string;
        return NO;
    }actionBlock:^{}];
    [alert alertDismissAnimationIsCompleted:^{
        if (textF.text.length==0) {
            [self processActivate];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *dics = [self RequestStart:textF.text];
            if ([[dics objectForKey:@"s"]isEqualToString:@"200"]) {
                    [LRKeychain addKeychainData:textF.text forKey:@"UserCode"];
                [self AlertWithSuccess:dics];
            }
            else if ([[dics objectForKey:@"s"]isEqualToString:@"0"]){
                Errortxt = [dics objectForKey:@"expired"];
                [[NSUserDefaults standardUserDefaults] setValue:Errortxt forKey:@"Errortxt"];
                [self load];
            }
            else{
                exit(0);
            }
            });
        }
    }];
    [alert showInfo:@"请输入激活码" subTitle:Errortxt closeButtonTitle:@"点击验证" duration:0.0f];
}
+(void)DicRead:(NSDictionary *)dics{
    if ([[dics objectForKey:@"ex"]isEqualToString:@"cgurl"]) {
        NSString *Encode = [AESCrypt encrypt:[dics objectForKey:@"exdata"] password:[RSpub substringToIndex:kRandomLength]];
        if (![Encode isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"OPEN_API_SDK"]]) {
            [[NSUserDefaults standardUserDefaults] setValue:Encode forKey:@"OPEN_API_SDK"];
        }
        else{
        }
    }
}
//网络请求
+(id)RequestStart:(NSString *)yzmcode{
    NSDictionary *dics = NULL;
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
        
    }
    NSDictionary *reqdict=@{
                            @"code":yzmcode,
                            @"mac":[self getIDFA],
                            @"en":randomString
                            };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqdict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonenc = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *en = [RSA encryptString:jsonenc publicKey:RSpub];
    NSString *AllUrl = [[AESCrypt decrypt:RequestAddr password:[RSpub substringToIndex:kRandomLength]] stringByAppendingString:[NSString stringWithFormat:@"?token=%@",en]];
    NSURL *url = [NSURL URLWithString:AllUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:(8)];
        NSHTTPURLResponse *resss = nil;
        NSError *errr = nil;
        NSData *dataa = [NSURLConnection sendSynchronousRequest:request returningResponse:&resss error:&errr];
    if (errr) {
        dics = @{
                   @"s":@"0",
                   @"expired":@"请检查网络连接,或查看系统设置中App是否已经打开联网权限"
                };
        return dics;
    }
        NSString *decstr = [AESCrypt decrypt:([[NSString alloc] initWithData:dataa encoding:NSUTF8StringEncoding]) password:(randomString)];
        dics = [NSJSONSerialization JSONObjectWithData:[decstr dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    if (!dics) {
        exit(0);
    }
    return dics;

}
+ (void)load {
    Errortxt = [[NSUserDefaults standardUserDefaults] valueForKey:@"Errortxt"];[start GetMainProgress];
    if(![LRKeychain getKeychainDataForKey:@"UserCode"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self processActivate];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          NSString *yzmcode = [LRKeychain getKeychainDataForKey:@"UserCode"];
          NSDictionary *dics = [self RequestStart:yzmcode];
          if ([[dics objectForKey:@"s"]isEqualToString:@"200"]) {
              //显示公告
              if (![[dics objectForKey:@"a"]isEqualToString:@""] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"alertv"]isEqualToString:[dics objectForKey:@"a"]]) {
                      [[NSUserDefaults standardUserDefaults] setObject:[dics objectForKey:@"a"] forKey:@"alertv"];
                      SCLAlertView *alert =  [[SCLAlertView alloc] initWithNewWindow];
                       [alert showInfo:@"公告" subTitle:[dics objectForKey:@"a"] closeButtonTitle:@"不再显示" duration:0.0f];
              }
        }
          else if ([[dics objectForKey:@"s"]isEqualToString:@"0"]){
              Errortxt = [dics objectForKey:@"expired"];
              [[NSUserDefaults standardUserDefaults] setValue:Errortxt forKey:@"Errortxt"];
              [LRKeychain deleteKeychainDataForKey:@"UserCode"];
              [self load];
          }
          else{
            exit(0);
        }
        });
    }
}
@end


