//
//  Feed.m
//  BDR_Tool
//
//  Created by RyanGao on 2020/7/6.
//  Copyright © 2020 RyanGao. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _children = [NSMutableArray array];
    }
    return self;
}

+ (NSMutableArray<Feed *> *)pathList:(NSString *)fileName
{
     NSMutableArray<Feed *> *paths = [NSMutableArray array];
     NSDictionary *pathList = (NSDictionary *)[NSArray arrayWithContentsOfFile:fileName];
    for (NSDictionary *pathItems in pathList)
    {
        Feed *feed = [[Feed alloc] initWithName:pathItems[@"name"]];
        NSArray<NSDictionary *> *items = (NSArray<NSDictionary *> *)pathItems[@"items"];
        for (NSDictionary *dict in items) {
            FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
            [feed.children addObject:item];
        }
        [paths addObject:feed];
    }
    return paths;
}


+ (NSMutableArray<Feed *> *)pathWrite:(NSString *)fileName withAddPath:(NSString *)addPath with:(int)flag
{
    NSMutableArray<Feed *> *paths = [NSMutableArray array];
    NSDictionary *pathList = (NSDictionary *)[NSArray arrayWithContentsOfFile:fileName];
    {
        int i=0;
        for (NSDictionary *pathItems in pathList)
        {
           
            Feed *feed = [[Feed alloc] initWithName:pathItems[@"name"]];
            NSArray<NSDictionary *> *items = (NSArray<NSDictionary *> *)pathItems[@"items"];
            
            for (NSDictionary *dict in items)
            {
                if (flag == i)
                {
                    NSString *pathName = [dict valueForKey:@"file_path"];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pathName,@"file_path",@0,@"check",nil];
                    FeedItem *item = [[FeedItem alloc] initWithDictionary:dic];
                    [feed.children addObject:item];
                }
                else
                {
                    FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
                    [feed.children addObject:item];
                }

            }
            if (flag == i)
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addPath,@"file_path",@1,@"check",nil];
                FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
                [feed.children addObject:item];
            }
            i++;
            [paths addObject:feed];
        }
    }
    return paths;
}


+ (void)addToPathWrite:(NSString *)fileName withAddPath:(NSString *)addPath with:(int)flag
{
    NSArray *pathList = [NSArray arrayWithContentsOfFile:fileName];
    if (flag==0)
    {
        NSDictionary * dic = pathList[0];
        NSArray *arr1 = [dic valueForKey:@"items"];
        
        NSDictionary *dicAdd =[NSDictionary dictionaryWithObjectsAndKeys:addPath,@"file_path",@1,@"check",nil];
        //NSArray *arr2 = [[NSArray alloc] initWithObjects:dicAdd,nil];
        if ([arr1 count]<1)
        {
            arr1 = [NSArray arrayWithObjects:dicAdd,nil];
        }
        else
        {
            NSMutableArray *arrM = [NSMutableArray array];
            
            for (int i=0; i<[arr1 count]; i++)  //所有的check 都不用选
            {
                NSString *faildata = [arr1[i] valueForKey:@"file_path"];
                NSDictionary *dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",@0,@"check",nil];
                [arrM addObject:dicOrig];
            }
            
            [arrM addObject:dicAdd];
            arr1 = arrM;
        }
        
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test Data",@"name",arr1,@"items", nil];
        NSDictionary * dic1 = pathList[1];
        NSArray *arr = [NSArray arrayWithObjects:dict1,dic1, nil];
        [arr writeToFile:fileName atomically:YES];
        
        
    }
    else
    {
        NSDictionary * dic = pathList[1];
        NSArray *arr1 = [dic valueForKey:@"items"];
        NSDictionary *dicAdd =[NSDictionary dictionaryWithObjectsAndKeys:addPath,@"file_path",@1,@"check",nil];

        
        if ([arr1 count]<1)
        {
            arr1 = [NSArray arrayWithObjects:dicAdd,nil];
        }
        else
        {
            
            NSMutableArray *arrM = [NSMutableArray array];
             
             for (int i=0; i<[arr1 count]; i++)  //所有的check 都不用选
             {
                 NSString *faildata = [arr1[i] valueForKey:@"file_path"];
                 NSDictionary *dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",@0,@"check",nil];
                 [arrM addObject:dicOrig];
             }
  
            [arrM addObject:dicAdd];
            arr1 = arrM;
        }
        
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test Script",@"name",arr1,@"items", nil];
        
        NSDictionary * dic0 = pathList[0];
        NSArray *arr = [NSArray arrayWithObjects:dic0,dict1, nil];
        //NSLog(@"===write plist: %@",arr);
        [arr writeToFile:fileName atomically:YES];
    }
    
//
//    {
//        int i=0;
//        for (NSDictionary *pathItems in pathList)
//        {
//
//            Feed *feed = [[Feed alloc] initWithName:pathItems[@"name"]];
//            NSArray<NSDictionary *> *items = (NSArray<NSDictionary *> *)pathItems[@"items"];
//
//            for (NSDictionary *dict in items)
//            {
//                if (flag == i)
//                {
//                    NSString *pathName = [dict valueForKey:@"file_path"];
//                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:pathName,@"file_path",@0,@"check",nil];
//                    FeedItem *item = [[FeedItem alloc] initWithDictionary:dic];
//                    [feed.children addObject:item];
//                }
//                else
//                {
//                    FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
//                    [feed.children addObject:item];
//                }
//
//            }
//            if (flag == i)
//            {
//                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addPath,@"file_path",@1,@"check",nil];
//                FeedItem *item = [[FeedItem alloc] initWithDictionary:dict];
//                [feed.children addObject:item];
//            }
//            i++;
//            [paths addObject:feed];
//        }
//    }
//    return paths;
}







+ (void)addToItemClick:(NSString *)fileName withLine:(int)line ItemClick:(int)state with:(int)flag;
{
    NSArray *pathList = [NSArray arrayWithContentsOfFile:fileName];
    if (flag==0)
    {
        NSDictionary * dic = pathList[0];
        NSArray *arr1 = [dic valueForKey:@"items"];
    
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i=0; i<[arr1 count]; i++)  //所有的check 都不用选
        {
            NSString *faildata = [arr1[i] valueForKey:@"file_path"];
            
            NSDictionary *dicOrig = nil;
            if (i==line)
            {
                dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",[NSNumber numberWithInt:state],@"check",nil];
                
            }
            else
            {
                dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",@0,@"check",nil];
            
            }
            [arrM addObject:dicOrig];
        }
        
        arr1 = arrM;
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test Data",@"name",arr1,@"items", nil];
        NSDictionary * dic1 = pathList[1];
        NSArray *arr = [NSArray arrayWithObjects:dict1,dic1, nil];
        [arr writeToFile:fileName atomically:YES];
        
        
    }
   else
    {
        NSDictionary * dic = pathList[1];
        NSArray *arr1 = [dic valueForKey:@"items"];
            
        NSMutableArray *arrM = [NSMutableArray array];
             
         for (int i=0; i<[arr1 count]; i++)  //所有的check 都不用选
         {
             NSString *faildata = [arr1[i] valueForKey:@"file_path"];
             NSDictionary *dicOrig = nil;
            if (i==line)
              {
                  dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",[NSNumber numberWithInt:state],@"check",nil];
                  
              }
              else
              {
                  dicOrig =[NSDictionary dictionaryWithObjectsAndKeys:faildata,@"file_path",@0,@"check",nil];
              }
             [arrM addObject:dicOrig];
         }
  
        arr1 = arrM;
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Test Script",@"name",arr1,@"items", nil];
        NSDictionary * dic0 = pathList[0];
        NSArray *arr = [NSArray arrayWithObjects:dic0,dict1, nil];
        [arr writeToFile:fileName atomically:YES];
    }
    
}

@end
