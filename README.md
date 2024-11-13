# Kaba
咔吧是一款数据构建工具，使用 Ruby 完成，使用 typechat 作为核心，目的是构建一款能够比较好适配大模型 sft 数据集的工具，整个项目使用起来只需要安装 docker 即可。

> 开源协议：你爱干嘛干嘛

## 安装

如果你有一个 Ruby 环境可用（且 ruby 版本大于 3.3），你可以使用以下命令全局安装 kaba：
```
gem install kaba
```

否则，你可以通过别名运行一个 docker 化版本（将下面的命令添加到你的~/.bashrc、~/.zshrc或类似文件中，以简化重复使用）。

```
alias kaba='docker run -it --rm -v "${PWD}:/workdir" ghcr.io/mjason/kaba:latest'
```

## 目录结构说明

## 目录结构
- data
  - row
  - schema

## 项目依赖

