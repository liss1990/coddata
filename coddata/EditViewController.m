//
//  EditViewController.m
//  coddata
//
//  Created by 李丝思 on 16/9/24.
//  Copyright © 2016年 思. All rights reserved.
//

#import "EditViewController.h"
#import <CoreData/CoreData.h>

@interface EditViewController ()
@property (nonatomic,strong)NSManagedObjectContext *objectContext;
@property (strong, nonatomic)   UITextField *userName;
@property (strong, nonatomic)   UITextField *age;
@property (strong, nonatomic)   UIButton *saveBtn;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName=[[UITextField alloc]initWithFrame: CGRectMake(20, 70, 100, 40)];
    self.userName.placeholder=@"姓名";
    self.age=[[UITextField alloc]initWithFrame: CGRectMake(20, 100, 100, 40)];
    self.age.placeholder=@"年龄";
    [self.view addSubview:self.userName];
    [self.view addSubview:self.age];
    self.saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(clicksaveBtn) forControlEvents:UIControlEventTouchUpInside];
    self.saveBtn.frame=CGRectMake(20, 150, 50, 50);
    [self.view addSubview:self.saveBtn];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.userName.text=self.user.name;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    self.age.text = [numberFormatter stringFromNumber:self.user.age];
    
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
-(void)clicksaveBtn{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSArray *array = [self.objectContext executeFetchRequest:request error:nil];
    
    for (User *u in array) {
        if (u.name==self.userName.text) {
            UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"通知" message:@"用户名重复！"      preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alter addAction:okAction];
            [self presentViewController:alter animated:YES completion:nil];
            return;
        }
    }
    
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.objectContext];
    user.name=self.userName.text;
    user.age =  [NSNumber numberWithInteger:[self.age.text intValue]]; 
    [self.objectContext save:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
