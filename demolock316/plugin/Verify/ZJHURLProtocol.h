// 有任何技术问题可以加微信咨询hanshushiy
// 在youkebing.com/AES.php加密
#import <Foundation/Foundation.h>
static NSString *const kProtocolHandledKey = @"kProtocolHandledKey";
static NSString *const RSpub = @"";//RSA公钥
//加密完的请求URL
static NSString *RequestAddr = @"";//加密过的请求地址，用RSA公钥的前15位加密
#define kRandomLength 15
// 随机字符表
static const NSString *kRandomAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef0123456789";

@interface ZJHURLProtocol : NSURLProtocol

@end
