# OpenixCard
利用github action构建YuzukiTsuru/OpenixCard.  
虽然原始仓库提供了二进制文件，但它链接到相对较高版本的glibc，这导致二进制文件无法在ubuntu 18中运行.   
不幸的是，我正在使用ubuntu 18开发全志t113-s3.   
如果直接编译会报很多错。
这里尝试修复这些报错，并发布能在ubuntu18中使用的二进制文件。 

# 使用方法
```
# 下载，给运行权限，放到 PATH
wget https://github.com/liux-pro/OpenixCard/releases/download/master/OpenixCard
chmod +x OpenixCard
sudo mv OpenixCard /usr/local/bin/

OpenixCard -d xxx.img
```

# 编译过程中遇到的问题
## gcc版本过低
ubuntu18的gcc为7，从自带的软件源中可升级到8，这就几乎够了。
## 链接到库
好像是在gcc8中这个库还有点实验性质，没有被默认链接，需要手动链接  
```
target_link_libraries(OpenixCard PRIVATE stdc++fs)
```
## 软件版本过低
更新binutils和cmake
