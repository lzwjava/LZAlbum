# LZAlbum
基于 LeanCloud 的朋友圈，展示了如何在 LeanCloud 上实现一对一和一对多的关系建模。

![album](https://cloud.githubusercontent.com/assets/5022872/9563818/dd9588ba-4ec3-11e5-940a-3d1e84b967f0.gif)


# Support

如果在使用过程中有任何问题，请提 [issue](https://github.com/lzwjava/LZAlbum/issues) ，我会在 Github 上给予帮助。

# Run
```
   pod install --no-repo-update --verbose (报错说库找不到的话，去掉 --no-repo-update)
   open LZAlbum.xcworkspace
```

# Credit

UI 界面大量借鉴了 [MessageDisplayKit](https://github.com/xhzengAIB/MessageDisplayKit)，数据放在了 LeanCloud 上，一并表示感谢。

# Backend

![image](https://cloud.githubusercontent.com/assets/5022872/7449102/2390131e-f260-11e4-8978-cead60e2f272.png)

用公共账号登录 https://leancloud.cn ，账号/密码：leancloud@163.com/Public123 ，选择应用 LCAlbum 即可查看表结构。  
**注意 请不要更改后台数据，查看就好了。否则可能造成客户端崩溃**   
**注意 上面的账号密码不是这个应用登录的账号，而是 LeanCloud 后台的账号。应用登录的账号，先在注册界面注册一个即可。**  

# Document

[相关文档](https://leancloud.cn/docs/ios_os_x_guide.html)

# License
MIT
