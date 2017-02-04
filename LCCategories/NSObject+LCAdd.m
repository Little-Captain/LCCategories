//
//  NSObject+LCAdd.m
//
//  Created by Liu-Mac on 4/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "NSObject+LCAdd.h"
#import <objc/runtime.h>

@implementation NSObject (LCAdd)

+ (instancetype)lc_objectWithDict:(NSDictionary *)dict {
    
    // 断言判断字典类型
    NSAssert([dict isKindOfClass:[NSDictionary class]], @"参数必须是字典类型");
    
    // 获得属性数组
    NSArray *list = [self lc_propertiesList];
    
    // 创建对象
    id obj = [self new];
    
    // 遍历字典
    for (NSString *key in dict) {
        // 判断字典中的 key 是否在成员变量中存在
        if (![list containsObject:key]) {
            continue;
        }
        // 通过 KVC 给对象对应的属性赋值
        [obj setValue:dict[key] forKey:key];
    }
    
    return obj;
}

+ (NSArray *)lc_objectsWithArray:(NSArray *)array {
    
    if (array.count == 0) {
        return nil;
    }
    
    // 断言是字典数组
    NSAssert([array isKindOfClass:[NSArray class]], @"参数必须是数组类型");
    
    // 遍历数组
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        // 将对象添加到数组
        [arrayM addObject:[self lc_objectWithDict:dict]];
    }
    
    return arrayM.copy;
}

static void * const propertiesKey = "lc.propertiesList";

+ (NSArray *)lc_propertiesList {
    
    // 获取关联对象, 这一步用于提高此方法的效率
    NSArray *result = objc_getAssociatedObject(self, propertiesKey);
    
    if (result != nil) {
        // result 有值, 直接返回
        return result;
    }
    
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    
    // 遍历所有的属性
    NSMutableArray *arrayM = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
    
        objc_property_t pty = list[i];
        
        // 获取 property 名称
        const char *cName = property_getName(pty);
        NSString *name = [NSString stringWithUTF8String:cName];
        
        [arrayM addObject:name];
    }
    
    // 释放属性列表
    free(list);
    
    // 设置关联对象
    objc_setAssociatedObject(self, propertiesKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, propertiesKey);
}

static void * const ivarsKey = "lc.ivarsList";

+ (NSArray *)lc_ivarsList {
    
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, ivarsKey);
    
    if (result != nil) {
        // result 有值, 直接返回
        return result;
    }
    
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    
    // 遍历所有的属性
    NSMutableArray *arrayM = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        
        Ivar ivar = list[i];
        
        // 获取 ivar 名称
        const char *cName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:cName];
        
        [arrayM addObject:name];
    }
    
    // 释放成员变量列表
    free(list);
    
    // 设置关联对象
    objc_setAssociatedObject(self, ivarsKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, ivarsKey);
}


@end
