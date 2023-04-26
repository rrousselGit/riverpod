<p align="center">
<a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>

<p align="center">
<a href="https://www.netlify.com">
  <img src="https://www.netlify.com/img/global/badges/netlify-color-accent.svg" alt="Deploys by Netlify" />
</a>
</p>

<p align="center">
<img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

</p>

<p align="center">
<a ref="./README.md">原文档</a>
</p>

---

`riverpod` 是一个状态管理库，其：

- 能在编译时而不是运行时捕获编程错误
- 不用嵌套侦听/组合对象
- 保证代码可测试

| riverpod         | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=riverpod&color=blue)](https://pub.dartlang.org/packages/riverpod)                 |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flutter_riverpod | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=flutter_riverpod&color=blue)](https://pub.dartlang.org/packages/flutter_riverpod) |
| hooks_riverpod   | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=hooks_riverpod&color=blue)](https://pub.dartlang.org/packages/hooks_riverpod)     |

欢迎来到 [Riverpod]！

此项目可视作 [provider] 的重写，以实现原本不可能实现的改进

请查看文档 [https://riverpod.dev](https://riverpod.dev) 以了解如何使用 [Riverpod]

简单来说：

- 将你的 `providers` 声明为全局变量：

  ```dart
  final counterProvider = StateNotifierProvider((ref) {
    return Counter();
  });

  class Counter extends StateNotifier<int> {
    Counter(): super(0);

    void increment() => state++;
  }
  ```

- 以编译时安全的方式在你的组建中使用他们，且没有运行时异常！

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final count = ref.watch(counterProvider);
      return Text(count.toString());
    }
  }
  ```

若有任何有关 [provider] 是什么意思的疑惑，请查看 [FAQ](#FAQ)

## 版本迁移

随着 `1.0.0` 版本的发布，与 `providers` 交互的语法发生了变化

查看 [迁移指导](https://riverpod.dev/docs/migration/0.14.0_to_1.0.0/) 以获取更多信息

## 目录

- [版本迁移](#版本迁移)
- [目录](#目录)
- [缘起](#缘起)
- [贡献代码](#贡献代码)
- [FAQ](#faq)
  - [为什么有了 `provider` 包还写这个？](#为什么有了-provider-包还写这个)
  - [在实际项目里使用它安全吗？](#在实际项目里使用它安全吗)
  - [`riverpod` 和 `provider` 包什么时候会合并吗？](#riverpod-和-provider-包什么时候会合并吗)
  - [`provider` 包会被遗弃吗？](#provider-包会被遗弃吗)
- [赞助](#赞助)

## 缘起

如果说 [provider]（作者原先写的状态管理库）是 [InheritedWidget] 的简化，那么 [Riverpod] 就是从头开始重新实现[InheritedWidget]

它与 [provider] 的原理非常相似，但为了尝试解决 [provider] 面临的常见问题，两者也存在重大差异

[Riverpod] 有多个目标。首先，它继承了 [provider] 的目标：

- 能够安全地创建、观察和处理状态，而不必担心在小部件重建时丢失状态
- 默认情况下使我们的对象在 Flutter 的开发工具中可见
- 可测试、可组合
- 当我们有多个 [InheritedWidget] 时提高它们的可读性（这自然会导致深度嵌套的组件树）
- 通过单向数据流使应用程序更具可扩展性

由此 [Riverpod] 更进一步：

- 现在读取对象是**编译安全的**，不会再有运行时异常
- 它使得原先 [provider] 包里的模式更加灵活，允许共存
  允许的特性有：
  - 能够拥有多个相同类型的 `provider`
  - 在 `provider` 不再使用时自动 `dispose`
  - 有计算状态
  - 使 `provider` 私有
- 简化复杂的对象树，且更容易依赖异步状态
- 使此模式独立于 Flutter，即在纯 `dart` 程序中也能使用

这些将由不再使用 [InheritedWidget] 实现，反之 [Riverpod] 以相近的模式实现了自己的机制

请查看文档 [https://riverpod.dev](https://riverpod.dev) 以了解如何使用 [Riverpod]

## 贡献代码

欢迎贡献代码！

这里是一个规划好的帮助列表：

- 报告错误和难以实施的场景
- 报告文档中不清楚的部分
- 修复拼写错误/语法错误
- 更新文档/添加示例
- 通过拉取请求实现新功能

## FAQ

### 为什么有了 `provider` 包还写这个？

虽然原先的 [provider] 包被广泛使用并被社区广泛接受，但它也不够完美

大家面临一些问题时经常发问或提出 `issue`，例如：

- 为什么报 `ProviderNotFoundException` 的错？
- 如何在不再使用时自动 `dispose` 状态？
- 如何使一个 `provider` 依赖于其他（可能更加复杂的）`provider`？

这些都是合情合理的问题，我也相信这些可以改进一些东西来解决它们

但问题是，这些问题扎根于原先 [provider] 包的底层原理，并且若不重写 [provider] 的底层逻辑的话就几乎没法修复这些问题

在某种程度上，如果 [provider] 是蜡烛，那么 [Riverpod] 就是灯泡，它们用法非常相似，但我们不能通过改进蜡烛来制造灯泡

### 在实际项目里使用它安全吗？

是滴～

[Riverpod] 是稳定的，且会积极维护

### `riverpod` 和 `provider` 包什么时候会合并吗？

有可能。我们在进行一些测试它们合并的实验，但结果还不清楚

（没有创建相关 `issue` ，避免给相关人员带来不必要的压力）

如果实验成功（尽管不太可能），那么 Provider 和 Riverpod 可以融合

### `provider` 包会被遗弃吗？

可能吧。

Provider 包有许多无法完全修复的缺陷，但 Riverpod 已经证明其可以解决其中的许多问题

因此，正在考虑弃用 Provider

Riverpod 包唯一的不便是需要一个 `Consumer`，而 Provider 包不需要

但是正在研究一些替代方案，以消除这种限制

不过无论决定是什么，都计划提供一个迁移工具来帮助开发者从 [Provider] 包迁移到 [Riverpod]，以及提供任何所需的其他工具

## 赞助

<p align="center">
  <a href="https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg">
    <img src='https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg'/>
  </a>
</p>

[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/riverpod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
