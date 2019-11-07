
/*

有参数宏中关于##的使用#define WIDE(str) L##str
则会将形参str的前面加上L
比如：WIDE("abc")就会被替换成L"abc"
如果有#define FUN(a,b) vo##a##b()
那么FUN(id ma,in)会被替换成void main()
*/
//1. 在.h中写声明的宏, name 为类名.(声明后面不加分号)
//备注:使用带参数的宏interfaceSingleton来替代单例方法的声明
#define interfaceSingleton(name)  +(instancetype)share##name;

#if __has_feature(objc_arc)
// ARC

//2. 在.m中写单例实现的宏，name为类名.(实现后面不加分号)
//备注:使用带参数的宏implementationSingleton来替代单例方法的实现
#define implementationSingleton(name)  \
+ (instancetype)share##name \
{ \
name *instance = [[self alloc] init]; \
return instance; \
} \
static name *_instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#else
// MRC

#define implementationSingleton(name)  \
+ (instancetype)share##name \
{ \
name *instance = [[self alloc] init]; \
return instance; \
} \
static name *_instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (oneway void)release \
{ \
} \
- (instancetype)retain \
{ \
return _instance; \
} \
- (NSUInteger)retainCount \
{ \
return  MAXFLOAT; \
}
#endif


