//
//  main.m
//  iconMaker
//
//  Created by Franky on 2018/9/6.
//  Copyright © 2018年 Franky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

/**
 将NSImage对象保存到磁盘
 
 @param image NSImage对象
 @param filePath 文件路径
 @return 是否保存成功
 */
BOOL saveImage(NSImage *image, NSString *filePath) {
    [image lockFocus];
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:NSImageCompressionFactor];
    NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
    return [imageData writeToFile:filePath atomically:YES];
}

/**
 将图片按照一定的尺寸重新绘制出来
 
 @param sourceImage 源图片
 @param size 尺寸
 @return 新图片
 */
NSImage * resizeImage(NSImage *sourceImage, NSSize size) {
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImageRep *sourceImageRep = [sourceImage bestRepresentationForRect:targetFrame context:nil hints:nil];
    NSImage *targetImage = [[NSImage alloc] initWithSize:size];
    [targetImage lockFocus];
    [sourceImageRep drawInRect:targetFrame];
    [targetImage unlockFocus];
    return targetImage;
}

#pragma mark -
@interface IconModel : NSObject
@property (nonatomic, copy) NSString *idiom;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *scale;
@property (nonatomic, copy) NSString *filename;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)iconModelWithDict:(NSDictionary *)dict;
@end
@implementation IconModel
+ (instancetype)iconModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

#pragma mark - main
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            NSLog(@"你需要提供图片文件的路径");
            return 1;
        }
        
        NSString *filePath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSImage *originalImage = [[NSImage alloc] initWithContentsOfFile:filePath];
        if (![originalImage isKindOfClass:[NSImage class]]) {
            NSLog(@"提供的文件不是图片类型");
            return 2;
        }
        if (originalImage.size.width != 1024 && originalImage.size.height != 1024) {
            NSLog(@"提供的图片文件尺寸不对,请提供一张宽高为1024的图片");
            return 3;
        }
        
        NSDictionary *content = @{@"images": @[@{@"idiom": @"iphone",@"size": @"20x20",@"scale": @"2x",@"filename": @"iphone_20@2x.png"},
                                               @{@"idiom": @"iphone",@"size": @"20x20",@"scale": @"3x",@"filename": @"iphone_20@3x.png"},
                                               @{@"idiom": @"iphone",@"size": @"29x29",@"scale": @"2x",@"filename": @"iphone_29@2x.png"},
                                               @{@"idiom": @"iphone",@"size": @"29x29",@"scale": @"3x",@"filename": @"iphone_29@3x.png"},
                                               @{@"idiom": @"iphone",@"size": @"40x40",@"scale": @"2x",@"filename": @"iphone_40@2x.png"},
                                               @{@"idiom": @"iphone",@"size": @"40x40",@"scale": @"3x",@"filename": @"iphone_40@3x.png"},
                                               @{@"idiom": @"iphone",@"size": @"60x60",@"scale": @"2x",@"filename": @"iphone_60@2x.png"},
                                               @{@"idiom": @"iphone",@"size": @"60x60",@"scale": @"3x",@"filename": @"iphone_60@3x.png"},
                                               @{@"idiom": @"ipad",@"size": @"20x20",@"scale": @"1x",@"filename": @"ipad_20.png"},
                                               @{@"idiom": @"ipad",@"size": @"20x20",@"scale": @"2x",@"filename": @"ipad_20@2x.png"},
                                               @{@"idiom": @"ipad",@"size": @"29x29",@"scale": @"1x",@"filename": @"ipad_29.png"},
                                               @{@"idiom": @"ipad",@"size": @"29x29",@"scale": @"2x",@"filename": @"ipad_29@2x.png"},
                                               @{@"idiom": @"ipad",@"size": @"40x40",@"scale": @"1x",@"filename": @"ipad_40.png"},
                                               @{@"idiom": @"ipad",@"size": @"40x40",@"scale": @"2x",@"filename": @"ipad_40@2x.png"},
                                               @{@"idiom": @"ipad",@"size": @"76x76",@"scale": @"1x",@"filename": @"ipad_76.png"},
                                               @{@"idiom": @"ipad",@"size": @"76x76",@"scale": @"2x",@"filename": @"ipad_76@2x.png"},
                                               @{@"idiom": @"ipad",@"size": @"83.5x83.5",@"scale": @"2x",@"filename": @"ipad_83.5@2x.png"},
                                               @{@"idiom": @"ios-marketing",@"size": @"1024x1024",@"scale": @"1x",@"filename": @"icon.png"},
                                               ],
                                  @"info": @{@"version": @1,
                                             @"author": @"masterKing"
                                             }};
        
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dict in content[@"images"]) {
            IconModel *icon = [IconModel iconModelWithDict:dict];
            [marr addObject:icon];
        }
        
        NSString *desktopDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) firstObject];
        NSString *savePath = [desktopDirectoryPath stringByAppendingPathComponent:@"AppIcon.appiconset"];
        
        BOOL success = [NSFileManager.defaultManager createDirectoryAtPath:savePath withIntermediateDirectories:NO attributes:nil error:nil];
        if (success) {
            for (IconModel *model in marr) {
                NSArray *components = [model.size componentsSeparatedByString:@"x"];
                CGSize size = CGSizeMake([components.firstObject floatValue], [components.lastObject floatValue]);
                CGFloat scale = [[model.scale substringToIndex:1] floatValue];
                NSImage *cuttedImage = resizeImage(originalImage, CGSizeMake(size.width * scale, size.height * scale));
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",savePath,model.filename];
                if (saveImage(cuttedImage, fileName)) {
                    NSLog(@"%@保存成功",model.filename);
                }else{
                    NSLog(@"%@保存失败",model.filename);
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
            [jsonData writeToFile:[NSString stringWithFormat:@"%@/Contents.json",savePath] atomically:NO];
        }else{
            NSLog(@"创建文件夹失败");
        }
    }
    return 0;
}
