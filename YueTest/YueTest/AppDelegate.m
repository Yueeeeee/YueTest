//
//  AppDelegate.m
//  YueTest
//
//  Created by 朴悦 on 2018/10/10.
//  Copyright © 2018 chainCat. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self testStringMemory];
    
    return YES;
}

- (void)testStringMemory{
    /**
     (lldb) p t1
     (__NSCFConstantString *) $0 = 0x000000010042b178 @"123"
     (lldb) p t11
     (__NSCFConstantString *) $0 = 0x0000000109133198 @"NSString存在几种形态NSString存在几种形态"
     (lldb) p t2
     (__NSCFConstantString *) $2 = 0x000000010042b178 @"123"
     (lldb) p t21
     (__NSCFConstantString *) $3 = 0x000000010042b198 @"NSString存在几种形态NSString存在几种形态"
     
     t1,t11,t2,t21四种初始化方式是完全一样的(initWithString:@"123"会报"a literal is redundant"警告,"文字是多余的")
     内存地址较低 : 0x000000010042b178
     初始化到"常量区"
     类型为"__NSCFConstantString",不会因为字符串的长短自动改变类型
     
     */
    NSString *t1 = @"123";
    NSString *t11 = @"NSString存在几种形态NSString存在几种形态";
    NSString *t2 = [[NSString alloc] initWithString:@"123"];
    NSString *t21 = [[NSString alloc] initWithString:@"NSString存在几种形态NSString存在几种形态"];
    /**
     
     (lldb) p t3
     (NSTaggedPointerString *) $4 = 0xc13ea6955a40bf35 @"123"
     (lldb) p t31
     (__NSCFString *) $5 = 0x0000600000e1a000 @"NSString存在几种形态NSString存在几种形态"
     (lldb) p t32
     (NSTaggedPointerString *) $0 = 0xcd050a5c49ea194e @"12345678"
     (lldb) p t33
     (NSTaggedPointerString *) $1 = 0xcce8bd53383670ff @"123456789"
     (lldb) p t34
     (__NSCFString *) $2 = 0x0000600000d08740 @"12345678999"
     (lldb) p t35
     (NSTaggedPointerString *) $3 = 0xcf1226008b44cb6d @"aaaaaaaaaaa"
     (lldb) p t36
     (__NSCFString *) $4 = 0x0000600000d08a60 @"存"
     
     用stringWithFormat方法初始化,分两种情况,系统会判断字符串内容所需的存储地址
     不满足Tagged Pointer存储地址条件:t31
     地址较高 : 0x000060000152b930
     初始化到"常量区"
     类型"__NSCFString"
     
     满足Tagged Pointer存储地址条件:t3
     地址更高 : 0xc13ea6955a40bf35(不是一个真正的指针)
     初始化到"堆区"
     类型"NSTaggedPointerString"
     关于NSTaggedPointerString 参考http://www.infoq.com/cn/articles/deep-understanding-of-tagged-pointer/
     NSTaggedPointerString 的指针不是一个真的指针,而是苹果将值直接存储到了指针本身里面
     所以Tagged Pointer指针的值不再是地址了，而是真正的值,它的内存并不存储在堆中，也不需要malloc和free。
     我就暂且理解为他的内存分区在"常量区"
     Tagged Pointer专门用来存储小的对象，例如NSNumber和NSDate
     Tagged Pointer在内存读取上有着3倍的效率，创建时比以前快106倍。
     
     */
    NSString *t3 = [NSString stringWithFormat:@"123"];
    
    NSString *t31 = [NSString stringWithFormat:@"NSString存在几种形态NSString存在几种形态"];
    NSString *t32 = [NSString stringWithFormat:@"12345678"];
    NSString *t33 = [NSString stringWithFormat:@"123456789"];
    NSString *t34 = [NSString stringWithFormat:@"12345678999"];
    NSString *t35 = [NSString stringWithFormat:@"aaaaaaaaaaa"];
    NSString *t36 = [NSString stringWithFormat:@"存"];
    
    /**
     (lldb) p t5
     (__NSCFString *) $0 = 0x0000600003b82b50 @"123"
     (lldb) p t51
     (__NSCFString *) $1 = 0x0000600003b82940 @"NSString存在几种形态NSString存在几种形态"
     (lldb) p t6
     (NSTaggedPointerString *) $2 = 0xefb3efbe03764e44 @"123"
     (lldb) p t61
     (__NSCFString *) $3 = 0x00006000016f3d90 @"NSString存在几种形态NSString存在几种形态"
     
     t5,t51内存地址 : 0x0000600003b82b50
     初始化到"堆区"
     类型"__NSCFString"
     
     t6内存地址 : 0xefb3efbe03764e44
     初始化到"堆区"
     类型为"NSTaggedPointerString"
     
     t61内存地址 : 0x00006000016f3d90
     初始化到"堆区"
     类型为"__NSCFString"
     */
    NSMutableString *t5 = [[NSMutableString alloc] initWithString:@"123"];
    NSMutableString *t51 = [[NSMutableString alloc] initWithString:@"NSString存在几种形态NSString存在几种形态"];
    NSString *t6 = [t5 copy];
    NSString *t61 = [t51 copy];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
