//
//  CYDataManager.h
//  CoreDataCreateDataSample
//
//  Created by tikitikipoo on 11/09/10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface CYDataManager : NSObject
{
    
    NSManagedObjectContext* _managedObjectContext;
    
}

// 初期化
+ (CYDataManager*)sharedManager;

// カードディクショナリーの操作
-(Tag*)insertNewTag;

-(void)save;

@end
