//
//  NSFileManager+NVFileHelper.m
//  NVFileHelperDemo
//
//  Created by Jackey on 2017/5/31.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "NSFileManager+NVFileHelper.h"
#import <objc/runtime.h>
#import "SSZipArchive.h"

static char baseDirectKey;

@implementation NSFileManager (NVFileHelper)

/**
 创建单例
 
 @return 单例
 */
+ (instancetype)nv_shareInstance {
    
    static NSFileManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [NSFileManager nv_shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [NSFileManager nv_shareInstance];
}

/**
 设置基地址
 
 @param baseDirect 基地址
 */
- (void)nv_setBaseDirectory:(NSString *)baseDirect {
    
    objc_setAssociatedObject(self, &baseDirectKey, baseDirect, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/**
 获取基地址
 
 @return 基地址
 */
- (NSString *)nv_getBaseDirectory {
    
    if (objc_getAssociatedObject(self, &baseDirectKey)) {
        
        return objc_getAssociatedObject(self, &baseDirectKey);
    } else {
        
        return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
}

/**
 拼接文件地址, 只创建文件夹, 不创建文件
 
 @param subDirect 子文件夹(相对于基地址, 开头不用/)
 @param name 文件名称
 @return 文件地址
 */
- (NSString *)nv_getPathWithSubDirect:(NSString *)subDirect fileName:(NSString *)name {
    
    if (subDirect && name) {
        
        NSString *basedirect = [self nv_getBaseDirectory];
        //检查子目录是否存在, 不存在则创建子目录
        
        if (![self nv_isSubDirectoryExist:subDirect]) {
            
            [self nv_createSubDirectory:subDirect];
        }
        return [[basedirect stringByAppendingPathComponent:subDirect] stringByAppendingPathComponent:name];
    }
    
    return @"";
}

/**
 拼接文件地址, 创建文件夹, 创建文件
 
 @param subDirect 子文件夹(相对于基地址, 开头不用/)
 @param name 文件名称
 @return 文件地址
 */
- (NSString *)nv_createFileWithSubDirect:(NSString *)subDirect fileName:(NSString *)name {
    
    if (subDirect && name) {
        
        NSString *basedirect = [self nv_getBaseDirectory];
        //检查子目录是否存在, 不存在则创建子目录
        
        if (![self nv_isSubDirectoryExist:subDirect]) {
            
            [self nv_createSubDirectory:subDirect];
        }
        
        
        NSString *str = [[basedirect stringByAppendingPathComponent:subDirect] stringByAppendingPathComponent:name];
        
        if ([self nv_createFile:str]) {
            
            return str;
        } else {
            
            return @"";
        }
    }
    
    return @"";
}

/**
 拷贝文件
 
 @param sourceFile 原始文件地址
 @param destFile 目的文件地址
 @return 拷贝结果BOOL值
 */
- (BOOL)nv_copyFile:(NSString *)sourceFile toFile:(NSString *)destFile {
    
    if (sourceFile && destFile) {
        
        //检查source文件是否存在

        if ([self nv_isFileExist:sourceFile]) {
            
            //检查destFile文件夹路径是否存在

            NSString *destDirect = [destFile stringByDeletingLastPathComponent];
            if (![self nv_isDirectoryExist:destDirect]) {
                
                [self nv_createDirectory:destDirect];
            }
            NSError *error;
            [self copyItemAtPath:sourceFile toPath:destFile error:&error];
            if (error) {
                
                return false;
            } else {
                
                return true;
            }

        } else {
            
            return false;
        }
    }

    return false;
}

/**
 移动文件
 
 @param sourceFile 原始文件地址
 @param destFile 目的文件地址
 @return 移动结果BOOL值
 */
- (BOOL)nv_moveFile:(NSString *)sourceFile toFile:(NSString *)destFile {
    
    if (sourceFile && destFile) {
        
        //检查source文件是否存在

        if ([self nv_isFileExist:sourceFile]) {
            
            //检查dest路径文件夹是否存在
            NSString *destDirect = [destFile stringByDeletingLastPathComponent];
            if (![self nv_isDirectoryExist:destDirect]) {
                
                //路径不存在则创建路径
                [self nv_createDirectory:destDirect];
            }
            NSError *error;
            [self moveItemAtPath:sourceFile toPath:destFile error:&error];
            if (error) {
                
                return false;
            } else {
                
                return true;
            }
        } else {
            
            return false;
        }
        
    }
    return false;
}

/**
 删除文件
 
 @param file 要删除的文件地址
 @return 删除结果BOOL值
 */
- (BOOL)nv_deleteFile:(NSString *)file {
    
    if (file) {
        
        //检查文件是否存在

        if ([self nv_isFileExist:file]) {
            
            NSError *error;
            [self removeItemAtPath:file error:&error];
            if (error) {
                
                return false;
            } else {
                
                return true;
            }
        } else {
            
            return false;
        }
        
    }
    return false;
}

/**
 创建子文件夹(基于基地址)
 
 @param subDirectory 子文件夹名称(多层目录用/拼接, 第一个/不用)
 @return 创建结果BOOL值
 */
- (BOOL)nv_createSubDirectory:(NSString *)subDirectory {
    
    if (subDirectory) {
        
        //检查目录是否已经存在

        if (![self nv_isSubDirectoryExist:subDirectory]) {
            
            NSString *base = [self nv_getBaseDirectory];
            NSError *error;
            BOOL isDirect = true;
            [self createDirectoryAtPath:[base stringByAppendingPathComponent:subDirectory] withIntermediateDirectories:isDirect attributes:nil error:&error];
            if (error) {
                
                return false;
            } else {
                
                return true;
            }

        } else {
            
            return true;
        }
    }
    return false;
}

/**
 创建文件夹
 
 @param directory 文件夹路径全部字段
 @return 创建结果的BOOL值
 */
- (BOOL)nv_createDirectory:(NSString *)directory {
    
    if (directory) {
        
        //检查目录是否已经存在
        
        if (![self nv_isDirectoryExist:directory]) {
            
            NSError *error;
            BOOL isDirect = true;
            [self createDirectoryAtPath:directory withIntermediateDirectories:isDirect attributes:nil error:&error];
            if (error) {
                
                return false;
            } else {
                
                return true;
            }
            
        } else {
            
            return true;
        }
    }
    return false;
}

/**
 创建文件
 
 @param file 文件地址
 @return 创建结果的BOOl值
 */
- (BOOL)nv_createFile:(NSString *)file {
    
    if (file) {
        
        if (![self nv_isFileExist:file]) {
            
            //先判断文件夹是否存在
            NSString *dir = [file stringByDeletingLastPathComponent];
            if (![self nv_isDirectoryExist:dir]) {
                
                [self nv_createDirectory:dir];
            }
            
            if ([self createFileAtPath:file contents:nil attributes:nil]) {
                
                
                return true;
                
            } else {

                return false;
            }
        } else {
            
            return true;
        }
    } else {
        
        return false;
    }
}

/**
 解压文件
 
 @param zipFile 压缩文件目录
 @param subDirectory 子路径(基于基地址)
 @param overwrite 是否覆盖
 @return 解压缩结果的BOOl值
 */
- (BOOL)nv_unZipFile:(NSString *)zipFile toSubDirectory:(NSString *)subDirectory overwrite:(BOOL)overwrite {
    
    if (zipFile && subDirectory) {
        
        if ([self nv_isFileExist:zipFile]) {
            
            if (![self nv_isSubDirectoryExist:subDirectory]) {
                
                [self nv_createSubDirectory:subDirectory];
            }
            
            NSString *base = [self nv_getBaseDirectory];
            return [SSZipArchive unzipFileAtPath:zipFile toDestination:[base stringByAppendingPathComponent:subDirectory] overwrite:overwrite password:nil error:nil];
            //return [SSZipArchive unzipFileAtPath:zipFile toDestination:[base stringByAppendingPathComponent:subDirectory] overwrite:overwrite password:nil error:nil delegate:self];
        } else {
            
            return false;
        }
    } else {
        
        return false;
    }
    return false;
}

/**
 解压文件到指定路径(全部字符)
 
 @param zipFile 压缩文件目录
 @param directory 目的存放路径全部字符
 @param overwrite 是否覆盖
 @return 解压缩结果的BOOL值
 */
- (BOOL)nv_unzipFile:(NSString *)zipFile toDirectory:(NSString *)directory overwrite:(BOOL)overwrite {
    
    if (zipFile && directory) {
        
        if ([self nv_isFileExist:zipFile]) {
            
            if (![self nv_isDirectoryExist:directory]) {
                
                [self nv_createDirectory:directory];
            }
            
            return [SSZipArchive unzipFileAtPath:zipFile toDestination:directory overwrite:overwrite password:nil error:nil];
            //return [SSZipArchive unzipFileAtPath:zipFile toDestination:[base stringByAppendingPathComponent:directory] overwrite:overwrite password:nil error:nil delegate:self];
        } else {
            
            return false;
        }
    } else {
        
        return false;
    }
    return false;
}

/**
 将数个文件打包压缩为一个文件
 
 @param paths 要压缩的文件路径列表
 @param path 文件压缩后存放的地址
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFilesOfPaths:(NSArray *)paths toPath:(NSString *)path {
    
    if (paths.count && path) {
        
        //先判断如果目的文件存在先删除
        if ([self nv_isFileExist:path]) {
            
            [self nv_deleteFile:path];
        }
        
        //检查文件夹是否存在
        if ([self directOfFileCheck:path]) {
            
            return [SSZipArchive createZipFileAtPath:path withFilesAtPaths:paths];
        } else {
            
            return false;
        }
    }
    return false;
}

- (BOOL)directOfFileCheck:(NSString *)file {
    
    if (file) {
        
        NSString *direct = [file stringByDeletingLastPathComponent];
        if (![self nv_isDirectoryExist:direct]) {
            
            if ([self nv_createDirectory:direct]) {
                
                return YES;
            } else {
                
                return false;
            }
        } else {
            
            return true;
        }
    } else {
        
        return false;
    }
    
    return false;
}

/**
 将文件件压缩为一个文件
 
 @param direct 需要压缩的文件夹地址
 @param path 文件夹压缩完成后存在的地址
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFileOfDirectory:(NSString *)direct toPath:(NSString *)path {
    
    if (direct && path) {
        
        //判断文件夹是否存在
        if ([self nv_isDirectoryExist:direct]) {
            
            //检查目的目录
            if ([self directOfFileCheck:path]) {
                
                return [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:direct];
            } else {
                
                return false;
            }
        }
    } else {
        
        return false;
    }
    return false;
}

/**
 将文件夹压缩为一个文件, 可选择是否保留原始文件夹目录
 
 @param direct 需要压缩的文件夹地址
 @param path 文件夹压缩完成后存放的地址
 @param keepParentDirectory 是否保留原始文件夹目录
 @return 压缩结果的BOOL值
 */
- (BOOL)nv_zipFileOfDirectory:(NSString *)direct toPath:(NSString *)path keepParentDirectory:(BOOL)keepParentDirectory {
 
    if (direct && path) {
        
        //判断文件夹是否存在
        if ([self nv_isDirectoryExist:direct]) {
            
            //检查目的目录
            if ([self directOfFileCheck:path]) {
                
                return [SSZipArchive createZipFileAtPath:path withContentsOfDirectory:direct keepParentDirectory:keepParentDirectory];
            } else {
                
                return false;
            }
        }
    } else {
        
        return false;
    }
    return false;
}

/**
 文件夹是否存在
 
 @param directory 文件夹全部字段
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isDirectoryExist:(NSString *)directory {
    
    if (directory) {

        BOOL isDirect = true;
        return [self fileExistsAtPath:directory isDirectory:&isDirect];
    }
    
    return false;
}

/**
 子文件夹是否存在
 
 @param subDirectory 子文件夹名称(基于基地址)
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isSubDirectoryExist:(NSString *)subDirectory {
 
    if (subDirectory) {
        
        NSString *base = [self nv_getBaseDirectory];
        BOOL isDirect = true;
        return [self fileExistsAtPath:[base stringByAppendingPathComponent:subDirectory] isDirectory:&isDirect];
    }
    
    return false;
}

/**
 文件是否存在
 
 @param file 文件的地址全部字段
 @return 是否存在的BOOL值
 */
- (BOOL)nv_isFileExist:(NSString *)file {
    
    if (file) {
        
        return [self fileExistsAtPath:file];
    }
    return false;
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
    
    NSLog(@"zipfile: %@", path);
    NSLog(@"unzippedpath: %@", unzippedPath);
    
    //如果需要在解压完后执行block, 可以放在这里
}

@end
