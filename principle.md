# JJRouter的设计文档

## JJRouter解决什么问题

* 解决组件之间通信
* 解决组件之间如何解耦，是否需要显示注册
* 需要支持URL Scheme
* 内置场景切换和数据独立，语义上清晰

## 为什么要组件化

* 提高开发效率，独立编译业务模块
* 团队协同，每个团队关注自己的领域，聚焦，减少冲突
* 复用，减少重复劳动
* 架构清晰，分工明确，横向扩展能力

## 组件的分类

### 业务组件

这个层次基本就是具体的实现，承载具体的业务，直接可以继承到具体的App上，业务模块的职责很清晰，完成产品指定的业务功能

### 基础组件

Infra Business Layer比Business Layer比下面一层，因为他们之间是上下关系，不是横向关系，他作为基础的业务组件，会被很多上层的业务组件依赖，业务领域来说，他可能是一个或者多个领域的基础业务组件，这个的话跟具体的业务场景来决定

### 业务组件和基础组件的不同

- 业务模块分离了头部分和实现部分，头和实现部分单向依赖，只能实现部分依赖头，头不能依赖实现，基础模块直接对外
- 层次不一样，业务需要解决特定的业务，基础模块是业务不敏感
- 业务模块是可以上下，横向依赖的，基础模块只有上下依赖
- 业务模块需要有横向的能力，所以要解决业务模块相互引用的问题，而基础模块是不行的，在工程上编译期间就会不通过
- 工程组织方式不一样，业务模块需要将头和实现分开，工程上是两个模块，基础模块直接是一个模块

## 组件架构图

![JJRouter all-architecture](https://raw.githubusercontent.com/jezzmemo/JJRouter/master/images/all-architecture.png)

### 组件之间如何通信

* 字符串解耦

典型的代表就是Route,字符串的形态就是URL，根据URL的语义定义，有domain,path,parameters，可以满足大部分需求，有特殊需求，可以自定义字符串格式，来达到特定的业务需求

额外补充一点，我的理解Objective-c的runtime特性，有时候也通过字符串解耦，达到组件间的通信

优点就是灵活度很高

缺点就是可读性差，多人协作，需要用规则来维护

* API调用

所以API的调用，一般是通过本身语言的特性，定义对外公开的方法，入参和出参，来调用组件的方式，所以每种语言的特点不一样，写法和调用方式有一些区别，所以这种方式，需要结合语言因地制宜，说说常用的形态：

1. 直接定义方法
2. 定义Protocol，包括IOC(Invert of control)
3. 其他，比如Swift的枚举

优点是定义清晰明白，可读性高

缺点是要解决循环依赖问题

> 组件之组织形态-集中式

![JJRouter centralization](https://raw.githubusercontent.com/jezzmemo/JJRouter/master/images/centralization.png)

无论是使用字符串解耦还是API的方式，都可以用集中式形态，所有的接口都放在一个独立的工程里管理，需要通信的组件，都需要依赖这种集中的组件，由这个集中的组件统一和集中管理，通信

优点就是可控，方便阅读

缺点就是组织庞大时，维护性差，需要频繁修改

> 组件之组织形态-分布式

分布式相对于集中式就是将接口分布在每个Domain里，由每个Domain来独立维护，如果组件之间有横向依赖，就需要解决循环依赖问题，但是好处很多，所以花点成本来解决这个问题，还是很值得的

### 是否需要显示注册

关于这个问题，我的选择最好不需要显示的注册，因为会给开发者带来麻烦，这里的麻烦是指步骤的多余，如果用适当的规则代表显示的注册，使用规则更加简单和易于接受，所以在这个问题上，我的选择是不需要注册。

### 组件分离头和实现

![JJRouter separate module](https://raw.githubusercontent.com/jezzmemo/JJRouter/master/images/separate-module.png)

* 业务模块一般实现比较重，头的方式比较轻，API申明简单，明确，开发者接入简单
* 从设计上来看，解耦，API公开和实现彻底分开，输入和输出更加明确
* 基于接口设计，扩展性更好
* 解决同一层次循环引用问题

### 单个组件的详细信息

![JJRouter single module](https://raw.githubusercontent.com/jezzmemo/JJRouter/master/images/single-module.png)

> 头部含有的信息

* Notification的定义
* 具体的业务接口定义

> 实现部分包含哪些

* 接口定义的实现
* 事件和通知的实现
* 其他内部不需要对外的实现

### 基于Swift的实现

* __基于以上的理论和选择，JJRouter选择了申明头和具体实现__

* 使用Swift的Extension方式，引用头即可调用到具体实现，__不需要注册__

* Scheme URL还是以传统的注册方式工作

* Scheme方式和显示API方式，独立分开，自由组合

> Swift之API实现

首先抽象出两个`Target`:

```
public protocol Target {
    
}

public protocol ViewControllerTarget {
    var viewController: UIViewController? { get }
}
```

如何将申明和实现分开，示例如下：

先展示申明部分:

```
// Header
enum DemoTarget: Target {
    case login
}
```

在展示实现部分:

```
// Implement
extension DemoTarget: ViewControllerTarget {
    
    var viewController: UIViewController? {
        switch self {
        case .login:
            return nil
        }
    }
    
}
```

这里有个细节要说下，有人可能会说，如果用class是否可以，也可以的，只是这里借鉴了`MOYA`的写法，所以用枚举来做示例，可读性更好。

最后通过JJRouter的核心部分来处理各自的`Target`即可，这里简单展示下API设计：

```
/// Router
open class Router {
    
    public static let `default` = Router()
    
    @discardableResult
    open func push(target: Target, from navigation: UINavigationController? = nil, animated: Bool = true) -> UIViewController? {
        return nil
    }
    
    @discardableResult
    open func present(target: Target, from viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return nil
    }
}
```

> Swift之Scheme实现

原理上是和API的设计是类似的，但是他们之间最大的不同是，__API方式是不需要显示注册的，Scheme还是需要手动来注册的__,Scheme的抽象定义如下：

```
public protocol Scheme {
    
    init?(url: URLConvertible)
    
    var viewController: UIViewController? { get }
    
}
```

这里再重点说下Scheme的细节，原来上来说，Scheme是通过字符串来解耦的，只用定义字符来实现跨平台的达到同一目的，在使用上注意以下几点：

1. 如果是纯内部Scheme，可以不用公开，模块内部调用即可
2. 如果是公开的Scheme，你采用的是Header和Implement分开的组件化方案，建议将公开的Scheme字符串，公开到Header
3. 如果是公开的Scheme，你采用的是中心化的Header，建议将公开的Scheme字符串，公开到中心化的Header
4. 如果你的Scheme和API，没有任何关联，可以各自实现，如果有关联，建议将Scheme的调用到API那边，这样只用主要维护API即可

最后展示下Register和Open的API设计：

```
protocol SchemeAction {
    
    func register(scheme: Scheme.Type)
    
    func viewController(url: URLConvertible) -> UIViewController?
}
```

```
extension Router {
    
    open func push(url: URLConvertible, from: UINavigationController? = nil, animated: Bool = true) -> UIViewController? {
        return nil
    }
    
    open func present(url: URLConvertible, from: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return nil
    }
}
```
