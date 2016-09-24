//
//  ViewController.m
//  coddata
//
//  Created by 李丝思 on 16/6/5.
//  Copyright © 2016年 思. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "User.h"
@interface ViewController ()
@property (nonatomic,strong)NSManagedObjectContext *objectContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化上下文
    self.objectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    //初始化model
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    //	通过存储助理 把数据库写到本地
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString *sqlitePath = [path stringByAppendingString:@"user.sqlite"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    self.objectContext.persistentStoreCoordinator=coordinator;
    
}
- (IBAction)add:(id)sender {
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.objectContext];
    user.name=@"李思";
    user.age = @82;
    user.tell=@"66666666666";
    [self.objectContext save:nil];
    
    
}
- (IBAction)deleted:(id)sender {
    NSFetchRequest *reques = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    reques.predicate  = [NSPredicate predicateWithFormat:@"name = %@",@"李思思"];
    NSArray *array = [self.objectContext executeFetchRequest:reques error:nil];
    
    for (User *u in array) {
        [self.objectContext deleteObject:u];
    }
    [self.objectContext save:nil ];
    
    
    
}
- (IBAction)update:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"age = %@",@"82"];
    NSArray *array = [self.objectContext executeFetchRequest:request error:nil];
    for (User *u in array) {
        u.name = @"你好";
        u.age = @23;
        u.tell =@"8888888";
    }
    if ([self.objectContext save:nil ]) {
        NSLog(@"修改成功");
    } 
    
}
- (IBAction)select:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]];
    
    NSArray *array = [self.objectContext executeFetchRequest:request error:nil];
    for (User *u in array) {
        NSLog( @"姓名%@   年龄%@  电话%@",u.name,u.age,u.tell);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
