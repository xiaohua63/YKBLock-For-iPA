#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>

- (nullable id)__attribute__((optnone))responseObjectForResponse:(nullable NSURLResponse *)response
                           data:(nullable NSData *)data
                          error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

@interface AFHTTPResponseSerializer : NSObject <AFURLResponseSerialization>

- (instancetype)__attribute__((optnone))init;

@property (nonatomic, assign) NSStringEncoding stringEncoding DEPRECATED_MSG_ATTRIBUTE("The string encoding is never used. AFHTTPResponseSerializer only validates status codes and content types but does not try to decode the received data in any way.");

+ (instancetype)__attribute__((optnone))serializer;

@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

- (BOOL)__attribute__((optnone))validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;

@end

#pragma mark -

@interface AFJSONResponseSerializer : AFHTTPResponseSerializer

- (instancetype)__attribute__((optnone))init;

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@property (nonatomic, assign) BOOL removesKeysWithNullValues;

+ (instancetype)__attribute__((optnone))serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end

#pragma mark -

@interface AFXMLParserResponseSerializer : AFHTTPResponseSerializer

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

@interface AFXMLDocumentResponseSerializer : AFHTTPResponseSerializer

- (instancetype)__attribute__((optnone))init;

@property (nonatomic, assign) NSUInteger options;

+ (instancetype)__attribute__((optnone))serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end

#endif

#pragma mark -

@interface AFPropertyListResponseSerializer : AFHTTPResponseSerializer

- (instancetype)__attribute__((optnone))init;

@property (nonatomic, assign) NSPropertyListFormat format;

@property (nonatomic, assign) NSPropertyListReadOptions readOptions;

+ (instancetype)__attribute__((optnone))serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions;

@end

#pragma mark -

@interface AFImageResponseSerializer : AFHTTPResponseSerializer

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
@property (nonatomic, assign) CGFloat imageScale;
@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;
#endif

@end

#pragma mark -

@interface AFCompoundResponseSerializer : AFHTTPResponseSerializer

@property (readonly, nonatomic, copy) NSArray <id<AFURLResponseSerialization>> *responseSerializers;

+ (instancetype)__attribute__((optnone))compoundSerializerWithResponseSerializers:(NSArray <id<AFURLResponseSerialization>> *)responseSerializers;

@end

FOUNDATION_EXPORT NSString * const AFURLResponseSerializationErrorDomain;
FOUNDATION_EXPORT NSString * const AFNetworkingOperationFailingURLResponseErrorKey;
FOUNDATION_EXPORT NSString * const AFNetworkingOperationFailingURLResponseDataErrorKey;

NS_ASSUME_NONNULL_END
