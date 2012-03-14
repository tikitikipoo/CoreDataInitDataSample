//
//  CYDataManager.h
//  CoreDataImportDataSample
//
//  Created by tikitikipoo on 11/09/10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"

@interface CYDataManager : NSObject
{
    
    NSManagedObjectContext* _managedObjectContext;
    
}

// 初期化
+ (CYDataManager*)sharedManager;

-(void)testForCreateManagedObjectContext;

@end
