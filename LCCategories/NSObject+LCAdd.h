//
//  NSObject+LCAdd.h
//
//  Created by Liu-Mac on 4/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LCAdd)

#pragma mark - runtime

/**
 字典转模型: 使用字典创建当前类对象
 
 @param dict 字典
 @return 模型
 */
+ (instancetype)lc_objectWithDict:(NSDictionary *)dict;

/**
 字典数组转模型数组: 使用字典数组创建当前类对象的数组

 @param array 字典数组
 @return 模型数组
 */
+ (NSArray *)lc_objectsWithArray:(NSArray *)array;

/**
 返回当前类的属性数组

 @return 属性数组
 */
+ (NSArray *)lc_propertiesList;

/**
 返回当前类的成员变量数组

 @return 成员变量数组
 */
+ (NSArray *)lc_ivarsList;

/**
 返回当前类的继承链字符串

 @return 继承链字符串
 */
+ (NSString *)lc_classInheritChain;

@end
