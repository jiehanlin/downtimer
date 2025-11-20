# Linux编译指南

本文档说明如何为DownTimer应用编译Linux版本，支持x64和ARM64架构。

## 方法1: 使用Docker交叉编译 (推荐)

### 前置要求
- 安装Docker Desktop
- 确保Docker正在运行

### 编译步骤

#### Windows用户
```bash
# 运行批处理脚本
build_linux.bat
```

#### Linux/macOS用户
```bash
# 给脚本执行权限
chmod +x build_linux.sh

# 运行脚本
./build_linux.sh
```

### 输出
编译完成后，在`build/output/`目录下会生成：
- `downtimer-linux-x64.tar.gz` - 64位Intel/AMD系统版本
- `downtimer-linux-arm64.tar.gz` - 64位ARM系统版本

## 方法2: 使用GitHub Actions (自动化)

推送到GitHub仓库后，会自动触发构建：

1. **推送代码**
   ```bash
   git push origin main
   ```

2. **创建发布版本**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **下载构建产物**
   - 访问GitHub Actions页面
   - 下载对应的构建产物
   - 或在Releases页面下载打包好的版本

## 方法3: 在Linux系统上直接编译

### 前置要求
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Fedora
sudo dnf install clang cmake ninja-build pkg-config gtk3-devel lzma-sdk

# Arch Linux
sudo pacman -S clang cmake ninja pkgconf gtk3 lzma
```

### 编译步骤

#### x64架构
```bash
flutter config --enable-linux-desktop
flutter build linux --target-platform linux-x64 --release
```

#### ARM64架构 (需要交叉编译工具链)
```bash
# 安装ARM64交叉编译工具
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# 创建ARM64系统根目录
sudo mkdir -p /usr/aarch64-linux-gnu
sudo cp -r /usr/include /usr/aarch64-linux-gnu/
sudo cp -r /usr/lib /usr/aarch64-linux-gnu/

# 编译ARM64版本
flutter build linux --target-platform linux-arm64 --release --target-sysroot /usr/aarch64-linux-gnu
```

## 安装和运行

### 解压运行
```bash
# x64系统
tar -xzf downtimer-linux-x64.tar.gz
./downtimer

# ARM64系统
tar -xzf downtimer-linux-arm64.tar.gz
./downtimer
```

### 系统级安装 (可选)
```bash
# 解压到/opt目录
sudo tar -xzf downtimer-linux-x64.tar.gz -C /opt
sudo ln -s /opt/downtimer /usr/local/bin/downtimer
```

## 系统依赖

应用已经打包了大部分依赖，但可能需要：
```bash
# Ubuntu/Debian
sudo apt-get install libgtk-3-0 libxss1 libasound2

# Fedora
sudo dnf install gtk3 libXScrnSaver alsa-lib

# Arch Linux
sudo pacman -S gtk3 libxss alsa-lib

# CentOS/RHEL
sudo yum install gtk3 libXScrnSaver alsa-lib
```

## 测试验证

### 在x64系统上测试
```bash
# 解压x64版本
tar -xzf downtimer-linux-x64.tar.gz
./downtimer
```

### 在ARM64系统上测试 (如树莓派4)
```bash
# 解压ARM64版本
tar -xzf downtimer-linux-arm64.tar.gz
./downtimer
```

## 故障排除

### 常见问题

1. **缺少GTK库**
   ```
   Error while loading shared libraries: libgtk-3.so.0
   ```
   解决方案：安装GTK开发库

2. **无法显示窗口**
   检查是否安装了图形环境（X11或Wayland）

3. **权限问题**
   ```bash
   chmod +x downtimer
   ```

4. **ARM64版本无法运行**
   确保在真正的ARM64系统上运行，而不是模拟器

### 日志调试
```bash
# 启用详细日志
./downtimer --verbose
```

## 版本兼容性

- **Flutter**: 3.32.7 (stable)
- **最低Linux内核**: 3.10+
- **推荐内存**: 256MB+
- **推荐存储**: 50MB+

## 架构支持

| 架构 | 平台 | 支持状态 |
|------|------|----------|
| x64  | Intel/AMD 64位 | ✅ 完全支持 |
| ARM64| AArch64 64位 | ✅ 完全支持 |
| ARM32| AArch32 32位 | ⚠️ 需要额外配置 |

## 打包分发

### AppImage (可选)
```bash
# 安装appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# 创建AppImage
./appimagetool-x86_64.AppImage downtimer.AppDir/
```

### Debian包 (可选)
```bash
# 使用dpkg-deb创建deb包
dpkg-deb --build downtimer-deb/
```

### Flatpak (可选)
```bash
# 需要创建Flatpak manifest文件
flatpak-builder build-dir com.example.downtimer.json
```