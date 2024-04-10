#import <Foundation/Foundation.h>

#if !TARGET_OS_WATCH
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
    AFNetworkReachabilityStatusUnknown          = -1,
    AFNetworkReachabilityStatusNotReachable     = 0,
    AFNetworkReachabilityStatusReachableViaWWAN = 1,
    AFNetworkReachabilityStatusReachableViaWiFi = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkReachabilityManager : NSObject

@property (readonly, nonatomic, assign) AFNetworkReachabilityStatus networkReachabilityStatus;

@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (instancetype)__attribute__((optnone))sharedManager;

+ (instancetype)__attribute__((optnone))manager;

+ (instancetype)__attribute__((optnone))managerForDomain:(NSString *)domain;

+ (instancetype)__attribute__((optnone))managerForAddress:(const void *)address;

- (instancetype)__attribute__((optnone))initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)__attribute__((optnone))init NS_UNAVAILABLE;

- (void)__attribute__((optnone))startMonitoring;

- (void)__attribute__((optnone))stopMonitoring;

- (NSString *)__attribute__((optnone))localizedNetworkReachabilityStatusString;

- (void)__attribute__((optnone))setReachabilityStatusChangeBlock:(nullable void (^)(AFNetworkReachabilityStatus status))block;

@end

FOUNDATION_EXPORT NSString * const AFNetworkingReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const AFNetworkingReachabilityNotificationStatusItem;
FOUNDATION_EXPORT NSString * AFStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status);

NS_ASSUME_NONNULL_END
#endif
