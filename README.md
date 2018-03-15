# SearchBarInIpad
自己管理searchBar的frame,解决Ipad上的searchBar不能显示cancel按钮.

##### 感觉iOS越做越烂，用个searchaBar问题一堆。在导航栏上添加searchBar一句话搞定：
```
self.navigationItem.titleView = self.searchBar
```

##### but,在ipad上cancel按钮屎活不出现。自己在导航栏上手动添加一个rightBarItem当做cancel按钮横竖屏又会出现各种UI上的bug。此处省略一大堆实验......。

##### 认真搜索了一下官方文档发现：
```
Discussion
Cancel buttons are not displayed for apps running on iPad, even when you specify YES for the showsCancelButton parameter
```

##### 好吧，人家压根就不支持在ipad searchBar上显示cancel按钮。so，只能找替代方案了。

> ### 方案一: *storyBoard*，适合present到新界面

##### 用xib会有问题，在storyBoard创建一个UINavigationController，创建一个带searchBar的viewContorller用storyBoard去初始化界面，并且把searchBar拖到storyBoard上，设置显示cancel按钮。设置UINavigationController的根控制器为viewContorller。不过注意次方案是并没有把searchBar放在`self.navigationItem.titleView`上，而是放在`self.navigationController?.navigationBar`下面.所以在你push方式到该界面时会显示44.0左右的`navigationBar`高度在searchBar上面。所以需要我们手动隐藏`navigationBar`:
```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
}

//iOS10及以下以这种方式添加的searchBar层级会在比较里面被遮挡，需要手动改变层级到最上层
if #available(iOS 11.0, *) {
    self.view.bringSubview(toFront: self.searchBar)
}

//跳转到改viewCintroller需要自带一个navigationControlle
let storyboard: UIStoryboard = UIStoryboard(name: "控制器所在stiryboard名字", bundle: nil)
if let searchNavigationController = storyboard.instantiateViewController(withIdentifier: "自带导航控制器的storyboardId") as? UIPopGestureNavigationController {
    if let viewController = searchNavigationController.viewControllers.first as? SearchExistingCloudContactsViewController {
        viewController.phoneNumber = phoneNumber
        }
    self.present(searchNavigationController, animated: true, completion: nil)
}
    
```
### 注意：该种方案只适合present到一个带有navigationController的viewController

### 记住设置searchBar布局约束时***要以safe area为基准***

![](https://note.youdao.com/yws/api/personal/file/WEBd5a08062034deaf2c24a31958bc2441b?method=download&shareKey=f4e151c8aadf16916ebed3114c949ddb)


> ### 方案二: 使用frame自己addSubView到navigationBar，适合push到新界面

#### 这种方案是自己手动添加到navigationBar，并且使用frame布局，需要自己手动更新横竖屏时的searchBar的frame.手动添加一个rightBarItem和leftBarItem,searchBar的长度为navigationBar的width减掉rightBarItem和leftBarItem的width(可以根据实际设置间距):

```
//初始化
if UIDevice.current.userInterfaceIdiom == .pad {
            let cancelButtonItem = UIBarButtonItem(customView: self.cancelButton)
            self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = cancelButtonItem
            
            let backlButtonItem = UIBarButtonItem(customView: self.backButton)
            self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = backlButtonItem
            
            if let navigationBarButtonFrame = self.navigationController?.navigationBar.frame {
                self.searchBar.alpha = 0.0
                
                CATransaction.begin()
                
                CATransaction.setCompletionBlock({
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                        UIView.animate(withDuration: 0.4, animations: {
                            self.searchBar.alpha = 1.0
                        })
                    })
                })
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.searchBar.frame = CGRect(x: self.backButton.frame.size.width + 30.0, y: (navigationBarButtonFrame.size.height - self.cancelButton.frame.size.height) / 2.0, width: navigationBarButtonFrame.size.width - self.cancelButton.frame.size.width - self.backButton.frame.size.width - 60.0, height: self.cancelButton.frame.size.height)
                    self.navigationController?.navigationBar.addSubview(self.searchBar)
                })
                
                CATransaction.commit()
            }
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
```

#### 适配横竖屏
```
override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let navigationBarButtonFrame = self.navigationController?.navigationBar.frame {
            self.searchBar.frame = CGRect(x: self.backButton.frame.size.width + 30.0, y: (navigationBarButtonFrame.size.height - self.cancelButton.frame.size.height) / 2.0, width: navigationBarButtonFrame.size.width - self.cancelButton.frame.size.width - self.backButton.frame.size.width - 60.0, height: self.cancelButton.frame.size.height)
        }
    }
```

#### 处理界面psuh或present到其他界面
```
override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !self.searchBar.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.isHidden = true
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.searchBar.isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchBar.isHidden = false
            })
        }
    }
```

#### 不过这种方式在界面切换时会有UI小问题，可以到我的gitHub去下个我的小demo看看.
