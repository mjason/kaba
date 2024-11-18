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
你的项目目录必须有 data 目录
- data
  - row
    - *.target.json
    - *.input.txt
  - schema
    - *.ts

`*`代表文件名，随你喜欢，一般推荐用数字即可，schema 怎么定义直接看 typechat 文档就好了。

## 关联项目
- [lisa_typechat_server](https://github.com/mjason/lisa_typechat_server)

如果要修改服务地址你有两个方式，一个通过 `.env` 来处理，还有就是自己设置环境变量，变量名 `LISA_TYPECHAT_ENDPOINT`

## changelog

.env 需要更新
```
; LISA_TYPECHAT_ENDPOINT=https://lisa-typechat.listenai.com
LISA_ACCESS_TOKEN=聆思平台的KEY

JUDGE_ACCCESS_TOKEN=可以和LISA_ACCESS_TOKEN
JUDGE_LLM_URI_BASE=如果需要其他提供商可以填，默认不填
```