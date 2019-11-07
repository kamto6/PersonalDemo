//
//  KMFileHelper.h
//  KMAppBase
//
//  Created by 揭康伟 on 2017/10/29.
//  Copyright © 2017 kamto. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件帮助类
 */

@interface KMFileHelper : NSObject


/**
 *  @Author 2015-01-29 12:01:07
 *  获取手机的文档document目录路径
 *
 *  @return 手机的文档document目录路径
 */
+(NSString *)documentFolder;
/**
 *  @Author 2015-01-29 12:01:07
 *  获取手机应用包的目录路径
 *
 *  @return 手机应用包的目录路径
 */
+(NSString *)bundleFolder;

/**
 *  @Author 2015-01-29 12:01:26
 *
 *  获取应用的根目录路径
 *
 *  @return 应用的根目录路径
 */
+(NSString *)homeFolder;

/**
 *  @Author 2015-01-29 12:01:57
 *
 *  获取应用Library目录路径
 *
 *  @return 应用Library目录路径
 */
+(NSString *)libFolder;
/**
 *  @Author 2015-01-29 12:01:35
 *
 *  获取应用缓存的目录路径
 *
 *  @return 应用缓存的目录路径
 */
+(NSString *)cacheFolder;

/**
 *  @Author 2015-01-29 12:01:07
 *
 *  获取应用的临时目录路径
 *
 *  @return 应用的临时目录路径
 */
+(NSString *)tempFolder;

/**
 *  @Author 2014-11-27 14:11:03
 *  写内容到document目录
 *
 *  @param content  内容
 *  @param filePath 文件路径，如果该文件路径有内容，会z新增到原内容上
 */
+(BOOL)writeFileToDocument:(NSString *)content inPath:(NSString *)filePath;

/**
 *  @Author ,2014-11-27 14:11:03
 *
 *  读取系统xml配置文件（分为两层,catalog,item）
 *
 *  @param path 文件路径
 *
 *  @return 数据字典
 */
+(NSDictionary *)readSystemConfigXml:(NSString *)path;


/**
 *
 *  删除文件或者目录
 *
 *  @param filePath 文件路径
 *
 *  @return 成功标志
 */
+(BOOL)removeFile:(NSString *)filePath;

/**
 *  创建文件或目录
 *
 *  @param filePath       文件路径
 *  @param isDirectory    是否是目录
 *  @return 成功标志
 */
+(BOOL)createFile:(NSString *)filePath isDirectory:(BOOL)isDirectory;

/**
 *
 *  移动文件
 *
 *  @param srcPath  原始文件
 *  @param destPath 目标文件，当原始文件为文件路径，目标文件为文件路径，那么原始文件会消失，目标文件内容和原始文件一样；目标文件为文件夹路径，那么原始文件会消失，目标文件夹会变成文件且内容和原始文件一样
 *
 *  @return 成功标志
 */
+(BOOL)moveFile:(NSString *)srcPath to:(NSString *)destPath;

/**
 *
 *  复制文件
 *
 *  @param srcPath  原始文件
 *  @param destPath 目标文件，当原始文件为文件路径，目标为文件夹目录，那么该文件夹会变成文件，内容和原始文件一样
 *
 *  @return 成功标志
 */
+(BOOL)copyFile:(NSString *)srcPath to:(NSString *)destPath;

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
+(BOOL)writeContent:(NSObject *)content inFilePath:(NSString *)filePath;

/**
 *  @Author 2015-01-30 10:01:03
 *
 *  读取文件的内容
 *
 *  @param filePath 文件路径
 *
 *  @return 内容
 */
+(NSObject *)readContentOfFilePath:(NSString *)filePath;

/**
 *  @Author 2015-02-04 10:02:40
 *
 *  判断文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return 存在标识
 */
+(BOOL)isFileExists:(NSString *)filePath;

/**
 *  @Author 2015-02-04 10:02:18
 *
 *  获取目录下面的子目录
 *
 *  @param filePath 目录路径
 *
 *  @return 子文件数组
 */
+(NSArray *)listFiles:(NSString *)filePath;

/**
 *  @Author 2015-02-04 14:02:16
 *
 *  判断是否是目录
 *
 *  @param filePath 文件路径
 *
 *  @return 是否是目录
 */
+(BOOL)isDirectory:(NSString *)filePath;

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
+(NSString *)getFileSize:(NSString *)filePath decimal:(NSInteger)decimal;

/**
 *  @author 2017-03-25 21:03:19
 *
 *  获取文件大小
 *
 *  @param filePath    文件目录的路径
 *
 *  @return 大小M
 */
+(double)getFileSize:(NSString *)filePath;


/**
 *  @author 2017-03-25 21:03:19
 *
 *  为文件设置修改时间
 *
 *  @param filePath    文件目录的路径
 *
 *  @return 成本标志
 */
+(BOOL)setModificationDateinFile:(NSString *)filePath;

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
+(NSString *)getBundleFilePathByName:(NSString *)name inFolder:(NSString *)folder;


/**
 *  @Author 2015-07-09 01:07:09
 *
 *  获取bundle包目录下面的文件路径，递归查找
 *
 *  @param name           文件名,带后缀
 *
 *  @return 返回该文件bundle路径
 */
+(NSString *)getBundleFilePathByName:(NSString *)name;

/**
 *  @Author 2015-07-09 01:07:09
 *
 *  @return 获取安装目录下面的所有bundle包路径
 */
+(NSArray *)getBundleFiles;


@end

