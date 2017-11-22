//
//  AppDelegate.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "NotifyModel.h"


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"6c07715200c0e7a85449ea18"
                          channel:@"App Store"
                 apsForProduction:false
            advertisingIdentifier:nil];
    
    [[HNUesrInformation getInformation] login];
    [[HNUesrInformation getInformation] getQNToken];
    BaseTabBarViewController *tabbar = [[BaseTabBarViewController alloc] init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    [JPUSHService setBadge:0];

//    NSString *phone = [NSString stringWithFormat:@"%@",self.phone];
    
    return YES;
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if ([[HNUesrInformation getInformation].model.phone isEqualToString:@"13599514434"]) {
        return ;
    }
    
    NotifyModel *model = [NotifyModel mj_objectWithKeyValues:userInfo];
    NSString *content = [NSString stringWithFormat:@"%@",[model.aps objectForKey:@"alert"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([model.type isEqualToString:@"apply_via"]||[model.type isEqualToString:@"apply_turned"]||[model.type isEqualToString:@"apply_succeed"]||[model.type isEqualToString:@"apply_failed"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodDetailsNotification" object:model];
        }else if ([model.type isEqualToString:@"reward"]||[model.type isEqualToString:@"comment_zan"]||[model.type isEqualToString:@"comment"]||[model.type isEqualToString:@"share_zan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareNotification" object:model];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:sure];
    [alertController addAction:cancel];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    if ([[HNUesrInformation getInformation].model.phone isEqualToString:@"13599514434"]) {
        return ;
    }
    NotifyModel *model = [NotifyModel mj_objectWithKeyValues:userInfo];
    NSString *content = [NSString stringWithFormat:@"%@",[model.aps objectForKey:@"alert"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([model.type isEqualToString:@"apply_via"]||[model.type isEqualToString:@"apply_turned"]||[model.type isEqualToString:@"apply_succeed"]||[model.type isEqualToString:@"apply_failed"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodDetailsNotification" object:model];
        }else if ([model.type isEqualToString:@"reward"]||[model.type isEqualToString:@"comment_zan"]||[model.type isEqualToString:@"comment"]||[model.type isEqualToString:@"share_zan"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareNotification" object:model];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:sure];
    [alertController addAction:cancel];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService setBadge:0];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 4*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
        if (phone.length==11) {
            [JPUSHService setTags:nil alias:phone fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
            }];
        }
    });
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
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


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    showMassage(@"success")
}
@end
