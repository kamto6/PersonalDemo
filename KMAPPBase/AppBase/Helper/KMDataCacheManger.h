//
//  KMDataCacheManger.h
//  KMAppBase
//
//  Created by 揭康伟 on 2019/11/5.
//  Copyright © 2019 kamto. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KMDataCacheManger : NSObject

interfaceSingleton(KMDataCacheManger)

/*!
 * @param key the key
 * @returns Returns a Boolean value that indicates whether a given object is present in the local disk and memory cache pool
 */
- (BOOL)hasObjectInCacheByKey:(NSString*)key;

/*!
 * Returns a Boolean value that indicates whether a given object is present in the local disk and memory cache pool
 * @param key the key
 */
- (id)getCachedObjectByKey:(NSString*)key;

/*!
 * restore all cached objects
 */
- (void)restore;

/*!
 * clear all cached objects in disk and memory
 */
- (void)clearAllCache;

/*!
 * clear all cached objects in disk
 */
- (void)clearAllDiskCache;

/*!
 * clear all memory cached objects
 */
- (void)clearMemoryCache;

/*!
 *    cache object in memory and disk, all cache object will when user exit the app
 *    @param    obj    The object to add to the memory cache pool. This value must not be nil
 *    @param    key The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol).
 *          If aKey already exists in the dictionary anObject takes its place.
 */
- (void)addObject:(NSObject*)obj forKey:(NSString*)key;

/*!
 *    cache object in memory, all cache object will when user exit the app
 *    @param    obj    The object to add to the memory cache pool. This value must not be nil
 *    @param    key The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol).
 *          If aKey already exists in the dictionary anObject takes its place.
 */
- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key;

/*!
 *    remove cached object with specified key
 *    @param    key    The key to remove from the memory cache pool. This value must not be nil, otherwise nothing will happen
 */
- (void)removeObjectInCacheByKey:(NSString*)key;

@end


