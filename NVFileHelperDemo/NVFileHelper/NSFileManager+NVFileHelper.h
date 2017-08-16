//
//  NSFileManager+NVFileHelper.h
//  NVFileHelperDemo
//
//  Created by Jackey on 2017/5/31.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//
//  需要引入libz.tdb, 以免编译不过

#import <Foundation/Foundation.h>

@interface NSFileManager (NVFileHelper)

/**
 基地址
 */
@property (nonatomic, strong) NSString *baseDirect;

/**
 创建单例

 @return 单例
 */
+ (instancetype)nv_shareInstance;

/**
 设置基地址

 @param baseDirect 基地址
 */
- (void)nv_setBaseDirectory:(NSString *)baseDirect;

/**
 获取基地址

 @return 基地址
 */
- (NSString *)nv_getBaseDirectory;

/**
 拼接文件地址, 只创建文件夹, 不创建文件

 @param subDirect 子文件夹(相对于基地址, 开头不用/)
 @param name 文件名称
 @return 文件地址
 */
- (NSString *)nv_getPathWithSubDirect:(NSString *)subDirect fileName:(NSString *)name;

/**
 拼接文件地址, 创建文件夹, 创建文件

 @param subDirect 子文件夹(相对于基地址, 开头不用/)
 @param name 文件名称
 @return 文件地址
 */
- (NSString *)nv_createFileWithSubDirect:(NSString *)subDirect fileName:(NSString *)name;

/**
 拷贝文件

 @param sourceFile 原始文件地址
 @param destFile 目的文件地址
 @return 拷贝结果BOOL值
 */
- (BOOL)nv_copyFile:(NSString *)sourceFile toFile:(NSString *)destFile;

/**
 移动文件

 @param sourceFile 原始文件地址
 @param destFile 目的文件地址
 @return 移动结果BOOL值
 */
- (BOOL)nv_moveFile:(NSString *)sourceFile toFile:(NSString *)destFile;

/**
 删除文件

 @param file 要删除的文件地址
 @return 删除结果BOOL值
 */
- (BOOL)nv_deleteFile:(NSString *)file;

/**
 创建子文件夹(基于基地址)

 @param subDirectory 子文件夹名称(多层目录用/拼接, 第一个/不用)
 @return 创建结果BOOL值
 */
- (BOOL)nv_createSubDirectory:(NSString *)subDirectory;

/**
 创建文件夹

 @param directory 文件夹路径全部字段
 @return 创建结果的BOOL值
 */
- (BOOL)nv_createDirectory:(NSString *)directory;

/**
 创建文件

 @param file 文件地址
 @return 创建结果的BOOl值
 */
- (BOOL)nv_createFile:(NSString *)file;

/**
 解压文件到子路径

 @param zipFile 压缩文件目录
 @param subDirectory 子路径(基于基地址)
 @param overwrite 是否覆盖
 @return 解压缩结果的BOOl值
 */
- (BOOL)nv_unZipFile:(NSString *)zipFile toSubDirectory:(NSString *)subDirectory overwrite:(BOOL)overwrite;

/**
 解压文件到指定路径(全部字符)

 @param zipFile 压缩文件目录
 @param directory 目的存放路径全部字符
 @param overwrite 是否覆盖
 @return 解压缩结果的BOOL值
 */
- (BOOL)nv_unzipFile:(NSString *)zipFile toDirectory:(NSString *)directory overwrite:(BOOL)overwrite;

/**
 将数个文件打包压缩为一个文件

 @param paths 要压缩的文件路径列表
 @param path 文件压缩后存放的地址
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFilesOfPaths:(NSArray *)paths toPath:(NSString *)path;

/**
 将文件件压缩为一个文件

 @param direct 需要压缩的文件夹地址
 @param path 文件夹压缩完成后存在的地址
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFileOfDirectory:(NSString *)direct toPath:(NSString *)path;

/**
 将文件夹压缩为一个文件, 可选择是否保留原始文件夹目录

 @param direct 需要压缩的文件夹地址
 @param path 文件夹压缩完成后存放的地址
 @param keepParentDirectory 是否保留原始文件夹目录
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFileOfDirectory:(NSString *)direct toPath:(NSString *)path keepParentDirectory:(BOOL)keepParentDirectory;

/**
 文件夹是否存在

 @param directory 文件夹全部字段
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isDirectoryExist:(NSString *)directory;

/**
 子文件夹是否存在

 @param subDirectory 子文件夹名称(基于基地址)
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isSubDirectoryExist:(NSString *)subDirectory;

/**
 文件是否存在

 @param file 文件的地址全部字段
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isFileExist:(NSString *)file;

@end
