//
//  KMDataCacheManger.m
//  KMAppBase
//
//  Created by 揭康伟 on 2019/11/5.
//  Copyright © 2019 kamto. All rights reserved.
//

#import "KMDataCacheManger.h"
#import <CommonCrypto/CommonDigest.h>


@interface KMDataCacheManger ()
{
    NSMutableArray      *_memoryCacheKeys;      // keys for objects only cached in memory
    NSMutableArray      *_keys;                 // keys for keys not managed by queue
    NSMutableDictionary *_memoryCachedObjects;  // objects only cached in memory
    NSOperationQueue    *_cacheInQueue;         // manager cache operation
}
@end

@implementation KMDataCacheManger


implementationSingleton(KMDataCacheManger)

static NSString *const UD_KEY_DATA_CACHE_KEYS = @"UD_KEY_DATA_CACHE_KEYS";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (id)init
{
    self = [super init];
    if(self){
        [self restore];
        [self registerMemoryWarningNotification];
    }
    return self;
}

#pragma mark - private methods
- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemoryCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif
}

//Library/Caches 目录 从服务器下载的需要缓存，iCloud不备份
- (NSString*)getCacheDaoFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE)[0];
    cacheDir = [cacheDir stringByAppendingPathComponent:@"dao"];
    if (![fileManager fileExistsAtPath:cacheDir]) {
        [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return cacheDir;
}
//Documents 目录 用户自行生成的数据文件，苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
- (NSString *)getDocumentFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE)[0];
    if (![fileManager fileExistsAtPath:documentDir]) {
        [fileManager createDirectoryAtPath:documentDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentDir;
}

- (NSString*)getFilePathWithKey:(NSString*)key
{
    NSString *cacheDao = [self getDocumentFilePath];
    NSString *fileName = [self cachedFileNameForKey:key];
    return [cacheDao stringByAppendingPathComponent:fileName];
}

- (id)getObjectWithKey:(NSString*)key
{
    NSString *filePath = [self getFilePathWithKey:key];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    //    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return object;
}

- (BOOL)isValidKey:(NSString*)key
{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (id)archivedObjectWithObject:(id)object
{
    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (void)storeToDisk:(NSDictionary *)dic
{
    @autoreleasepool {
        NSString *key = [dic objectForKey:@"key"];
        NSObject *data = [dic objectForKey:@"data"];
        [self saveObjectWithKey:_keys key:UD_KEY_DATA_CACHE_KEYS];
        [self saveObjectWithKey:data key:key];
    }
}

- (void)addObjectWithKey:(id)object key:(NSString *)key
{
    NSDictionary *saveDataDic = [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", object, @"data", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeToDisk:) object:saveDataDic];
    [_cacheInQueue addOperation:operation];
}

- (void)saveObjectWithKey:(id)object key:(NSString*)key
{
    NSString *filePath = [self getFilePathWithKey:key];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    BOOL result = [data writeToFile:filePath atomically:TRUE];
    if (result) {
        ITTDINFO(@"save successfully!");
    }
}

- (void)removeFileWithKey:(NSString*)key
{
    NSString *filePath = [self getFilePathWithKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
    }
    
}


#pragma mark - public methods
- (void)restore
{
    _cacheInQueue = [[NSOperationQueue alloc] init];
    [_cacheInQueue setMaxConcurrentOperationCount:1];
    NSArray *keysArray = [self getObjectWithKey:UD_KEY_DATA_CACHE_KEYS];
    if (keysArray) {
        _keys = [[NSMutableArray alloc] initWithArray:keysArray];
    }
    else{
        _keys = [[NSMutableArray alloc] init];
    }
    _memoryCacheKeys = [[NSMutableArray alloc] init];
    _memoryCachedObjects = [[NSMutableDictionary alloc] init];
}

- (void)doSave
{
    [self saveObjectWithKey:_keys key:UD_KEY_DATA_CACHE_KEYS];
}

- (void)clearAllCache
{
    [self clearMemoryCache];
    [self clearAllDiskCache];
}

- (void)clearMemoryCache
{
    [_memoryCacheKeys removeAllObjects];
    [_memoryCachedObjects removeAllObjects];
}

- (void)clearAllDiskCache
{
    NSArray *allKeys = [NSArray arrayWithArray:_keys];
    [_keys removeAllObjects];
    [self removeFileWithKey:UD_KEY_DATA_CACHE_KEYS];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in allKeys) {
            [self removeFileWithKey:key];
        }
    });
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if (![_keys containsObject:key]) {
        [_keys addObject:key];
    }
    if (![_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys addObject:key];
    }
    [_memoryCachedObjects setObject:obj forKey:key];
    [self addObjectWithKey:obj key:key];
}

- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys removeObject:key];
        [_memoryCachedObjects removeObjectForKey:key];
    }
    [_memoryCacheKeys addObject:key];
    _memoryCachedObjects[key] = obj;
}

- (id)getCachedObjectByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return nil;
    }
    if ([self hasObjectInMemoryByKey:key]) {
        return _memoryCachedObjects[key];
    }
    else {
        NSObject *obj = [self getObjectWithKey:key];
        if (obj) {
            _memoryCachedObjects[key] = obj;
        }
        return obj;
    }
}

- (BOOL)hasObjectInMemoryByKey:(NSString*)key
{
    if ([_memoryCacheKeys containsObject:key]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)hasObjectInCacheByKey:(NSString*)key
{
    if ([self hasObjectInMemoryByKey:key]) {
        return YES;
    }
    if ([_keys containsObject:key]) {
        return YES;
    }
    return NO;
}

- (void)removeObjectInCacheByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    [_keys removeObject:key];
    [_memoryCachedObjects removeObjectForKey:key];
    [self removeFileWithKey:key];
    [self doSave];
}

- (NSString *)cachedFileNameForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma clang diagnostic pop

@end
