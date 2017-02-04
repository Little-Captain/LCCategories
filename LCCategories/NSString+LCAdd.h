//
//  NSString+LCAdd.h
//
//  Created by Liu-Mac on 3/27/2015.
//  Copyright © 2015 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCAdd)

#pragma mark - 沙盒路径相关

/**
 * 通过当前文件路径生成沙盒中的Documents路径
 *
 * \@"" -> 沙盒Documents路径
 * \@"xxx"  -> 沙盒Documents路径/xxx
 * \@"xxx/xxx.xxx"  -> 沙盒Documents路径/xxx.xxx
 *
 * @return 沙盒Documents路径
 */
- (NSString *)lc_generateDocumentsPath;

/**
 * 通过当前文件路径生成沙盒中的Caches路径
 *
 * \@"" -> 沙盒Caches路径
 * \@"xxx"  -> 沙盒Caches路径/xxx
 * \@"xxx/xxx.xxx"  -> 沙盒Caches路径/xxx.xxx
 
 * @return 沙盒Caches路径
 */
- (NSString *)lc_generateCachesPath;

/// 给当前文件追加临时路径tmp
/**
 通过当前文件路径生成沙盒中的tmp路径
 
 \@"" -> 沙盒tmp路径
 \@"xxx"  -> 沙盒tmp路径/xxx
 \@"xxx/xxx.xxx"  -> 沙盒tmp路径/xxx.xxx
 
 @return 沙盒tmp路径
 */
- (NSString *)lc_generateTmpPath;

#pragma mark - 网络处理相关

/**
 获取mimeType

 @param path 传入的文件路径
 @return mimeType
 */
+ (NSString *)mimeTypeForFileAtPath:(NSString *)path;

#pragma mark - base64 编解码相关

/// 对当前字符串进行 BASE 64 编码，并且返回结果
- (NSString *)lc_base64Encode;

/// 对当前字符串进行 BASE 64 解码，并且返回结果
- (NSString *)lc_base64Decode;

#pragma mark - 散列函数
/**
 *  计算MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 -s "string"
 *  @endcode
 *
 *  <p>提示：随着 MD5 碰撞生成器的出现，MD5 算法不应被用于任何软件完整性检查或代码签名的用途。<p>
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)lc_md5String;

/**
 *  计算SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)lc_sha1String;

/**
 *  计算SHA224散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha224
 *  @endcode
 *
 *  @return 56个字符的SHA224散列字符串
 */
- (NSString *)lc_sha224String;

/**
 *  计算SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)lc_sha256String;

/**
 *  计算SHA 384散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha384
 *  @endcode
 *
 *  @return 96个字符的SHA 384散列字符串
 */
- (NSString *)lc_sha384String;

/**
 *  计算SHA 512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512
 *  @endcode
 *
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)lc_sha512String;

#pragma mark - HMAC 散列函数
/**
 *  计算HMAC MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl dgst -md5 -hmac "key"
 *  @endcode
 *
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)lc_hmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1 -hmac "key"
 *  @endcode
 *
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)lc_hmacSHA1StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256 -hmac "key"
 *  @endcode
 *
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)lc_hmacSHA256StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512 -hmac "key"
 *  @endcode
 *
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)lc_hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - 文件散列函数

/**
 *  计算文件的MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 file.dat
 *  @endcode
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)lc_fileMD5Hash;

/**
 *  计算文件的SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha1 file.dat
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)lc_fileSHA1Hash;

/**
 *  计算文件的SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha256 file.dat
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)lc_fileSHA256Hash;

/**
 *  计算文件的SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha512 file.dat
 *  @endcode
 *
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)lc_fileSHA512Hash;

@end
