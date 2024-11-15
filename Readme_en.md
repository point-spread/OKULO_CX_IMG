[En](./Readme_en.md)|[Zh](./Readme.md)

1. Get repo

```bash

git clone https://github.com/point-spread/OKULO_CX_IMG.git
```

2. acquire cross compilier

```bash
git clone https://gitee.com/pointspread_0/okulo_cx_toolchain.git --depth 1
```

3. construct docker image

```bash
export UBUNTU_GCC_CROSS_TARGZ=$PATH_TO_REPO_OKULO_CX_TOOLCHAIN/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz
ver=v0.0.1
./build_docker.sh -v $ver
```
