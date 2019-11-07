//
//  KMFileHelper.m
//  KMAppBase
//
//  Created by 揭康伟 on 2017/10/29.
//  Copyright © 2017 kamto. All rights reserved.
//
/*
 一个应用只能直接访问本应用分配的文件目录，不可以访问其他目录，每个应用自己独立的访问空间被称为该应用的沙盒。
 1. Bundle Container
 
 MyApp.app ：这就是应用的运行包（bundle），
 bundle路径就是通常所说的应用程序在手机里面的安装路径，其就是一个目录，这个目录就是main bundle。这个目录里面通常包含图像、媒体资源、编译好的代码、nib、文件等可执行文件和所有资源文件，这个目录是只读的。
 
 2. Data Container
 可分为三个部分，Documents、Library、tmp。
 
 2.1 Document
 
 保存由用户产生的文件或者数据,苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录,该文件夹下的内容不会被系统自动删除，例如：例如一个日记应用中用户写的日记文件，或者音乐播放器中用户下载的歌曲。
 
 2.2.1 Library/Caches
 
 用来存放缓存文件，保存从网络下载的请求数据，后续仍然需要继续使用的文件，例如网络下载的离线数据，图片，视频文件等。该目录中的文件系统不会自动删除，可以做离线访问。它的存放时间比 tmp 下的长，但是不如 Library 下的其它目录。总的来说 Caches 目录下存放的数据不能是应用程序运行所必需的，但是能提高应用访问性能的。可写入应用支持文件，保存应用程序再次启动需要的信息。iCloud不备份。
 
 2.2.2 Library/Preferences
 
 常用来放置配置文件、数据文件、模板等应用在运行中与用户相关，而又希望对用户不可见的文件，如系统偏好设置，用户偏好设置等文件。使用 NSUserDefaults 类进行偏好设置文件的创建、读取和修改。
 
 2.3 temp
 
 保存应用运行时产生的一些临时数据,应用程序退出，系统磁盘空间不够,手机重启时,都会自动清除该目录的数据。无需程序员手动清除该目录中的数据.iTunes、iCloud备份时,不会备份此目录
 */

#import "KMFileHelper.h"

@implementation KMFileHelper

/**
 *  @Author 2015-01-29 12:01:07
 *  获取手机的文档document目录路径
 *
 *  @return 手机的文档document目录路径
 */
+(NSString *)documentFolder
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,TRUE).firstObject;
}

/**
 *  @Author 2015-01-29 12:01:07
 *  获取手机应用包的目录路径
 *
 *  @return 手机应用包的目录路径
 */
+(NSString *)bundleFolder
{
    return [NSBundle mainBundle].bundlePath;
}

/**
 *  @Author 2015-01-29 12:01:26
 *
 *  获取应用的根目录路径
 *
 *  @return 应用的根目录路径
 */
+(NSString *)homeFolder
{
    return NSHomeDirectory();
}

/**
 *  @Author 2015-01-29 12:01:57
 *
 *  获取应用Library目录路径
 *
 *  @return 应用Library目录路径
 */
+(NSString *)libFolder
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,TRUE).firstObject;
}

/**
 *  @Author 2015-01-29 12:01:35
 *
 *  获取应用缓存的目录路径
 *
 *  @return 应用缓存的目录路径
 */
+(NSString *)cacheFolder
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,TRUE).firstObject;
}

/**
 *  @Author 2015-01-29 12:01:07
 *
 *  获取应用的临时目录路径
 *
 *  @return 应用的临时目录路径
 */
+(NSString *)tempFolder
{
    return NSTemporaryDirectory();
}

/**
 *  @Author 2014-11-27 14:11:03
 *  写内容到document目录
 *
 *  @param content  内容
 *  @param filePath 文件路径，如果该文件路径有内容，会z新增到原内容上
 */
+(BOOL)writeFileToDocument:(NSString *)content inPath:(NSString *)filePath
{
    if (content == nil) return NO;
    NSString *documentPath = [self documentFolder];
    if ([filePath rangeOfString:documentPath].location != NSNotFound) {}
    else{
        filePath = [documentPath stringByAppendingPathComponent:filePath];
    }
    NSError *error;
    return [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

/**
 *  @Author ,2014-11-27 14:11:03
 *
 *  读取系统xml配置文件（分为两层,catalog,item）
 *
 *  @param path 文件路径
 *
 *  @return 数据字典
 */
+(NSDictionary *)readSystemConfigXml:(NSString *)path
{
    return @{};
}


/**
 *
 *  删除文件或者目录
 *
 *  @param filePath 文件路径
 *
 *  @return 成功标志
 */
+(BOOL)removeFile:(NSString *)filePath
{
    BOOL isFileExit = [self isFileExists:filePath];
    if (isFileExit) {
        NSFileManager *manger = [NSFileManager defaultManager];
        NSError *error;
        return [manger removeItemAtPath:filePath error:&error];
    }else{
        return NO;
    }
}

/**
 *  创建文件或目录
 *
 *  @param filePath       文件路径
 *  @param isDirectory    是否是目录
 *  @return 成功标志
 */
+(BOOL)createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory;
{
    BOOL isExit = [self isFileExists:filePath];
    if (!isExit) {
        NSFileManager *manger = [NSFileManager defaultManager];
        if (isDirectory) {
            NSError *error;
            return [manger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        }else{
            return [manger createFileAtPath:filePath contents:nil attributes:nil];
        }
    }else{
        return NO;
    }
    
}

/**
 *
 *  移动文件
 *
 *  @param srcPath  原始文件
 *  @param destPath 目标文件，当原始文件为文件路径，目标文件为文件路径，那么原始文件会消失，目标文件内容和原始文件一样；目标文件为文件夹路径，那么原始文件会消失，目标文件夹会变成文件且内容和原始文件一样
 *
 *  @return 成功标志
 */
+(BOOL)moveFile:(NSString *)srcPath to:(NSString *)destPath
{
    BOOL isSrcFileExit  = [self isFileExists:srcPath];
    BOOL isDestFileExit = [self isFileExists:destPath];
    if (isSrcFileExit && isDestFileExit) {
        NSError *error;
        NSFileManager *manger = [NSFileManager defaultManager];
        return [manger moveItemAtPath:srcPath toPath:destPath error:&error];
        
    }else{
        return NO;
    }
}

/**
 *
 *  复制文件
 *
 *  @param srcPath  原始文件
 *  @param destPath 目标文件，当原始文件为文件路径，目标为文件夹目录，那么该文件夹会变成文件，内容和原始文件一样
 *
 *  @return 成功标志
 */
+(BOOL)copyFile:(NSString *)srcPath to:(NSString *)destPath
{
    BOOL isSrcFileExit  = [self isFileExists:srcPath];
    BOOL isDestFileExit = [self isFileExists:destPath];
    if (isSrcFileExit && isDestFileExit) {
        NSError *error;
        NSFileManager *manger = [NSFileManager defaultManager];
        return [manger copyItemAtPath:srcPath toPath:destPath error:&error];
        
    }else{
        return NO;
    }
}

/**
 *  @Author 2015-01-30 10:01:21
 *
 *  写数据到文件中
 *
 *  @param content  内容
 *  @param filePath 路径
 *
 *  @return 成功标志
 */
+(BOOL)writeContent:(NSObject *)content inFilePath:(NSString *)filePath
{
    if (content == nil) return NO;
    BOOL isFileExit = [self isFileExists:filePath];
    if (!isFileExit) {
        if ([self createFile:filePath isDirectory:NO]) {
            isFileExit = YES;
        }else{
            isFileExit = NO;
        }
    }
    if (isFileExit) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:content];
        return [data writeToFile:filePath atomically:TRUE];
 #pragma clang diagnostic pop
    }else
    {
        return NO;
    }
    
}

/**
 *  @Author 2015-01-30 10:01:03
 *
 *  读取文件的内容
 *
 *  @param filePath 文件路径
 *
 *  @return 内容
 */
+(NSObject *)readContentOfFilePath:(NSString *)filePath
{
    BOOL isFileExit = [self isFileExists:filePath];
    if (isFileExit) {
        NSError *error;
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        return [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&error];
    }else
    {
        return nil;
    }
}

/**
 *  @Author 2015-02-04 10:02:40
 *
 *  判断文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return 存在标识
 */
+(BOOL)isFileExists:(NSString *)filePath
{
    if (filePath == nil) return NO;
    NSFileManager *manger = [NSFileManager defaultManager];
    return [manger fileExistsAtPath:filePath];
}

/**
 *  @Author 2015-02-04 10:02:18
 *
 *  获取目录下面的子目录
 *
 *  @param filePath 目录路径
 *
 *  @return 子文件数组
 */
+(NSArray *)listFiles:(NSString *)filePath
{
    BOOL isFileDirectorExit = [self isDirectory:filePath];
    if (isFileDirectorExit) {
        NSError *error;
        NSFileManager *manger = [NSFileManager defaultManager];
        return [manger contentsOfDirectoryAtPath:filePath error:&error];
    }else {
        return nil;
    }
}

/**
 *  @Author 2015-02-04 14:02:16
 *
 *  判断是否是目录
 *
 *  @param filePath 文件路径
 *
 *  @return 是否是目录
 */
+(BOOL)isDirectory:(NSString *)filePath
{
    if (filePath == nil) return NO;
    NSFileManager *manger = [NSFileManager defaultManager];
    BOOL isDirectory;
    if ([manger fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        return isDirectory;
    }else{
        return NO;
    }
}

/**
 *  @Author 2017-04-23 14:04:31
 *
 *  获取文件大小
 *
 *  @param filePath    文件目录的路径
 *  @param decimal     小数点位数
 *
 *  @return 大小
 */
+(NSString *)getFileSize:(NSString *)filePath decimal:(NSInteger)decimal
{
    double fileSize = [self getFileSize:filePath];
    if (fileSize > 0)
    {
        float fileSizeResult = round(fileSize * pow(10, decimal))/pow(10, decimal);
        return [NSString stringWithFormat:@"%@",@(fileSizeResult)];
    }else
    {
        return 0;
    }
}

/**
 *  @author 2017-03-25 21:03:19
 *
 *  获取文件大小
 *
 *  @param filePath    文件目录的路径
 *
 *  @return 大小M
 */
+(double)getFileSize:(NSString *)filePath
{
    BOOL isFileExit = [self isFileExists:filePath];
    if (!isFileExit) return 0;
    unsigned long long folderSize = 0;
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    //是否是文件夹
    if ([manager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
       if (isDirectory) {
        //获取所有子文件名
        NSArray *subPathArr = [manager subpathsAtPath:filePath];
        //遍历
        for (NSString * subPath in subPathArr) {
            //排除隐藏文件.DS_Store
            if ([subPath hasPrefix:@"."]) {
                continue;
            }
            //拼接路径
            NSString *path =[filePath stringByAppendingPathComponent:subPath];
            if ([manager fileExistsAtPath:path isDirectory:&isDirectory]) {
                if (isDirectory) {
                    //如果里面还是文件夹的 递归本方法
                    [self getFileSize:path];
                }else{
                    //如果不是 获取文件属性 其中 NSFileSize 是获取文件大小
                    NSDictionary *dic = [manager attributesOfItemAtPath:path error:nil];
                    if (dic) {
                        folderSize += [dic[@"NSFileSize"] unsignedLongLongValue];
                    }
                }
            }
        }
                
    }else{
        NSDictionary *dic = [manager attributesOfItemAtPath:filePath error:nil];
        if (dic) {
            folderSize += [dic[@"NSFileSize"] unsignedLongLongValue];
        }
            
      }
    }
    //mac除以1000，win是除以1024
    return (float)folderSize/(1000*1000);
}

/**
 *  @author 2017-03-25 21:03:19
 *
 *  为文件设置修改时间
 *
 *  @param filePath    文件目录的路径
 *
 *  @return 成本标志
 */
+(BOOL)setModificationDateinFile:(NSString *)filePath
{
    BOOL isFileExit = [self isFileExists:filePath];
    if (!isFileExit) return NO;
    NSDictionary *modificationDateDict = [NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate];
    return [[NSFileManager defaultManager] setAttributes:modificationDateDict ofItemAtPath:filePath error:nil];
}

/**
 *  @Author 2015-07-09 01:07:09
 *
 *  获取指定目录下面的文件路径，递归查找
 *
 *  @param name              文件名
 *  @param folder            目录名
 *
 *  @return 返回该文件bundle路径
 */
+(NSString *)getBundleFilePathByName:(NSString *)name inFolder:(NSString *)folder
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil inDirectory:folder];
    if (filePath == nil) {
        NSArray *bundles = [self getBundleFiles];
        for (NSString *path in bundles) {
            filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",folder,name]];
            if ([NSData dataWithContentsOfFile:filePath]) {
                break;
            }
        }
    }
    return filePath;
}

/**
 *  @Author 2015-07-09 01:07:09
 *
 *  获取bundle包目录下面的文件路径，递归查找
 *
 *  @param name           文件名,带后缀
 *
 *  @return 返回该文件bundle路径
 */
+(NSString *)getBundleFilePathByName:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (filePath == nil) {
        NSArray *bundles = [self getBundleFiles];
        for (NSString *path in bundles) {
            filePath = [path stringByAppendingPathComponent:name];
            if ([NSData dataWithContentsOfFile:filePath]) {
                break;
            }
        }
    }
    return filePath;
}

/**
 *  @Author 2015-07-09 01:07:09
 *
 *  @return 获取安装目录下面的所有bundle包路径
 */
+(NSArray *)getBundleFiles
{
    NSArray *allBundles = [NSBundle allBundles];
    NSMutableArray *bundleFiles = [NSMutableArray array];
    for (NSBundle *bundle in allBundles) {
        NSString *path = bundle.bundleURL.relativePath;
        if (path && path.length) {
            [bundleFiles addObject:path];
        }
    }
    return bundleFiles;
}


@end
