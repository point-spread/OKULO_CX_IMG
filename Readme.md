[Zh](./Readme.md)|[En](./Readme_en.md)

# Turotials

1. 获取仓库

```bash
git clone https://github.com/point-spread/OKULO_CX_IMG.git
```

2. 获取交叉编译工具链

```bash
git clone https://gitee.com/pointspread_0/okulo_cx_toolchain.git --depth 1
```

3. 构建镜像

```bash
export UBUNTU_GCC_CROSS_TARGZ=$PATH_TO_REPO_OKULO_CX_TOOLCHAIN/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz
ver=v0.0.1
./build_docker.sh -v $ver
```

# 编译问题：
1. 无法执行 `FROM ubuntu:20.04` 指令
```bash
#2 ERROR: failed to copy: httpReadSeeker: failed open: failed to do request: Get "https://production.cloudflare.docker.com/registry-v2/docker/registry/v2/blobs/sha256/5f/5f5250218d28ad6612bf653eced407165dd6475a4daf9210b299fed991e172e9/data?verify=1718162136-AUDv7pku1KH3gr6jsxHlh0WRnuY%3D": dial tcp: lookup production.cloudflare.docker.com: no such host
------
 > [internal] load metadata for docker.io/library/ubuntu:20.04:
------
Dockerfile:1
--------------------
   1 | >>> FROM ubuntu:20.04

ERROR: failed to solve: ubuntu:20.04: failed to resolve source metadata for docker.io/library/ubuntu:20.04: failed to copy: httpReadSeeker: failed open: failed to do request: Get "https://production.cloudflare.docker.com/registry-v2/docker/registry/v2/blobs/sha256/5f/5f5250218d28ad6612bf653eced407165dd6475a4daf9210b299fed991e172e9/data?verify=1718162136-AUDv7pku1KH3gr6jsxHlh0WRnuY%3D": dial tcp: lookup production.cloudflare.docker.com: no such host

```
解决方式：
```bash
systemd-resolve --flush-caches # 20.04 and lower

resolvectl flush-caches # 22.04 and higher

docker system prune -a
```