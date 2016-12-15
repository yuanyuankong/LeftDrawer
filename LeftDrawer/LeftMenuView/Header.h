//
//  Header.h
//  LeftDrawer
//
//  Created by 柴胡 on 16/12/15.
//  Copyright © 2016年 jyk. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width 
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


#ifdef DEBUG
#define LOG(fmt, ...) do {                                                  \
NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__];         \
NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__); \
[file release];                                                             \
} while(0)
#define LOG_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#define COUNT(p) NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
#define LOG_TRACE(x) do {printf x; putchar('\n'); fflush(stdout);} while (0)
# else
#define LOG(...)
#define LOG_METHOD
#define COUNT(p)
#define LOG_TRACE(x)
#endif

#endif /* Header_h */
