Make RamDisk
=============


> Created by EJSohn 17.05.01

> RamDisk를 만드는 과정을 담은 문서입니다. 


---------


### Display free disk space


먼저 현재 마운트된 파일 시스템에서 사용가능한 공간을 다음 명령어로 확인합니다.


```bash
df -h
```


### RamDisk로 마운트 될 디렉토리를 생성합니다


```bash
sudo mkdir /media/RamDisk
sudo chmod 1777 /media/RamDisk
```


### 실제 RamDisk를 생성합니다.


램디스크를 생성하는 명령어는 다음과 같습니다.


```bash
mount -t [TYPE] -o size=[SIZE] [FSTYPE] [MOUNTPOINT]
```


- [TYPE] is the type of RAM disk to use; either tmpfs or ramfs.
- [SIZE] is the size to use for the file system. Remember that ramfs does not have a physical limit and is specified as a starting size.
- [FSTYPE] is the type of RAM disk to use; either tmpfs, ramfs, ext4, etc.


여기서 사용할 램디스크의 타입은 [여기](https://www.jamescoyle.net/knowledge/951-the-difference-between-a-tmpfs-and-ramfs-ram-disk) 에서 자세히 알아보세요. 


일단 다음 명령어를 통해 램디스크를 만들고 넘어가겠습니다.


```bash
sudo mount -t tmpfs -o size=1000M,nr_inodes=10k,mode=1777 tmpfs /media/RamDisk
```


### 만들어 놓은 RamDisk를 부팅 시마다 자동으로 생성하게 만듭니다. 


> 다음 과정을 통해 RamDisk는 영구적으로 상주하게 됩니다.

> Ram 특성상 재부팅마다 안의 내용은 사라지니 조심하세요


```bash
vi /etc/fstab
```


명령어를 통해 연 파일을 뒷부분에 다음을 붙여주세요.


```
tmpfs /media/RamDisk tmpfs size=1000M,nr_inodes=10k,mode=1777 0 0
```


### Plus


설정한 램디스크 마운트 해제하기
```bash
sudo umount /media/RamDisk
```


---------



Tested Environments
------------------

- Ubuntu



References
-----------
> [JamesCoyle blog](https://www.jamescoyle.net/how-to/943-create-a-ram-disk-in-linux)



