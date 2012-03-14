//
//  CYDataManager.m
//  CoreDataCreateDataSample
//
//  Created by tikitikipoo on 11/09/10.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CYDataManager.h"
#import "Tag.h"

@implementation CYDataManager

//@synthesize managedObjectContext = _managedObjectContext;

static CYDataManager* _sharedInstance = nil;



#pragma mark - 初期化

+ (CYDataManager*)sharedManager
{
    // インスタンス作成
    if (!_sharedInstance) {
        _sharedInstance = [[CYDataManager alloc] init];
    }
    
    return _sharedInstance;
}

- (void)dealloc
{
    // インスタンス変数を解放する
    [_managedObjectContext release], _managedObjectContext = nil;
    
    // 親クラスのdeallocを呼び出す
    [super dealloc];
}


//--------------------------------------------------------------//
#pragma mark -- プロパティ --
//--------------------------------------------------------------//


- (NSManagedObjectContext*) managedObjectContext
{
    NSError* error;
    
    // インスタンス変数が生成されていたら、それを返却
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    // 管理対象オブジェクトモデルの作成
    NSManagedObjectModel* managedObjectModel;
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 永続ストアコーディネータの作成
    NSPersistentStoreCoordinator* persistentStoreCoordinator;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
                                  initWithManagedObjectModel:managedObjectModel];
    [persistentStoreCoordinator autorelease];
    
    // 保存ファイルの決定
    NSArray*    paths;
    NSString*   path = nil;
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0) {
        path = [paths objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"sample"];
        path = [path stringByAppendingPathComponent:@"sample.db"];
        
    }
    
    if (!path) {
        NSLog(@"path is null");
        return nil;
    }
    
    // ディレクトリの作成
    NSString*       dirPath;
    NSFileManager*  fileMgr;
    
    dirPath = [path stringByDeletingLastPathComponent];
    fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:dirPath]) {
        if (![fileMgr createDirectoryAtPath:dirPath 
                withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Failed to create directory at path %@, erro %@", 
                  dirPath, [error localizedDescription]);
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:path]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"init" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:path error:NULL];
		}
	}

    
    // ストアURLの作成
    NSURL* url = nil;
    url  = [NSURL fileURLWithPath:path];
    
    
    // 永続ストアの追加
    NSPersistentStore* persistentStore;
    persistentStore = [persistentStoreCoordinator 
                       addPersistentStoreWithType:NSSQLiteStoreType 
                       configuration:nil 
                       URL:url options:nil 
                       error:&error];
    
    if (!persistentStore && error) {
        NSLog(@"Failed to create add persistent store %@", [error localizedDescription]);
    }
    
    // 管理対象オブジェクトコンテキストの作成
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    // 永続ストアコーディネータの設定
    [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    
    return _managedObjectContext;
}

-(void)testForCreateManagedObjectContext
{
    // 管理対象オブジェクトコンテキストを取得する
    NSManagedObjectContext* context;
    context = self.managedObjectContext;
}

@end
