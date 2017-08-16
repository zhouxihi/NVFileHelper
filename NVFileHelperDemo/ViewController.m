//
//  ViewController.m
//  NVFileHelperDemo
//
//  Created by Jackey on 2017/5/31.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "ViewController.h"
#import "NSFileManager+NVFileHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //测试初始化, 并设置基地址
    
    NSFileManager *mananger = [NSFileManager nv_shareInstance];
    NSLog(@"basedirect: %@", mananger.nv_getBaseDirectory);
    
    [mananger nv_setBaseDirectory:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    NSLog(@"basedirect: %@", mananger.nv_getBaseDirectory);
    
    //测试拼接文件地址, 创建文件夹但不创建文件
    NSString *pinjie = [mananger nv_getPathWithSubDirect:@"pinjie" fileName:@"name.zip"];
    NSLog(@"pinjie: %@", pinjie);
    
    //测试拼接文件地址, 创建文件夹 创建文件
    NSString *pinjie2 = [mananger nv_createFileWithSubDirect:@"pinjie2" fileName:@"a.a"];
    NSLog(@"pinjie2: %@", pinjie2);
    
    //测试拷贝文件
//    if ([mananger nv_copyFile:pinjie2 toFile:pinjie]) {
//        
//        NSLog(@"拷贝成功");
//    } else {
//        NSLog(@"拷贝失败");
//    }
    
    //测试移动文件
//    if ([mananger nv_moveFile:pinjie2 toFile:pinjie]) {
//        
//        NSLog(@"移动成功");
//    } else {
//        NSLog(@"移动失败");
//    }
    
    //测试删除文件
//    if ([mananger nv_deleteFile:pinjie2]) {
//        
//        NSLog(@"删除成功");
//    } else {
//        
//        NSLog(@"删除失败");
//    }
    
    //测试创建子目录
//    if ([mananger nv_createSubDirectory:@"pinjie3"]) {
//        
//        NSLog(@"创建子目录成功");
//    } else {
//        
//        NSLog(@"创建子目录失败");
//    }
    
    //测试创建路径
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *dir = [doc stringByAppendingPathComponent:@"pinjie4"];
//    if ([mananger nv_createDirectory:dir]) {
//        
//        NSLog(@"创建路径成功");
//    } else {
//        
//        NSLog(@"创建路径失败");
//    }
    
    //测试创建文件
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *dir = [[doc stringByAppendingPathComponent:@"pinjie5"] stringByAppendingPathComponent:@"c.c"];
//    if ([mananger nv_createFile:dir]) {
//        
//        NSLog(@"创建文件成功");
//    } else {
//        
//        NSLog(@"创建文件失败");
//    }
    
    //测试单个文件压缩
//    NSArray *array = @[pinjie2];
//    if ([mananger nv_zipFilesOfPaths:array toPath:pinjie]) {
//        
//        NSLog(@"压缩成功");
//    } else {
//        
//        NSLog(@"压缩失败");
//    }
    
    //测试压缩文件夹
//    if ([mananger nv_zipFileOfDirectory:[pinjie2 stringByDeletingLastPathComponent] toPath:pinjie]) {
//        
//        NSLog(@"压缩成功");
//    } else {
//        
//        NSLog(@"压缩失败");
//    }
    
    //测试压缩文件夹, 保留原始文件夹目录
//    if ([mananger nv_zipFileOfDirectory:[pinjie2 stringByDeletingLastPathComponent] toPath:pinjie keepParentDirectory:YES]) {
//        
//        NSLog(@"压缩成功");
//    } else {
//        
//        NSLog(@"压缩失败");
//    }
    
    //测试解压文件
    [mananger nv_createSubDirectory:@"pinjie6"];
    if ([mananger nv_unZipFile:pinjie toSubDirectory:@"pinjie6" overwrite:YES]) {
        
        NSLog(@"解压成功");
    } else {
        
        NSLog(@"解药失败");
    }
    NSLog(@"完成");
}

@end
