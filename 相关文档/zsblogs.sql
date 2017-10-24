/*
Navicat MySQL Data Transfer

Source Server         : zs
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : zsblogs

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2017-10-24 22:36:13
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `blog`
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `create_time` datetime NOT NULL,
  `summary` varchar(255) NOT NULL,
  `ishide` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES ('1', 'asa', '湿哒哒所', '2017-10-14 17:43:35', 'ads', '0');
INSERT INTO `blog` VALUES ('2', '第二篇', '社会实践', '2017-10-14 18:03:17', 'ddd', '0');
INSERT INTO `blog` VALUES ('3', '俩sad', '啊啊啊啊', '2017-10-15 20:22:28', 'sss', '0');
INSERT INTO `blog` VALUES ('4', 'sssssss张顺', 'ada大', '2017-10-15 20:22:37', 'aa', '0');
INSERT INTO `blog` VALUES ('5', '美团App 插件化实践', '<h3 id=\"-\">背景</h3>\r\n<p>在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。但纵观各大插件框架，都是基于自身App的业务来开发的，目标或多或少都有区别，所以很难有一个插件框架能一统江湖解决所有问题。最后就是绕不开的兼容性问题，Android每次版本升级都会给各个插件化框架带来不少冲击，都要费劲心思适配一番，更别提国内各个厂商对在ROM上做的定制了，正如VirtualAPK的作者任玉刚所说：完成一个插件化框架的 Demo 并不是多难的事儿，然而要开发一款完善的插件化框架却并非易事。</p>\r\n<p>早在2014年美团移动技术团队就开始关注插件化技术了，并且意识到插件化架构是美团这种平台型App最好的集成形式。但由于业务增长、迭代、演化太快，受限于业务耦合和架构问题，插件化一直无法落地。到了2016年底，经过一系列的代码架构调整、技术调研，我们终于能腾出手来让插件化技术落地了。</p>\r\n<p>美团平台（与点评平台一起）目前承载了美团点评所有事业群近20条业务线的业务。其中有相对成熟的业务，比如外卖、餐饮，他们对插件的要求是稳定性高，不能因为上了插件导致业务出问题；也有迭代变化很快的业务，如交通、跑腿、金融等，他们要求能快速迭代上线；此外，由于美团App采用的二进制AAR依赖方式集成已经运转了两年，各种基础设施都很成熟了，我们不希望换成插件形式的接入之后还要改变开发模式。所以，美团平台对插件的诉求主要集中在兼容性和不影响开发模式这两个点上。</p>\r\n<h3 id=\"-\">美团插件化框架的原理和特点</h3>\r\n<p>插件框架的兼容性体现在多个方面，由于Android机制的问题，有些写法在插件化之前运行的很正常，但是接入插件化之后就变得不再有效。如果不解决兼容性问题，插件化的口碑和推广都会很大阻碍。兼容性不仅仅指的是对Android系统、Android碎片化的兼容，还要对已有基础库和构建工具的兼容。特别是后者，我们经常看到Github上开源的插件化框架里面有大量Crash的Issue，就是这个方面原因导致的。每个App的基础库和既有构建工具都不太一样，所以为自己的App选择合适的方案显得尤为重要。</p>\r\n<p>为了保证插件的兼容性，并能无缝兼容当前AAR开发模式，美团的插件化框架方案主要做了以下几点：：</p>\r\n<ul>\r\n<li>插件的Dex加载使用类似MultiDex方案，保证对反射的兼容</li>\r\n<li>替换所有的AssetManager，保证对资源访问的兼容</li>\r\n<li>四大组件预埋，代理新增Activity</li>\r\n<li>让构建系统来抹平AAR开发模式和插件化开发模式的差异</li>\r\n</ul>\r\n<p>MultiDex和组件代理这里不细说，网上有很多这方面的博客可以参考。下面重点说一下美团插件化框架对资源的处理和支持AAR、插件一键切换的构建系统。</p>\r\n<h3 id=\"-\">资源处理</h3>\r\n<p>了解插件化的读者都知道：如果希望访问插件的资源，需要使用AssetManager把插件的路径加入进去。但这样做是远远不够的。这是因为如果希望这个AssetManager生效，就得把它放到具体的Resources或ResourcesImpl里面，大部分插件化框架的做法是封装一个包含插件路径AssetManager的Resources，然后插件中只使用这一个Resources。</p>\r\n<p>这样的做法大多数情况是有效的，但是有至少3个问题：</p>\r\n<ol>\r\n<li>如果在插件中使用了宿主Resources，如：<code>getApplicationContext().getResources()</code>。 这个Resources就无法访问插件的资源了</li>\r\n<li>插件外的Resources 并不唯一，需要全局查找和替换</li>\r\n<li>Resoureces在使用的过程中有很多中间产物，例如Theme、TypedArray等等。这些都需要清理才能正常使用</li>\r\n</ol>\r\n<p>要完全解决这些问题，我们另辟蹊径，做了一个全局的资源处理方式：</p>\r\n<ul>\r\n<li>新建或者使用已有AssetManger，加载插件资源</li>\r\n<li>查找所有的Resources/Theme，替换其中的AssetManger</li>\r\n<li>清理Resources缓存，重建Theme</li>\r\n<li>AssetManager的重建保护，防止丢失插件路径</li>\r\n</ul>\r\n<p>这个方案和InstantRun有点类似，但是原生InstantRun有太多的问题：</p>\r\n<ul>\r\n<li>清理顺序错误，应该先清理Applicaiton后清理Activity</li>\r\n<li>Resources/Theme找不全，没有极端情况应对机制</li>\r\n<li>Theme光清理不重建</li>\r\n<li>完全不适配 Support包里面自己埋的“雷”<br>等等</li>\r\n</ul>\r\n<pre><code class=\"java\"><span class=\"keyword\">for</span> (Activity activity : activities) {\r\n    ... <span class=\"comment\">// 省略部分代码</span>\r\n    Resources.Theme theme = activity.getTheme();\r\n    <span class=\"keyword\">try</span> {\r\n        <span class=\"keyword\">try</span> {\r\n            Field ma = Resources.Theme.class.getDeclaredField(<span class=\"string\">\"mAssets\"</span>);\r\n            ma.setAccessible(<span class=\"keyword\">true</span>);\r\n            ma.set(theme, newAssetManager);\r\n        } <span class=\"keyword\">catch</span> (NoSuchFieldException ignore) {\r\n            Field themeField = Resources.Theme.class.getDeclaredField(<span class=\"string\">\"mThemeImpl\"</span>);\r\n            themeField.setAccessible(<span class=\"keyword\">true</span>);\r\n            Object impl = themeField.get(theme);\r\n            Field ma = impl.getClass().getDeclaredField(<span class=\"string\">\"mAssets\"</span>);\r\n            ma.setAccessible(<span class=\"keyword\">true</span>);\r\n            ma.set(impl, newAssetManager);\r\n        }\r\n        ...\r\n    } <span class=\"keyword\">catch</span> (Throwable e) {\r\n        Log.e(LOG_TAG, <span class=\"string\">\"Failed to update existing theme for activity \"</span> + activity,\r\n                e);\r\n    }\r\n    pruneResourceCaches(resources);\r\n}\r\n</code></pre>\r\n<p>这个思路是对的，但是远不够。例如，Google 自己的Support包里面的一个类 android.support.v7.view.ContextThemeWrapper会生成一个新的Theme保存：</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">public</span> <span class=\"class\"><span class=\"keyword\">class</span> <span class=\"title\">ContextThemeWrapper</span> <span class=\"keyword\">extends</span> <span class=\"title\">ContextWrapper</span> </span>{\r\n    <span class=\"keyword\">private</span> <span class=\"keyword\">int</span> mThemeResource;\r\n    <span class=\"keyword\">private</span> Resources.Theme mTheme;\r\n    <span class=\"keyword\">private</span> LayoutInflater mInflater;\r\n    ...\r\n    <span class=\"function\"><span class=\"keyword\">private</span> <span class=\"keyword\">void</span> <span class=\"title\">initializeTheme</span><span class=\"params\">()</span> </span>{\r\n        <span class=\"keyword\">final</span> <span class=\"keyword\">boolean</span> first = mTheme == <span class=\"keyword\">null</span>;\r\n        <span class=\"keyword\">if</span> (first) {\r\n            mTheme = getResources().newTheme();\r\n            <span class=\"keyword\">final</span> Resources.Theme theme = getBaseContext().getTheme();\r\n            <span class=\"keyword\">if</span> (theme != <span class=\"keyword\">null</span>) {\r\n                mTheme.setTo(theme);\r\n            }\r\n        }\r\n        onApplyThemeResource(mTheme, mThemeResource, first);\r\n    }\r\n    ...\r\n}\r\n</code></pre>\r\n<p>如果没有替换了这个ContextThemeWrapper的Theme，假如配合它使用的Reources/AssetManager是新的，就会导致Crash：<br><code>java.lang.RuntimeException: Failed to resolve attribute at index 0</code><br>这是大部分开源框架都存在的Issue。<br>为了解决这个问题，我们不仅清理所有Activity的Theme，还清理了所有View的Context。</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">try</span> {\r\n    List&lt;View&gt; list = getAllChildViews(activity.getWindow().getDecorView());\r\n    <span class=\"keyword\">for</span> (View v : list) {\r\n        Context context = v.getContext();\r\n        <span class=\"keyword\">if</span> (context <span class=\"keyword\">instanceof</span> ContextThemeWrapper\r\n                &amp;&amp; context != activity\r\n                &amp;&amp; !clearContextWrapperCaches.contains(context)) {\r\n            clearContextWrapperCaches.add((ContextThemeWrapper) context);\r\n            pruneSupportContextThemeWrapper((ContextThemeWrapper) context, newAssetManager); <span class=\"comment\">// 清理Theme</span>\r\n        }\r\n    }\r\n} <span class=\"keyword\">catch</span> (Throwable ignore) {\r\n    Log.e(LOG_TAG, ignore.getMessage());\r\n}\r\n</code></pre>\r\n<p>但是这些做法还是不能解决所有问题，有时候为了实现一个产品需求，Android工程师可能会采取一些非常规写法，导致变成插件之后资源加载失败。比如在一个自己的类里面保存了Theme。这种问题不可能一个个改业务代码，那能不能让插件兼容这种写法呢？<br>我们对这种行为也做了兼容：<strong>修改字节码</strong>。</p>\r\n<p>了解虚拟机指令的同学都知道，如果要保存一个类变量，对应的虚拟机的指令是PUTFIELD/PUTSTATIC，以此为突破口，用ASM写一个MethodVisitor：</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">static</span> <span class=\"class\"><span class=\"keyword\">class</span> <span class=\"title\">MyMethodVisitor</span> <span class=\"keyword\">extends</span> <span class=\"title\">MethodVisitor</span> </span>{\r\n    <span class=\"keyword\">int</span> stackSize = <span class=\"number\">0</span>;\r\n\r\n    MyMethodVisitor(MethodVisitor mv) {\r\n        <span class=\"keyword\">super</span>(Opcodes.ASM5, mv);\r\n    }\r\n\r\n    <span class=\"annotation\">@Override</span>\r\n    <span class=\"function\"><span class=\"keyword\">public</span> <span class=\"keyword\">void</span> <span class=\"title\">visitFieldInsn</span><span class=\"params\">(<span class=\"keyword\">int</span> opcode, String owner, String name, String desc)</span> </span>{\r\n        <span class=\"keyword\">if</span> (opcode == Opcodes.PUTFIELD || opcode == Opcodes.PUTSTATIC) {\r\n            <span class=\"keyword\">if</span> (<span class=\"string\">\"Landroid/content/res/Resources$Theme;\"</span>.equals(desc)) {\r\n                stackSize = <span class=\"number\">1</span>;\r\n                visitInsn(Opcodes.DUP);\r\n                <span class=\"keyword\">super</span>.visitMethodInsn(Opcodes.INVOKESTATIC,\r\n                        <span class=\"string\">\"com/meituan/hydra/runtime/Transformer\"</span>,\r\n                        <span class=\"string\">\"collectTheme\"</span>,\r\n                        <span class=\"string\">\"(Landroid/content/res/Resources$Theme;)V\"</span>,\r\n                        <span class=\"keyword\">false</span>);\r\n            }\r\n        }\r\n        <span class=\"keyword\">super</span>.visitFieldInsn(opcode, owner, name, desc);\r\n    }\r\n\r\n    <span class=\"annotation\">@Override</span>\r\n    <span class=\"function\"><span class=\"keyword\">public</span> <span class=\"keyword\">void</span> <span class=\"title\">visitMaxs</span><span class=\"params\">(<span class=\"keyword\">int</span> maxStack, <span class=\"keyword\">int</span> maxLocals)</span> </span>{\r\n        <span class=\"keyword\">super</span>.visitMaxs(maxStack + stackSize, maxLocals);\r\n        stackSize = <span class=\"number\">0</span>;\r\n    }\r\n}\r\n</code></pre>\r\n<p>这样可以保证所有被类保存的Theme都会被收集起来，在插件安装后，统一清理、重建就行了。</p>\r\n<h3 id=\"-\">插件的构建系统</h3>\r\n<p>为了实现在AAR集成方式和插件集成方式之间一键切换，并解决插件化遇到的“API陷阱”的问题，我们把大量的时间花在构建系统的建设上面，我们的构建系统除了支持常规的构建插件之外，还支持已有构建工具和未来可能存在的构建工具。<br>我们将正常构建过程分为4个阶段：</p>\r\n<ol>\r\n<li>收集依赖</li>\r\n<li>处理资源</li>\r\n<li>处理代码</li>\r\n<li>打包签名</li>\r\n</ol>\r\n<p>那么如何保证对已有Gradle插件的支持？最好的方式是不对这个构建过程做太多干涉，保证它们的正常、按顺序执行。所以我们的构建系统在不干扰这个顺序的基础上，把插件的构建过程插入进去，对应正常构建的4个阶段，主要做了如下工作。</p>\r\n<ul>\r\n<li>宿主解析依赖之后，分析插件的依赖，进行依赖仲裁和引用计数分析</li>\r\n<li>宿主处理资源之前，处理插件资源，规避了资源访问的陷阱，生成需要Merge的资源列表给宿主，开发 美团AAPT 处理插件资源</li>\r\n<li>宿主处理代码之中，规避插件API使用的陷阱，复用宿主的Proguard和Gradle插件，做到对原生构建过程的最大兼容。我们也修复了Proguard Mapping的问题，后续会有专门的博客介绍</li>\r\n<li>宿主打包签名之前，构建插件APK，计算升级兼容的Hash特征，使用V2签名加快运行时的验证</li>\r\n</ul>', '2017-10-16 14:40:36', '在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。', '0');
INSERT INTO `blog` VALUES ('8', '1111111111', '2222222222', '2017-10-18 15:59:13', '3333333', '0');
INSERT INTO `blog` VALUES ('9', '222222222222', '33333', '2017-10-18 16:03:24', '33344444', '0');
INSERT INTO `blog` VALUES ('10', '张顺你还好吗', '你好', '2017-10-21 16:24:28', '张顺你好', '0');

-- ----------------------------
-- Table structure for `blog_comment`
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(255) NOT NULL,
  `create_time` datetime NOT NULL,
  `u_id` int(11) DEFAULT NULL,
  `b_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `u_id` (`u_id`),
  KEY `b_id` (`b_id`),
  CONSTRAINT `blog_comment_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`),
  CONSTRAINT `blog_comment_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_comment
-- ----------------------------
INSERT INTO `blog_comment` VALUES ('1', '最近由于为了业务独立和风险规避，需要将比较重要和比较独立的模块从原项目中拆分出来搭建到其他服务器上，然后就需要搭建项目框架，但每次搭建框架都是特别麻烦，于是就想做一个这样的东西：一个将基本的东西全都创建好的项目原型，这样每次启动项目时直接拷贝过来稍微修改就能直接使用，这样就非常效率，好了，废话不多说。', '2017-10-19 15:39:31', '1', '9');
INSERT INTO `blog_comment` VALUES ('2', '测试一下', '2017-10-19 17:20:17', '1', '9');
INSERT INTO `blog_comment` VALUES ('3', '试一下', '2017-10-19 17:25:37', null, '9');
INSERT INTO `blog_comment` VALUES ('4', '看看', '2017-10-19 17:29:38', null, '9');
INSERT INTO `blog_comment` VALUES ('5', '111111', '2017-10-19 17:30:45', null, '9');
INSERT INTO `blog_comment` VALUES ('6', '大时代', '2017-10-19 17:31:59', null, '9');
INSERT INTO `blog_comment` VALUES ('7', '爱的达到多', '2017-10-19 17:32:56', null, '9');
INSERT INTO `blog_comment` VALUES ('8', '1111111', '2017-10-19 17:33:05', null, '9');
INSERT INTO `blog_comment` VALUES ('9', '检查', '2017-10-19 17:34:00', null, '9');
INSERT INTO `blog_comment` VALUES ('10', '终于', '2017-10-19 17:34:18', null, '9');
INSERT INTO `blog_comment` VALUES ('11', '22222', '2017-10-19 17:35:09', null, '9');
INSERT INTO `blog_comment` VALUES ('12', '你好', '2017-10-19 20:34:28', null, '9');
INSERT INTO `blog_comment` VALUES ('13', '测试评论', '2017-10-19 20:34:51', null, '5');
INSERT INTO `blog_comment` VALUES ('14', '使用登录用户测试评论', '2017-10-19 20:51:09', null, '5');
INSERT INTO `blog_comment` VALUES ('15', '使用登录用户测试评论', '2017-10-19 20:51:26', null, '5');
INSERT INTO `blog_comment` VALUES ('16', '111111111111', '2017-10-19 20:51:56', null, '8');
INSERT INTO `blog_comment` VALUES ('17', '222222222222', '2017-10-19 20:54:27', null, '3');
INSERT INTO `blog_comment` VALUES ('18', '说一下', '2017-10-19 21:01:22', '1', '3');
INSERT INTO `blog_comment` VALUES ('19', '哈罗', '2017-10-19 21:01:52', '2', '3');
INSERT INTO `blog_comment` VALUES ('20', '试一下', '2017-10-20 09:07:05', '1', '9');
INSERT INTO `blog_comment` VALUES ('21', '使用登录用户测试评论', '2017-10-20 15:58:48', '1', '5');

-- ----------------------------
-- Table structure for `blog_list`
-- ----------------------------
DROP TABLE IF EXISTS `blog_list`;
CREATE TABLE `blog_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `create_time` datetime NOT NULL,
  `bl_order` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `u_id` (`u_id`),
  CONSTRAINT `blog_list_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_list
-- ----------------------------
INSERT INTO `blog_list` VALUES ('1', '测试', '2017-10-14 17:43:16', '1', '1');
INSERT INTO `blog_list` VALUES ('2', '随笔', '2017-10-17 17:23:51', '2', '1');
INSERT INTO `blog_list` VALUES ('3', '成功日记', '2017-10-17 17:24:14', '3', '1');
INSERT INTO `blog_list` VALUES ('4', '设计思想', '2017-10-17 17:24:25', '4', '1');
INSERT INTO `blog_list` VALUES ('5', 'java web', '2017-10-18 17:01:34', '5', '2');

-- ----------------------------
-- Table structure for `blog_list_rel`
-- ----------------------------
DROP TABLE IF EXISTS `blog_list_rel`;
CREATE TABLE `blog_list_rel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bl_id` int(11) DEFAULT NULL,
  `b_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bl_id` (`bl_id`),
  KEY `b_id` (`b_id`),
  CONSTRAINT `blog_list_rel_ibfk_1` FOREIGN KEY (`bl_id`) REFERENCES `blog_list` (`id`),
  CONSTRAINT `blog_list_rel_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_list_rel
-- ----------------------------
INSERT INTO `blog_list_rel` VALUES ('1', '1', '8');
INSERT INTO `blog_list_rel` VALUES ('2', '2', '8');
INSERT INTO `blog_list_rel` VALUES ('3', '3', '8');
INSERT INTO `blog_list_rel` VALUES ('4', '2', '9');
INSERT INTO `blog_list_rel` VALUES ('5', '3', '9');
INSERT INTO `blog_list_rel` VALUES ('7', '1', '3');
INSERT INTO `blog_list_rel` VALUES ('8', '1', '2');
INSERT INTO `blog_list_rel` VALUES ('9', '1', '1');
INSERT INTO `blog_list_rel` VALUES ('10', '1', '4');
INSERT INTO `blog_list_rel` VALUES ('22', '1', '5');
INSERT INTO `blog_list_rel` VALUES ('23', '4', '5');
INSERT INTO `blog_list_rel` VALUES ('24', '2', '10');
INSERT INTO `blog_list_rel` VALUES ('25', '3', '10');
INSERT INTO `blog_list_rel` VALUES ('26', '4', '10');

-- ----------------------------
-- Table structure for `permission`
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `method` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `flag` varchar(255) DEFAULT NULL,
  `menu_img` varchar(255) DEFAULT NULL,
  `menu_order` int(11) DEFAULT NULL,
  `menu_parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `url` (`url`,`method`),
  KEY `menu_parent_id` (`menu_parent_id`),
  CONSTRAINT `permission_ibfk_1` FOREIGN KEY (`menu_parent_id`) REFERENCES `permission` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES ('1', '写博客', '/zsblogs/menu/blogList/blog/user/edit', 'GET', 'menu', '博客', null, '1', null);
INSERT INTO `permission` VALUES ('2', '博客栏目', '/zsblogs/menu/user/blogList', 'GET', 'menu', '博客', null, '2', null);
INSERT INTO `permission` VALUES ('3', '最新博客', '/zsblogs/menu/blogList/blog', 'GET', 'menu', '博客', null, '3', null);
INSERT INTO `permission` VALUES ('4', '查看博客', '/zsblogs/menu/blogList/blog/one', 'GET', 'menu', '博客', null, '4', null);
INSERT INTO `permission` VALUES ('5', '博客栏目分页查询', '/zsblogs/api/blogList/list', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('6', '博客栏目单条查询', '/zsblogs/api/blogList/one', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('7', '博客栏目单条添加', '/zsblogs/api/blogList', 'POST', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('8', '博客栏目单条修改', '/zsblogs/api/blogList', 'PUT', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('9', '博客栏目单条删除', '/zsblogs/api/blogList/one', 'DELETE', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('10', '查询自己所有的博客栏目', '/zsblogs/api/blogList/user/all', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('11', '博客分页查询', '/zsblogs/api/blog/list', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('12', '博客单条查询', '/zsblogs/api/blog/one', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('13', '博客单条添加', '/zsblogs/api/blog', 'POST', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('14', '博客单条修改', '/zsblogs/api/blog', 'PUT', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('15', '博客单条删除', '/zsblogs/api/blog/one', 'DELETE', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('16', '博客评论分页查询', '/zsblogs/api/blogComment/list', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('17', '博客评论单条查询', '/zsblogs/api/blogComment/one', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('18', '博客评论添加', '/zsblogs/api/blogComment', 'POST', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('19', '博客评论单条修改', '/zsblogs/api/blogComment', 'PUT', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('20', '博客评论单条删除', '/zsblogs/api/blogComment/one', 'DELETE', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('21', '我的博客', '/zsblogs/menu/user/blog', 'GET', 'menu', '博客', null, '5', null);
INSERT INTO `permission` VALUES ('22', '我的信息', '/zsblogs/menu/system/users/own', 'GET', 'menu', '系统', null, '6', null);
INSERT INTO `permission` VALUES ('23', '用户信息分页查询', '/zsblogs/menu/system/users/list', 'GET', 'api', '系统', null, null, null);
INSERT INTO `permission` VALUES ('24', '用户信息单条查询', '/zsblogs/menu/system/users/one', 'GET', 'api', '系统', null, null, null);
INSERT INTO `permission` VALUES ('25', '用户信息单条添加', '/zsblogs/menu/system/users', 'POST', 'api', '系统', null, null, null);
INSERT INTO `permission` VALUES ('26', '用户信息单条修改', '/zsblogs/menu/system/users', 'PUT', 'api', '系统', null, null, null);
INSERT INTO `permission` VALUES ('27', '用户信息单条删除', '/zsblogs/menu/system/users/one', 'DELETE', 'api', '系统', null, null, null);

-- ----------------------------
-- Table structure for `read`
-- ----------------------------
DROP TABLE IF EXISTS `read`;
CREATE TABLE `read` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` int(11) DEFAULT NULL,
  `b_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `u_id` (`u_id`),
  KEY `b_id` (`b_id`),
  CONSTRAINT `read_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`),
  CONSTRAINT `read_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of read
-- ----------------------------
INSERT INTO `read` VALUES ('1', '1', '8', '2017-10-21 17:14:50');
INSERT INTO `read` VALUES ('2', '1', '8', '2017-10-21 17:14:52');
INSERT INTO `read` VALUES ('3', '1', '9', '2017-10-21 17:14:55');
INSERT INTO `read` VALUES ('4', '1', '8', '2017-10-21 17:15:01');
INSERT INTO `read` VALUES ('5', '1', '10', '2017-10-21 17:15:07');
INSERT INTO `read` VALUES ('6', '1', '10', '2017-10-21 17:15:16');
INSERT INTO `read` VALUES ('7', '1', '10', '2017-10-21 17:15:32');
INSERT INTO `read` VALUES ('8', '1', '10', '2017-10-21 17:17:41');
INSERT INTO `read` VALUES ('9', '1', '10', '2017-10-21 17:18:42');
INSERT INTO `read` VALUES ('10', '1', '10', '2017-10-21 17:19:34');
INSERT INTO `read` VALUES ('11', '1', '10', '2017-10-21 17:20:01');
INSERT INTO `read` VALUES ('12', '1', '10', '2017-10-21 17:20:06');
INSERT INTO `read` VALUES ('13', '1', '10', '2017-10-21 17:20:08');
INSERT INTO `read` VALUES ('14', '1', '10', '2017-10-21 17:20:08');
INSERT INTO `read` VALUES ('15', '1', '10', '2017-10-21 17:20:11');
INSERT INTO `read` VALUES ('16', '1', '10', '2017-10-21 17:20:12');
INSERT INTO `read` VALUES ('17', '1', '10', '2017-10-21 17:20:13');
INSERT INTO `read` VALUES ('18', '1', '10', '2017-10-21 17:20:13');
INSERT INTO `read` VALUES ('19', '1', '10', '2017-10-21 17:20:14');
INSERT INTO `read` VALUES ('20', '1', '10', '2017-10-21 17:20:15');
INSERT INTO `read` VALUES ('21', '1', '10', '2017-10-21 17:20:15');
INSERT INTO `read` VALUES ('22', '1', '10', '2017-10-21 17:20:16');
INSERT INTO `read` VALUES ('23', '1', '10', '2017-10-21 17:20:20');
INSERT INTO `read` VALUES ('24', '1', '10', '2017-10-21 17:20:21');
INSERT INTO `read` VALUES ('25', '1', '10', '2017-10-21 17:20:22');
INSERT INTO `read` VALUES ('26', '1', '10', '2017-10-21 17:20:23');
INSERT INTO `read` VALUES ('27', '1', '10', '2017-10-21 17:20:25');
INSERT INTO `read` VALUES ('28', '1', '10', '2017-10-21 17:20:26');
INSERT INTO `read` VALUES ('29', '1', '10', '2017-10-21 17:20:26');
INSERT INTO `read` VALUES ('30', '1', '10', '2017-10-21 17:20:27');
INSERT INTO `read` VALUES ('31', '1', '10', '2017-10-21 17:20:27');
INSERT INTO `read` VALUES ('32', '1', '10', '2017-10-21 17:20:28');
INSERT INTO `read` VALUES ('33', '1', '10', '2017-10-21 17:20:28');
INSERT INTO `read` VALUES ('34', '1', '10', '2017-10-21 17:20:29');
INSERT INTO `read` VALUES ('35', '1', '10', '2017-10-21 17:20:29');
INSERT INTO `read` VALUES ('36', '1', '10', '2017-10-21 17:20:30');
INSERT INTO `read` VALUES ('37', '1', '10', '2017-10-21 17:20:31');
INSERT INTO `read` VALUES ('38', '1', '10', '2017-10-21 17:20:31');
INSERT INTO `read` VALUES ('39', '1', '10', '2017-10-21 17:20:32');
INSERT INTO `read` VALUES ('40', '1', '10', '2017-10-21 17:20:52');
INSERT INTO `read` VALUES ('41', '1', '10', '2017-10-21 17:20:53');
INSERT INTO `read` VALUES ('42', '1', '10', '2017-10-21 17:20:54');
INSERT INTO `read` VALUES ('43', '1', '10', '2017-10-21 17:20:55');
INSERT INTO `read` VALUES ('44', '1', '5', '2017-10-21 17:21:05');
INSERT INTO `read` VALUES ('45', '1', '5', '2017-10-21 17:21:09');
INSERT INTO `read` VALUES ('46', '1', '5', '2017-10-21 17:21:13');
INSERT INTO `read` VALUES ('47', '1', '5', '2017-10-21 17:21:17');
INSERT INTO `read` VALUES ('48', '1', '5', '2017-10-21 17:22:33');
INSERT INTO `read` VALUES ('49', '1', '2', '2017-10-21 17:24:55');
INSERT INTO `read` VALUES ('50', '1', '10', '2017-10-21 17:52:16');
INSERT INTO `read` VALUES ('51', '1', '10', '2017-10-21 17:52:35');
INSERT INTO `read` VALUES ('52', '1', '10', '2017-10-21 17:53:07');
INSERT INTO `read` VALUES ('53', '1', '10', '2017-10-21 17:53:24');
INSERT INTO `read` VALUES ('54', '2', '10', '2017-10-24 21:33:53');
INSERT INTO `read` VALUES ('55', '2', '5', '2017-10-24 21:33:59');
INSERT INTO `read` VALUES ('56', '2', '9', '2017-10-24 21:34:06');
INSERT INTO `read` VALUES ('57', '2', '9', '2017-10-24 21:34:20');
INSERT INTO `read` VALUES ('58', '2', '9', '2017-10-24 21:43:48');
INSERT INTO `read` VALUES ('59', '2', '10', '2017-10-24 21:43:51');
INSERT INTO `read` VALUES ('60', '2', '9', '2017-10-24 21:43:54');
INSERT INTO `read` VALUES ('61', '2', '5', '2017-10-24 21:44:00');
INSERT INTO `read` VALUES ('62', '1', '10', '2017-10-24 22:03:37');
INSERT INTO `read` VALUES ('63', '1', '9', '2017-10-24 22:03:41');

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `introduction` varchar(255) DEFAULT NULL,
  `pids` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '开发者', '拥有所有权限', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27');
INSERT INTO `role` VALUES ('2', '博客作者', '拥有写博客的权限', '1,10,2,13');

-- ----------------------------
-- Table structure for `timeline`
-- ----------------------------
DROP TABLE IF EXISTS `timeline`;
CREATE TABLE `timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `u_id` int(11) NOT NULL,
  `p_id` int(11) NOT NULL,
  `create_time` datetime NOT NULL,
  `info` text,
  PRIMARY KEY (`id`),
  KEY `u_id` (`u_id`),
  KEY `p_id` (`p_id`),
  CONSTRAINT `timeline_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`),
  CONSTRAINT `timeline_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `permission` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=871 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of timeline
-- ----------------------------
INSERT INTO `timeline` VALUES ('1', '1', '1', '2017-10-17 15:54:37', '{}');
INSERT INTO `timeline` VALUES ('2', '1', '1', '2017-10-17 15:54:54', '{}');
INSERT INTO `timeline` VALUES ('3', '1', '1', '2017-10-17 16:10:23', '{}');
INSERT INTO `timeline` VALUES ('4', '1', '1', '2017-10-17 16:12:07', '{}');
INSERT INTO `timeline` VALUES ('6', '1', '1', '2017-10-17 16:16:58', '{}');
INSERT INTO `timeline` VALUES ('7', '1', '10', '2017-10-17 16:16:59', '{}');
INSERT INTO `timeline` VALUES ('8', '1', '1', '2017-10-17 16:18:54', '{}');
INSERT INTO `timeline` VALUES ('9', '1', '10', '2017-10-17 16:18:54', '{}');
INSERT INTO `timeline` VALUES ('10', '1', '1', '2017-10-17 16:23:41', '{}');
INSERT INTO `timeline` VALUES ('11', '1', '10', '2017-10-17 16:23:41', '{}');
INSERT INTO `timeline` VALUES ('12', '1', '1', '2017-10-17 16:25:17', '{}');
INSERT INTO `timeline` VALUES ('13', '1', '10', '2017-10-17 16:25:17', '{}');
INSERT INTO `timeline` VALUES ('14', '1', '1', '2017-10-17 16:30:45', '{}');
INSERT INTO `timeline` VALUES ('15', '1', '10', '2017-10-17 16:30:45', '{}');
INSERT INTO `timeline` VALUES ('16', '1', '1', '2017-10-17 16:30:52', '{}');
INSERT INTO `timeline` VALUES ('17', '1', '1', '2017-10-17 16:31:14', '{}');
INSERT INTO `timeline` VALUES ('18', '1', '1', '2017-10-17 16:31:26', '{}');
INSERT INTO `timeline` VALUES ('19', '1', '1', '2017-10-17 16:31:33', '{}');
INSERT INTO `timeline` VALUES ('20', '1', '10', '2017-10-17 16:31:33', '{}');
INSERT INTO `timeline` VALUES ('21', '1', '1', '2017-10-17 16:31:34', '{}');
INSERT INTO `timeline` VALUES ('22', '1', '10', '2017-10-17 16:31:34', '{}');
INSERT INTO `timeline` VALUES ('23', '1', '1', '2017-10-17 16:31:34', '{}');
INSERT INTO `timeline` VALUES ('24', '1', '10', '2017-10-17 16:31:35', '{}');
INSERT INTO `timeline` VALUES ('25', '1', '1', '2017-10-17 16:31:35', '{}');
INSERT INTO `timeline` VALUES ('26', '1', '10', '2017-10-17 16:31:35', '{}');
INSERT INTO `timeline` VALUES ('27', '1', '1', '2017-10-17 16:32:02', '{}');
INSERT INTO `timeline` VALUES ('28', '1', '10', '2017-10-17 16:32:03', '{}');
INSERT INTO `timeline` VALUES ('29', '1', '1', '2017-10-17 16:32:11', '{}');
INSERT INTO `timeline` VALUES ('30', '1', '1', '2017-10-17 16:32:27', '{}');
INSERT INTO `timeline` VALUES ('31', '1', '1', '2017-10-17 17:19:58', '{}');
INSERT INTO `timeline` VALUES ('32', '1', '10', '2017-10-17 17:19:58', '{}');
INSERT INTO `timeline` VALUES ('33', '1', '1', '2017-10-17 17:23:31', '{}');
INSERT INTO `timeline` VALUES ('34', '1', '10', '2017-10-17 17:23:32', '{}');
INSERT INTO `timeline` VALUES ('35', '1', '1', '2017-10-17 17:24:32', '{}');
INSERT INTO `timeline` VALUES ('36', '1', '10', '2017-10-17 17:24:32', '{}');
INSERT INTO `timeline` VALUES ('37', '1', '1', '2017-10-17 17:25:05', '{}');
INSERT INTO `timeline` VALUES ('38', '1', '10', '2017-10-17 17:25:05', '{}');
INSERT INTO `timeline` VALUES ('39', '1', '1', '2017-10-17 17:25:45', '{}');
INSERT INTO `timeline` VALUES ('40', '1', '10', '2017-10-17 17:25:45', '{}');
INSERT INTO `timeline` VALUES ('41', '1', '1', '2017-10-17 17:27:07', '{}');
INSERT INTO `timeline` VALUES ('42', '1', '10', '2017-10-17 17:27:07', '{}');
INSERT INTO `timeline` VALUES ('43', '1', '1', '2017-10-17 17:28:19', '{}');
INSERT INTO `timeline` VALUES ('44', '1', '10', '2017-10-17 17:28:19', '{}');
INSERT INTO `timeline` VALUES ('45', '1', '1', '2017-10-17 17:28:31', '{}');
INSERT INTO `timeline` VALUES ('46', '1', '10', '2017-10-17 17:28:31', '{}');
INSERT INTO `timeline` VALUES ('47', '1', '1', '2017-10-17 17:29:28', '{}');
INSERT INTO `timeline` VALUES ('48', '1', '10', '2017-10-17 17:29:28', '{}');
INSERT INTO `timeline` VALUES ('49', '1', '1', '2017-10-17 17:31:23', '{}');
INSERT INTO `timeline` VALUES ('50', '1', '10', '2017-10-17 17:31:23', '{}');
INSERT INTO `timeline` VALUES ('51', '1', '1', '2017-10-17 17:32:46', '{}');
INSERT INTO `timeline` VALUES ('52', '1', '10', '2017-10-17 17:32:47', '{}');
INSERT INTO `timeline` VALUES ('53', '1', '1', '2017-10-18 10:43:35', '{}');
INSERT INTO `timeline` VALUES ('54', '1', '10', '2017-10-18 10:43:35', '{}');
INSERT INTO `timeline` VALUES ('55', '1', '2', '2017-10-18 10:43:36', '{}');
INSERT INTO `timeline` VALUES ('56', '1', '1', '2017-10-18 10:43:40', '{}');
INSERT INTO `timeline` VALUES ('57', '1', '10', '2017-10-18 10:43:40', '{}');
INSERT INTO `timeline` VALUES ('58', '1', '1', '2017-10-18 14:13:17', '{}');
INSERT INTO `timeline` VALUES ('59', '1', '10', '2017-10-18 14:13:17', '{}');
INSERT INTO `timeline` VALUES ('60', '1', '1', '2017-10-18 14:13:37', '{}');
INSERT INTO `timeline` VALUES ('61', '1', '10', '2017-10-18 14:13:37', '{}');
INSERT INTO `timeline` VALUES ('62', '1', '1', '2017-10-18 14:13:48', '{}');
INSERT INTO `timeline` VALUES ('63', '1', '10', '2017-10-18 14:13:48', '{}');
INSERT INTO `timeline` VALUES ('64', '1', '1', '2017-10-18 14:13:49', '{}');
INSERT INTO `timeline` VALUES ('65', '1', '10', '2017-10-18 14:13:49', '{}');
INSERT INTO `timeline` VALUES ('66', '1', '1', '2017-10-18 14:13:56', '{}');
INSERT INTO `timeline` VALUES ('67', '1', '10', '2017-10-18 14:13:56', '{}');
INSERT INTO `timeline` VALUES ('68', '1', '1', '2017-10-18 14:16:27', '{}');
INSERT INTO `timeline` VALUES ('69', '1', '10', '2017-10-18 14:16:28', '{}');
INSERT INTO `timeline` VALUES ('70', '1', '1', '2017-10-18 14:18:33', '{}');
INSERT INTO `timeline` VALUES ('71', '1', '10', '2017-10-18 14:18:33', '{}');
INSERT INTO `timeline` VALUES ('72', '1', '1', '2017-10-18 14:35:53', '{}');
INSERT INTO `timeline` VALUES ('73', '1', '1', '2017-10-18 14:36:34', '{}');
INSERT INTO `timeline` VALUES ('74', '1', '10', '2017-10-18 14:36:35', '{}');
INSERT INTO `timeline` VALUES ('75', '1', '1', '2017-10-18 14:37:09', '{}');
INSERT INTO `timeline` VALUES ('76', '1', '10', '2017-10-18 14:37:09', '{}');
INSERT INTO `timeline` VALUES ('77', '1', '1', '2017-10-18 14:48:58', '{}');
INSERT INTO `timeline` VALUES ('78', '1', '10', '2017-10-18 14:48:58', '{}');
INSERT INTO `timeline` VALUES ('79', '1', '1', '2017-10-18 14:49:00', '{}');
INSERT INTO `timeline` VALUES ('80', '1', '10', '2017-10-18 14:49:00', '{}');
INSERT INTO `timeline` VALUES ('81', '1', '13', '2017-10-18 14:50:03', '{\"title\":[\"先测试一篇\"],\"content\":[\"这是一篇测试的文档\"],\"summary\":[\"11111111\"],\"blIds[]\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('82', '1', '13', '2017-10-18 14:51:51', '{\"title\":[\"先测试一篇\"],\"content\":[\"这是一篇测试的文档\"],\"summary\":[\"11111111\"],\"blIds[]\":[\"1\",\"2\"]}');
INSERT INTO `timeline` VALUES ('83', '1', '13', '2017-10-18 14:59:14', '{\"title\":[\"先测试一篇\"],\"content\":[\"这是一篇测试的文档\"],\"summary\":[\"11111111\"],\"blIds[]\":[\"1\",\"2\"]}');
INSERT INTO `timeline` VALUES ('84', '1', '1', '2017-10-18 15:02:21', '{}');
INSERT INTO `timeline` VALUES ('85', '1', '10', '2017-10-18 15:02:22', '{}');
INSERT INTO `timeline` VALUES ('86', '1', '1', '2017-10-18 15:02:32', '{}');
INSERT INTO `timeline` VALUES ('87', '1', '10', '2017-10-18 15:02:32', '{}');
INSERT INTO `timeline` VALUES ('88', '1', '13', '2017-10-18 15:02:42', '{\"title\":[\"111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"33333333333\"],\"blIds[]\":[\"1\",\"2\",\"3\",\"4\"]}');
INSERT INTO `timeline` VALUES ('89', '1', '13', '2017-10-18 15:05:37', '{\"title\":[\"111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"33333333333\"],\"blIds[]\":[\"1\",\"2\",\"3\",\"4\"]}');
INSERT INTO `timeline` VALUES ('90', '1', '1', '2017-10-18 15:07:44', '{}');
INSERT INTO `timeline` VALUES ('91', '1', '10', '2017-10-18 15:07:45', '{}');
INSERT INTO `timeline` VALUES ('92', '1', '13', '2017-10-18 15:07:52', '{\"title\":[\"1111111111111\"],\"content\":[\"2222222222222\"],\"summary\":[\"33333333333\"],\"blIds[]\":[\"1\",\"2\"],\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('93', '1', '13', '2017-10-18 15:08:30', '{\"title\":[\"1111111111111\"],\"content\":[\"2222222222222\"],\"summary\":[\"33333333333\"],\"blIds[]\":[\"1\"],\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('94', '1', '1', '2017-10-18 15:09:13', '{}');
INSERT INTO `timeline` VALUES ('95', '1', '10', '2017-10-18 15:09:14', '{}');
INSERT INTO `timeline` VALUES ('96', '1', '13', '2017-10-18 15:09:18', '{\"title\":[\"1\"],\"content\":[\"11\"],\"summary\":[\"2\"],\"blIds\":[\"\"],\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('97', '1', '1', '2017-10-18 15:11:54', '{}');
INSERT INTO `timeline` VALUES ('98', '1', '10', '2017-10-18 15:11:54', '{}');
INSERT INTO `timeline` VALUES ('99', '1', '13', '2017-10-18 15:12:07', '{\"title\":[\"111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"333333333\"],\"blIds\":[\"\"],\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('100', '1', '1', '2017-10-18 15:14:30', '{}');
INSERT INTO `timeline` VALUES ('101', '1', '10', '2017-10-18 15:14:31', '{}');
INSERT INTO `timeline` VALUES ('102', '1', '13', '2017-10-18 15:14:39', '{\"title\":[\"1111111111111111\"],\"content\":[\"2222222222222\"],\"summary\":[\"3333333333333\"],\"blIds[]\":[\"2\",\"3\",\"4\"]}');
INSERT INTO `timeline` VALUES ('103', '1', '1', '2017-10-18 15:15:13', '{}');
INSERT INTO `timeline` VALUES ('104', '1', '10', '2017-10-18 15:15:13', '{}');
INSERT INTO `timeline` VALUES ('105', '1', '13', '2017-10-18 15:15:23', '{\"title\":[\"111111111\"],\"content\":[\"2222222\"],\"summary\":[\"3333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('106', '1', '13', '2017-10-18 15:24:29', '{\"title\":[\"111111111\"],\"content\":[\"2222222\"],\"summary\":[\"3333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('107', '1', '13', '2017-10-18 15:28:35', '{\"title\":[\"111111111\"],\"content\":[\"2222222\"],\"summary\":[\"3333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('108', '1', '1', '2017-10-18 15:36:40', '{}');
INSERT INTO `timeline` VALUES ('109', '1', '10', '2017-10-18 15:36:40', '{}');
INSERT INTO `timeline` VALUES ('110', '1', '13', '2017-10-18 15:36:49', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"3333333333\"],\"blIds[]\":[\"1\",\"2\",\"3\",\"4\"]}');
INSERT INTO `timeline` VALUES ('111', '1', '1', '2017-10-18 15:40:36', '{}');
INSERT INTO `timeline` VALUES ('112', '1', '10', '2017-10-18 15:40:36', '{}');
INSERT INTO `timeline` VALUES ('113', '1', '1', '2017-10-18 15:40:37', '{}');
INSERT INTO `timeline` VALUES ('114', '1', '10', '2017-10-18 15:40:37', '{}');
INSERT INTO `timeline` VALUES ('115', '1', '13', '2017-10-18 15:40:45', '{}');
INSERT INTO `timeline` VALUES ('116', '1', '1', '2017-10-18 15:41:52', '{}');
INSERT INTO `timeline` VALUES ('117', '1', '10', '2017-10-18 15:41:52', '{}');
INSERT INTO `timeline` VALUES ('118', '1', '13', '2017-10-18 15:41:59', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"333333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('119', '1', '13', '2017-10-18 15:44:19', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"333333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('120', '1', '13', '2017-10-18 15:44:57', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"333333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('121', '1', '13', '2017-10-18 15:45:08', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"333333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('122', '1', '13', '2017-10-18 15:47:04', '{\"title\":[\"1111111111\"],\"content\":[\"22222222222222\"],\"summary\":[\"333333333333\"],\"blIds[]\":[\"2\",\"3\"]}');
INSERT INTO `timeline` VALUES ('123', '1', '1', '2017-10-18 15:49:35', '{}');
INSERT INTO `timeline` VALUES ('124', '1', '10', '2017-10-18 15:49:35', '{}');
INSERT INTO `timeline` VALUES ('125', '1', '13', '2017-10-18 15:49:41', '{\"title\":[\"1111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"3333333\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('126', '1', '13', '2017-10-18 15:51:25', '{\"title\":[\"1111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"3333333\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('127', '1', '13', '2017-10-18 15:57:38', '{\"title\":[\"1111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"3333333\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('128', '1', '13', '2017-10-18 15:58:15', '{\"title\":[\"1111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"3333333\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('129', '1', '13', '2017-10-18 15:59:13', '{\"title\":[\"1111111111\"],\"content\":[\"2222222222\"],\"summary\":[\"3333333\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('130', '1', '1', '2017-10-18 16:03:19', '{}');
INSERT INTO `timeline` VALUES ('131', '1', '10', '2017-10-18 16:03:19', '{}');
INSERT INTO `timeline` VALUES ('132', '1', '13', '2017-10-18 16:03:24', '{\"title\":[\"222222222222\"],\"content\":[\"33333\"],\"summary\":[\"33344444\"],\"blIds\":[\"[\\\"2\\\",\\\"3\\\"]\"]}');
INSERT INTO `timeline` VALUES ('133', '1', '2', '2017-10-18 16:07:40', '{}');
INSERT INTO `timeline` VALUES ('134', '1', '2', '2017-10-18 16:08:49', '{}');
INSERT INTO `timeline` VALUES ('135', '1', '5', '2017-10-18 16:08:50', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('136', '1', '2', '2017-10-18 16:09:31', '{}');
INSERT INTO `timeline` VALUES ('137', '1', '5', '2017-10-18 16:09:33', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('138', '1', '2', '2017-10-18 16:12:28', '{}');
INSERT INTO `timeline` VALUES ('139', '1', '5', '2017-10-18 16:12:30', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('140', '1', '2', '2017-10-18 16:12:48', '{}');
INSERT INTO `timeline` VALUES ('141', '1', '5', '2017-10-18 16:12:50', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('142', '1', '5', '2017-10-18 16:12:52', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"blOrder\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('143', '1', '5', '2017-10-18 16:12:53', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"blOrder\"],\"order\":[\"desc\"]}');
INSERT INTO `timeline` VALUES ('144', '1', '5', '2017-10-18 16:12:54', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"blOrder\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('145', '1', '2', '2017-10-18 16:15:11', '{}');
INSERT INTO `timeline` VALUES ('146', '1', '2', '2017-10-18 16:15:13', '{}');
INSERT INTO `timeline` VALUES ('147', '1', '5', '2017-10-18 16:15:14', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('148', '1', '2', '2017-10-18 16:16:21', '{}');
INSERT INTO `timeline` VALUES ('149', '1', '2', '2017-10-18 16:16:32', '{}');
INSERT INTO `timeline` VALUES ('150', '1', '2', '2017-10-18 16:16:33', '{}');
INSERT INTO `timeline` VALUES ('151', '1', '2', '2017-10-18 16:16:45', '{}');
INSERT INTO `timeline` VALUES ('152', '1', '2', '2017-10-18 16:17:28', '{}');
INSERT INTO `timeline` VALUES ('153', '1', '5', '2017-10-18 16:17:37', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('154', '1', '2', '2017-10-18 16:50:33', '{}');
INSERT INTO `timeline` VALUES ('155', '1', '5', '2017-10-18 16:50:34', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('156', '1', '5', '2017-10-18 16:50:38', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"name\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('157', '1', '5', '2017-10-18 16:50:40', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"name\"],\"order\":[\"desc\"]}');
INSERT INTO `timeline` VALUES ('158', '1', '5', '2017-10-18 16:50:40', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"id\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('159', '1', '5', '2017-10-18 16:50:41', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"id\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('160', '1', '2', '2017-10-18 16:52:51', '{}');
INSERT INTO `timeline` VALUES ('161', '1', '5', '2017-10-18 16:52:53', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('162', '1', '2', '2017-10-18 16:53:14', '{}');
INSERT INTO `timeline` VALUES ('163', '1', '5', '2017-10-18 16:55:17', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('164', '1', '2', '2017-10-18 16:55:24', '{}');
INSERT INTO `timeline` VALUES ('165', '1', '1', '2017-10-18 16:55:25', '{}');
INSERT INTO `timeline` VALUES ('166', '1', '10', '2017-10-18 16:55:25', '{}');
INSERT INTO `timeline` VALUES ('167', '1', '2', '2017-10-18 17:01:18', '{}');
INSERT INTO `timeline` VALUES ('168', '1', '5', '2017-10-18 17:01:20', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('169', '1', '7', '2017-10-18 17:01:33', '{\"_method\":[\"post\"],\"_token\":[\"181650253275604\"],\"name\":[\"java web\"],\"blOrder\":[\"5\"]}');
INSERT INTO `timeline` VALUES ('170', '1', '5', '2017-10-18 17:01:34', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('171', '1', '5', '2017-10-18 17:03:22', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('172', '1', '8', '2017-10-18 17:03:52', '{\"_method\":[\"put\"],\"_token\":[\"181650253275604\"],\"name\":[\"java web\"],\"blOrder\":[\"6\"]}');
INSERT INTO `timeline` VALUES ('173', '1', '5', '2017-10-18 17:03:52', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('174', '1', '8', '2017-10-18 17:04:10', '{\"_method\":[\"put\"],\"_token\":[\"181650253275604\"],\"name\":[\"java web\"],\"blOrder\":[\"6\"]}');
INSERT INTO `timeline` VALUES ('175', '1', '5', '2017-10-18 17:04:10', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('176', '1', '2', '2017-10-18 17:05:40', '{}');
INSERT INTO `timeline` VALUES ('177', '1', '5', '2017-10-18 17:05:43', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('178', '1', '8', '2017-10-18 17:05:49', '{\"_method\":[\"put\"],\"_token\":[\"181650253275604\"],\"id\":[\"5\"],\"name\":[\"java web\"],\"blOrder\":[\"6\"]}');
INSERT INTO `timeline` VALUES ('179', '1', '5', '2017-10-18 17:05:49', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('180', '1', '8', '2017-10-18 17:05:55', '{\"_method\":[\"put\"],\"_token\":[\"181650253275604\"],\"id\":[\"5\"],\"name\":[\"java web1\"],\"blOrder\":[\"6\"]}');
INSERT INTO `timeline` VALUES ('181', '1', '5', '2017-10-18 17:05:55', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('182', '1', '8', '2017-10-18 17:06:01', '{\"_method\":[\"put\"],\"_token\":[\"181650253275604\"],\"id\":[\"5\"],\"name\":[\"java web\"],\"blOrder\":[\"5\"]}');
INSERT INTO `timeline` VALUES ('183', '1', '5', '2017-10-18 17:06:02', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('184', '1', '2', '2017-10-18 17:30:10', '{}');
INSERT INTO `timeline` VALUES ('185', '1', '5', '2017-10-18 17:30:12', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('186', '1', '2', '2017-10-18 17:31:30', '{}');
INSERT INTO `timeline` VALUES ('187', '1', '5', '2017-10-18 17:31:32', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('188', '1', '2', '2017-10-18 17:35:45', '{}');
INSERT INTO `timeline` VALUES ('189', '1', '5', '2017-10-18 17:35:46', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('190', '2', '2', '2017-10-18 17:36:00', '{}');
INSERT INTO `timeline` VALUES ('191', '2', '5', '2017-10-18 17:36:01', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('192', '1', '2', '2017-10-18 17:36:12', '{}');
INSERT INTO `timeline` VALUES ('193', '1', '5', '2017-10-18 17:36:13', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('194', '1', '1', '2017-10-18 17:36:33', '{}');
INSERT INTO `timeline` VALUES ('195', '1', '10', '2017-10-18 17:36:33', '{}');
INSERT INTO `timeline` VALUES ('196', '2', '1', '2017-10-18 17:36:46', '{}');
INSERT INTO `timeline` VALUES ('197', '2', '10', '2017-10-18 17:36:47', '{}');
INSERT INTO `timeline` VALUES ('198', '2', '2', '2017-10-18 17:39:47', '{}');
INSERT INTO `timeline` VALUES ('199', '2', '2', '2017-10-18 17:39:49', '{}');
INSERT INTO `timeline` VALUES ('200', '2', '2', '2017-10-18 17:56:14', '{}');
INSERT INTO `timeline` VALUES ('201', '2', '2', '2017-10-18 18:02:10', '{}');
INSERT INTO `timeline` VALUES ('202', '2', '5', '2017-10-18 18:02:12', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('203', '2', '2', '2017-10-19 11:30:22', '{}');
INSERT INTO `timeline` VALUES ('204', '2', '5', '2017-10-19 11:30:23', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('205', '2', '1', '2017-10-19 14:30:04', '{}');
INSERT INTO `timeline` VALUES ('206', '2', '10', '2017-10-19 14:30:04', '{}');
INSERT INTO `timeline` VALUES ('207', '2', '2', '2017-10-19 14:30:05', '{}');
INSERT INTO `timeline` VALUES ('208', '2', '5', '2017-10-19 14:30:06', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('209', '2', '1', '2017-10-19 14:30:11', '{}');
INSERT INTO `timeline` VALUES ('210', '2', '10', '2017-10-19 14:30:12', '{}');
INSERT INTO `timeline` VALUES ('211', '2', '16', '2017-10-19 15:38:59', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('212', '2', '16', '2017-10-19 15:39:55', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('213', '2', '16', '2017-10-19 16:13:29', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('214', '2', '16', '2017-10-19 16:15:24', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('215', '2', '12', '2017-10-19 16:26:42', '{}');
INSERT INTO `timeline` VALUES ('216', '2', '16', '2017-10-19 16:28:47', '{}');
INSERT INTO `timeline` VALUES ('217', '2', '16', '2017-10-19 16:31:06', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('218', '2', '16', '2017-10-19 16:35:42', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('219', '2', '2', '2017-10-19 16:36:04', '{}');
INSERT INTO `timeline` VALUES ('220', '2', '5', '2017-10-19 16:36:06', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('221', '1', '2', '2017-10-19 16:36:14', '{}');
INSERT INTO `timeline` VALUES ('222', '1', '5', '2017-10-19 16:36:15', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('223', '1', '12', '2017-10-19 16:36:52', '{}');
INSERT INTO `timeline` VALUES ('224', '1', '16', '2017-10-19 16:39:02', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('225', '1', '16', '2017-10-19 16:39:09', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('226', '1', '16', '2017-10-19 16:39:10', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('227', '1', '16', '2017-10-19 16:39:12', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('228', '1', '16', '2017-10-19 16:39:13', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('229', '1', '2', '2017-10-19 16:39:17', '{}');
INSERT INTO `timeline` VALUES ('230', '1', '5', '2017-10-19 16:39:18', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('231', '1', '16', '2017-10-19 16:39:22', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('232', '1', '16', '2017-10-19 16:43:07', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('233', '1', '16', '2017-10-19 16:43:41', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('234', '1', '16', '2017-10-19 16:47:44', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('235', '1', '16', '2017-10-19 17:10:26', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('236', '1', '16', '2017-10-19 17:12:03', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('237', '1', '16', '2017-10-19 17:12:20', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('238', '1', '16', '2017-10-19 17:13:26', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('239', '1', '16', '2017-10-19 17:13:38', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('240', '1', '16', '2017-10-19 17:13:46', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('241', '1', '16', '2017-10-19 17:20:10', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('242', '1', '18', '2017-10-19 17:20:17', '{\"content\":[\"测试一下\"],\"bId\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('243', '1', '16', '2017-10-19 17:20:47', '{\"page\":[\"1\"],\"rows\":[\"20\"],\"int1\":[\"9\"]}');
INSERT INTO `timeline` VALUES ('244', '1', '2', '2017-10-19 20:35:02', '{}');
INSERT INTO `timeline` VALUES ('245', '1', '5', '2017-10-19 20:35:04', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('246', '1', '1', '2017-10-19 20:45:14', '{}');
INSERT INTO `timeline` VALUES ('247', '1', '10', '2017-10-19 20:45:14', '{}');
INSERT INTO `timeline` VALUES ('248', '1', '2', '2017-10-19 20:45:36', '{}');
INSERT INTO `timeline` VALUES ('249', '1', '5', '2017-10-19 20:45:37', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('250', '1', '2', '2017-10-19 20:46:27', '{}');
INSERT INTO `timeline` VALUES ('251', '1', '5', '2017-10-19 20:48:32', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('252', '1', '5', '2017-10-19 20:48:38', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"uId\"],\"order\":[\"asc\"]}');
INSERT INTO `timeline` VALUES ('253', '1', '5', '2017-10-19 20:48:38', '{\"page\":[\"1\"],\"rows\":[\"25\"],\"sort\":[\"uId\"],\"order\":[\"desc\"]}');
INSERT INTO `timeline` VALUES ('254', '1', '2', '2017-10-19 20:49:06', '{}');
INSERT INTO `timeline` VALUES ('255', '1', '5', '2017-10-19 20:49:07', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('256', '1', '2', '2017-10-20 09:07:59', '{}');
INSERT INTO `timeline` VALUES ('257', '1', '5', '2017-10-20 09:08:00', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('258', '1', '2', '2017-10-20 09:09:04', '{}');
INSERT INTO `timeline` VALUES ('259', '1', '2', '2017-10-20 09:11:26', '{}');
INSERT INTO `timeline` VALUES ('260', '1', '5', '2017-10-20 09:11:28', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('261', '1', '5', '2017-10-20 09:11:30', '{\"int2\":[\"1\"],\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('262', '1', '5', '2017-10-20 09:11:33', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('263', '1', '5', '2017-10-20 09:11:41', '{\"str1\":[\"设计\"],\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('264', '1', '5', '2017-10-20 09:11:44', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('265', '1', '2', '2017-10-20 09:12:57', '{}');
INSERT INTO `timeline` VALUES ('266', '1', '5', '2017-10-20 09:13:05', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('267', '1', '5', '2017-10-20 09:13:18', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('268', '1', '7', '2017-10-20 09:14:44', '{\"_method\":[\"post\"],\"_token\":[\"20911198383563\"],\"id\":[\"\"],\"name\":[\"11111\"],\"blOrder\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('269', '1', '5', '2017-10-20 09:14:45', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('270', '1', '9', '2017-10-20 09:14:48', '{\"id\":[\"undefined\"]}');
INSERT INTO `timeline` VALUES ('271', '1', '2', '2017-10-20 09:14:52', '{}');
INSERT INTO `timeline` VALUES ('272', '1', '5', '2017-10-20 09:14:54', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('273', '1', '9', '2017-10-20 09:14:56', '{\"id\":[\"6\"]}');
INSERT INTO `timeline` VALUES ('274', '1', '5', '2017-10-20 09:14:56', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('275', '1', '21', '2017-10-20 11:04:00', '{}');
INSERT INTO `timeline` VALUES ('276', '1', '21', '2017-10-20 11:04:09', '{}');
INSERT INTO `timeline` VALUES ('277', '1', '21', '2017-10-20 11:06:19', '{}');
INSERT INTO `timeline` VALUES ('278', '1', '21', '2017-10-20 11:06:27', '{}');
INSERT INTO `timeline` VALUES ('279', '1', '21', '2017-10-20 11:09:03', '{}');
INSERT INTO `timeline` VALUES ('280', '1', '2', '2017-10-20 11:09:33', '{}');
INSERT INTO `timeline` VALUES ('281', '1', '2', '2017-10-20 11:09:35', '{}');
INSERT INTO `timeline` VALUES ('282', '1', '2', '2017-10-20 11:10:25', '{}');
INSERT INTO `timeline` VALUES ('283', '1', '5', '2017-10-20 11:10:26', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('284', '1', '2', '2017-10-20 11:10:51', '{}');
INSERT INTO `timeline` VALUES ('285', '1', '2', '2017-10-20 11:10:52', '{}');
INSERT INTO `timeline` VALUES ('286', '1', '5', '2017-10-20 11:10:52', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('287', '1', '5', '2017-10-20 11:11:17', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('288', '1', '2', '2017-10-20 11:11:20', '{}');
INSERT INTO `timeline` VALUES ('289', '1', '2', '2017-10-20 11:11:22', '{}');
INSERT INTO `timeline` VALUES ('290', '1', '5', '2017-10-20 11:11:23', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('291', '1', '2', '2017-10-20 11:11:37', '{}');
INSERT INTO `timeline` VALUES ('292', '1', '5', '2017-10-20 11:11:38', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('293', '1', '21', '2017-10-20 11:13:45', '{}');
INSERT INTO `timeline` VALUES ('294', '1', '2', '2017-10-20 11:14:31', '{}');
INSERT INTO `timeline` VALUES ('295', '1', '5', '2017-10-20 11:14:34', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('296', '1', '21', '2017-10-20 11:14:36', '{}');
INSERT INTO `timeline` VALUES ('297', '1', '2', '2017-10-20 11:14:38', '{}');
INSERT INTO `timeline` VALUES ('298', '1', '5', '2017-10-20 11:14:39', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('299', '1', '2', '2017-10-20 11:15:37', '{}');
INSERT INTO `timeline` VALUES ('300', '1', '5', '2017-10-20 11:15:38', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('301', '1', '2', '2017-10-20 11:16:12', '{}');
INSERT INTO `timeline` VALUES ('302', '1', '2', '2017-10-20 11:16:16', '{}');
INSERT INTO `timeline` VALUES ('303', '1', '2', '2017-10-20 11:16:41', '{}');
INSERT INTO `timeline` VALUES ('304', '1', '5', '2017-10-20 11:16:43', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('305', '1', '21', '2017-10-20 11:16:58', '{}');
INSERT INTO `timeline` VALUES ('306', '1', '2', '2017-10-20 11:17:06', '{}');
INSERT INTO `timeline` VALUES ('307', '1', '5', '2017-10-20 11:17:07', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('308', '1', '2', '2017-10-20 11:19:14', '{}');
INSERT INTO `timeline` VALUES ('309', '1', '5', '2017-10-20 11:19:16', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('310', '1', '2', '2017-10-20 11:20:40', '{}');
INSERT INTO `timeline` VALUES ('311', '1', '5', '2017-10-20 11:20:41', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('312', '1', '2', '2017-10-20 11:21:37', '{}');
INSERT INTO `timeline` VALUES ('313', '1', '5', '2017-10-20 11:21:40', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('314', '1', '21', '2017-10-20 11:21:41', '{\"int2\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('315', '1', '2', '2017-10-20 11:26:41', '{}');
INSERT INTO `timeline` VALUES ('316', '1', '5', '2017-10-20 11:26:44', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('317', '1', '21', '2017-10-20 11:26:46', '{\"int2\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('318', '1', '21', '2017-10-20 11:28:18', '{\"int2\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('319', '1', '21', '2017-10-20 11:29:08', '{\"int2\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('320', '1', '2', '2017-10-20 11:29:17', '{}');
INSERT INTO `timeline` VALUES ('321', '1', '5', '2017-10-20 11:29:18', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('322', '1', '21', '2017-10-20 11:29:20', '{\"int2\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('323', '1', '2', '2017-10-20 11:29:57', '{}');
INSERT INTO `timeline` VALUES ('324', '1', '5', '2017-10-20 11:29:58', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('325', '1', '21', '2017-10-20 11:29:59', '{\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('326', '1', '21', '2017-10-20 11:31:27', '{\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('327', '1', '21', '2017-10-20 11:32:48', '{\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('328', '1', '2', '2017-10-20 11:33:15', '{}');
INSERT INTO `timeline` VALUES ('329', '1', '5', '2017-10-20 11:33:16', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('330', '1', '21', '2017-10-20 11:33:46', '{}');
INSERT INTO `timeline` VALUES ('331', '1', '21', '2017-10-20 11:41:00', '{}');
INSERT INTO `timeline` VALUES ('332', '1', '21', '2017-10-20 11:45:22', '{}');
INSERT INTO `timeline` VALUES ('333', '1', '21', '2017-10-20 11:45:31', '{}');
INSERT INTO `timeline` VALUES ('334', '1', '21', '2017-10-20 11:46:08', '{}');
INSERT INTO `timeline` VALUES ('335', '1', '21', '2017-10-20 11:47:23', '{}');
INSERT INTO `timeline` VALUES ('336', '1', '21', '2017-10-20 15:32:33', '{}');
INSERT INTO `timeline` VALUES ('337', '1', '21', '2017-10-20 15:33:18', '{}');
INSERT INTO `timeline` VALUES ('338', '1', '21', '2017-10-20 15:35:12', '{}');
INSERT INTO `timeline` VALUES ('339', '1', '2', '2017-10-20 15:35:22', '{}');
INSERT INTO `timeline` VALUES ('340', '1', '2', '2017-10-20 15:35:55', '{}');
INSERT INTO `timeline` VALUES ('341', '1', '21', '2017-10-20 15:36:01', '{}');
INSERT INTO `timeline` VALUES ('342', '1', '2', '2017-10-20 15:36:03', '{}');
INSERT INTO `timeline` VALUES ('343', '1', '21', '2017-10-20 15:36:05', '{}');
INSERT INTO `timeline` VALUES ('344', '1', '2', '2017-10-20 15:36:06', '{}');
INSERT INTO `timeline` VALUES ('345', '1', '5', '2017-10-20 15:36:09', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('346', '1', '21', '2017-10-20 15:36:10', '{}');
INSERT INTO `timeline` VALUES ('347', '1', '2', '2017-10-20 15:36:13', '{}');
INSERT INTO `timeline` VALUES ('348', '1', '5', '2017-10-20 15:36:14', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('349', '1', '21', '2017-10-20 15:36:16', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('350', '1', '21', '2017-10-20 15:36:20', '{}');
INSERT INTO `timeline` VALUES ('351', '1', '2', '2017-10-20 15:36:21', '{}');
INSERT INTO `timeline` VALUES ('352', '1', '2', '2017-10-20 15:39:56', '{}');
INSERT INTO `timeline` VALUES ('353', '1', '5', '2017-10-20 15:39:57', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('354', '1', '21', '2017-10-20 15:40:02', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('355', '1', '2', '2017-10-20 15:40:06', '{}');
INSERT INTO `timeline` VALUES ('356', '1', '5', '2017-10-20 15:40:07', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('357', '1', '21', '2017-10-20 15:40:17', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('358', '1', '2', '2017-10-20 15:42:07', '{}');
INSERT INTO `timeline` VALUES ('359', '1', '5', '2017-10-20 15:42:09', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('360', '1', '21', '2017-10-20 15:42:14', '{\"int2\":[\"1\"],\"int3\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('361', '1', '2', '2017-10-20 15:54:59', '{}');
INSERT INTO `timeline` VALUES ('362', '1', '5', '2017-10-20 15:55:01', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('363', '1', '21', '2017-10-20 15:55:03', '{\"int2\":[\"1\"],\"int3\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('364', '1', '2', '2017-10-20 15:55:08', '{}');
INSERT INTO `timeline` VALUES ('365', '1', '2', '2017-10-20 15:57:38', '{}');
INSERT INTO `timeline` VALUES ('366', '1', '5', '2017-10-20 15:57:38', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('367', '1', '21', '2017-10-20 15:57:46', '{\"int2\":[\"1\"],\"int3\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('368', '1', '21', '2017-10-20 15:57:48', '{}');
INSERT INTO `timeline` VALUES ('369', '1', '2', '2017-10-20 15:57:52', '{}');
INSERT INTO `timeline` VALUES ('370', '1', '5', '2017-10-20 15:57:52', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('371', '1', '21', '2017-10-20 15:57:55', '{\"int2\":[\"1\"],\"int3\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('372', '1', '2', '2017-10-20 15:58:04', '{}');
INSERT INTO `timeline` VALUES ('373', '1', '5', '2017-10-20 15:58:04', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('374', '1', '21', '2017-10-20 15:58:07', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('375', '1', '21', '2017-10-20 15:58:10', '{}');
INSERT INTO `timeline` VALUES ('376', '1', '2', '2017-10-20 15:59:07', '{}');
INSERT INTO `timeline` VALUES ('377', '1', '5', '2017-10-20 15:59:07', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('378', '1', '21', '2017-10-20 15:59:09', '{}');
INSERT INTO `timeline` VALUES ('379', '1', '1', '2017-10-20 15:59:18', '{}');
INSERT INTO `timeline` VALUES ('380', '1', '10', '2017-10-20 15:59:18', '{}');
INSERT INTO `timeline` VALUES ('381', '1', '21', '2017-10-20 16:00:26', '{}');
INSERT INTO `timeline` VALUES ('382', '1', '2', '2017-10-20 16:00:35', '{}');
INSERT INTO `timeline` VALUES ('383', '1', '5', '2017-10-20 16:00:35', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('384', '1', '21', '2017-10-20 16:00:37', '{}');
INSERT INTO `timeline` VALUES ('385', '1', '2', '2017-10-20 16:00:39', '{}');
INSERT INTO `timeline` VALUES ('386', '1', '5', '2017-10-20 16:00:40', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('387', '1', '2', '2017-10-20 16:01:05', '{}');
INSERT INTO `timeline` VALUES ('388', '1', '5', '2017-10-20 16:01:06', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('389', '1', '2', '2017-10-21 09:39:13', '{}');
INSERT INTO `timeline` VALUES ('390', '1', '5', '2017-10-21 09:39:14', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('391', '1', '21', '2017-10-21 09:39:19', '{}');
INSERT INTO `timeline` VALUES ('392', '1', '21', '2017-10-21 09:40:50', '{}');
INSERT INTO `timeline` VALUES ('393', '1', '21', '2017-10-21 09:43:15', '{}');
INSERT INTO `timeline` VALUES ('394', '1', '21', '2017-10-21 09:46:13', '{}');
INSERT INTO `timeline` VALUES ('395', '1', '2', '2017-10-21 09:46:21', '{}');
INSERT INTO `timeline` VALUES ('396', '1', '5', '2017-10-21 09:46:21', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('397', '1', '21', '2017-10-21 09:46:35', '{}');
INSERT INTO `timeline` VALUES ('398', '1', '21', '2017-10-21 09:50:37', '{}');
INSERT INTO `timeline` VALUES ('399', '1', '21', '2017-10-21 09:50:43', '{}');
INSERT INTO `timeline` VALUES ('400', '1', '21', '2017-10-21 09:50:44', '{}');
INSERT INTO `timeline` VALUES ('401', '1', '21', '2017-10-21 09:50:51', '{}');
INSERT INTO `timeline` VALUES ('402', '1', '21', '2017-10-21 09:50:58', '{}');
INSERT INTO `timeline` VALUES ('403', '1', '2', '2017-10-21 09:51:02', '{}');
INSERT INTO `timeline` VALUES ('404', '1', '5', '2017-10-21 09:51:02', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('405', '1', '21', '2017-10-21 09:51:09', '{}');
INSERT INTO `timeline` VALUES ('406', '1', '2', '2017-10-21 09:51:13', '{}');
INSERT INTO `timeline` VALUES ('407', '1', '5', '2017-10-21 09:51:13', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('408', '1', '2', '2017-10-21 09:54:30', '{}');
INSERT INTO `timeline` VALUES ('409', '1', '5', '2017-10-21 09:54:30', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('410', '1', '21', '2017-10-21 09:54:34', '{}');
INSERT INTO `timeline` VALUES ('411', '1', '21', '2017-10-21 09:54:57', '{}');
INSERT INTO `timeline` VALUES ('412', '1', '2', '2017-10-21 09:55:03', '{}');
INSERT INTO `timeline` VALUES ('413', '1', '5', '2017-10-21 09:55:03', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('414', '1', '21', '2017-10-21 09:55:05', '{}');
INSERT INTO `timeline` VALUES ('415', '1', '2', '2017-10-21 09:55:42', '{}');
INSERT INTO `timeline` VALUES ('416', '1', '5', '2017-10-21 09:55:42', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('417', '1', '2', '2017-10-21 09:55:46', '{}');
INSERT INTO `timeline` VALUES ('418', '1', '5', '2017-10-21 09:55:46', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('419', '1', '2', '2017-10-21 10:00:45', '{}');
INSERT INTO `timeline` VALUES ('420', '1', '5', '2017-10-21 10:00:45', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('421', '1', '2', '2017-10-21 10:00:58', '{}');
INSERT INTO `timeline` VALUES ('422', '1', '5', '2017-10-21 10:00:58', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('423', '1', '21', '2017-10-21 10:01:10', '{}');
INSERT INTO `timeline` VALUES ('424', '1', '2', '2017-10-21 10:01:13', '{}');
INSERT INTO `timeline` VALUES ('425', '1', '5', '2017-10-21 10:01:14', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('426', '1', '21', '2017-10-21 10:01:21', '{}');
INSERT INTO `timeline` VALUES ('427', '1', '2', '2017-10-21 10:01:23', '{}');
INSERT INTO `timeline` VALUES ('428', '1', '5', '2017-10-21 10:01:24', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('429', '1', '2', '2017-10-21 10:01:51', '{}');
INSERT INTO `timeline` VALUES ('430', '1', '5', '2017-10-21 10:01:52', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('431', '1', '21', '2017-10-21 10:01:54', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('432', '1', '21', '2017-10-21 10:13:08', '{}');
INSERT INTO `timeline` VALUES ('433', '1', '21', '2017-10-21 10:13:21', '{}');
INSERT INTO `timeline` VALUES ('434', '1', '10', '2017-10-21 10:13:22', '{}');
INSERT INTO `timeline` VALUES ('435', '1', '10', '2017-10-21 10:13:22', '{}');
INSERT INTO `timeline` VALUES ('436', '1', '21', '2017-10-21 10:14:05', '{}');
INSERT INTO `timeline` VALUES ('437', '1', '10', '2017-10-21 10:14:05', '{}');
INSERT INTO `timeline` VALUES ('438', '1', '21', '2017-10-21 10:14:15', '{}');
INSERT INTO `timeline` VALUES ('439', '1', '10', '2017-10-21 10:14:16', '{}');
INSERT INTO `timeline` VALUES ('440', '1', '21', '2017-10-21 10:14:33', '{}');
INSERT INTO `timeline` VALUES ('441', '1', '10', '2017-10-21 10:14:33', '{}');
INSERT INTO `timeline` VALUES ('442', '1', '21', '2017-10-21 10:18:01', '{}');
INSERT INTO `timeline` VALUES ('443', '1', '10', '2017-10-21 10:18:01', '{}');
INSERT INTO `timeline` VALUES ('444', '1', '21', '2017-10-21 10:18:38', '{}');
INSERT INTO `timeline` VALUES ('445', '1', '10', '2017-10-21 10:18:38', '{}');
INSERT INTO `timeline` VALUES ('446', '1', '21', '2017-10-21 10:19:09', '{}');
INSERT INTO `timeline` VALUES ('447', '1', '10', '2017-10-21 10:19:09', '{}');
INSERT INTO `timeline` VALUES ('448', '1', '21', '2017-10-21 10:19:27', '{}');
INSERT INTO `timeline` VALUES ('449', '1', '10', '2017-10-21 10:19:28', '{}');
INSERT INTO `timeline` VALUES ('450', '1', '2', '2017-10-21 10:19:41', '{}');
INSERT INTO `timeline` VALUES ('451', '1', '5', '2017-10-21 10:19:41', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('452', '1', '21', '2017-10-21 10:19:43', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('453', '1', '10', '2017-10-21 10:19:43', '{}');
INSERT INTO `timeline` VALUES ('454', '1', '21', '2017-10-21 14:24:27', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('455', '1', '10', '2017-10-21 14:24:27', '{}');
INSERT INTO `timeline` VALUES ('456', '1', '21', '2017-10-21 14:29:16', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('457', '1', '10', '2017-10-21 14:29:16', '{}');
INSERT INTO `timeline` VALUES ('458', '1', '21', '2017-10-21 14:36:38', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('459', '1', '10', '2017-10-21 14:36:38', '{}');
INSERT INTO `timeline` VALUES ('460', '1', '21', '2017-10-21 14:39:02', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('461', '1', '10', '2017-10-21 14:39:02', '{}');
INSERT INTO `timeline` VALUES ('462', '1', '21', '2017-10-21 14:39:45', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('463', '1', '10', '2017-10-21 14:39:45', '{}');
INSERT INTO `timeline` VALUES ('464', '1', '21', '2017-10-21 14:40:19', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('465', '1', '10', '2017-10-21 14:40:19', '{}');
INSERT INTO `timeline` VALUES ('466', '1', '2', '2017-10-21 14:41:47', '{}');
INSERT INTO `timeline` VALUES ('467', '1', '5', '2017-10-21 14:41:47', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('468', '1', '21', '2017-10-21 14:42:14', '{}');
INSERT INTO `timeline` VALUES ('469', '1', '10', '2017-10-21 14:42:14', '{}');
INSERT INTO `timeline` VALUES ('470', '1', '21', '2017-10-21 14:44:41', '{}');
INSERT INTO `timeline` VALUES ('471', '1', '10', '2017-10-21 14:44:41', '{}');
INSERT INTO `timeline` VALUES ('472', '1', '21', '2017-10-21 14:45:58', '{}');
INSERT INTO `timeline` VALUES ('473', '1', '21', '2017-10-21 14:47:22', '{}');
INSERT INTO `timeline` VALUES ('474', '1', '10', '2017-10-21 14:47:22', '{}');
INSERT INTO `timeline` VALUES ('475', '1', '1', '2017-10-21 14:48:52', '{}');
INSERT INTO `timeline` VALUES ('476', '1', '10', '2017-10-21 14:48:52', '{}');
INSERT INTO `timeline` VALUES ('477', '1', '21', '2017-10-21 14:49:04', '{}');
INSERT INTO `timeline` VALUES ('478', '1', '10', '2017-10-21 14:49:04', '{}');
INSERT INTO `timeline` VALUES ('479', '1', '21', '2017-10-21 14:50:00', '{}');
INSERT INTO `timeline` VALUES ('480', '1', '10', '2017-10-21 14:50:00', '{}');
INSERT INTO `timeline` VALUES ('481', '1', '21', '2017-10-21 14:50:44', '{}');
INSERT INTO `timeline` VALUES ('482', '1', '10', '2017-10-21 14:50:44', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('483', '1', '21', '2017-10-21 14:51:54', '{}');
INSERT INTO `timeline` VALUES ('484', '1', '10', '2017-10-21 14:51:55', '{}');
INSERT INTO `timeline` VALUES ('485', '1', '1', '2017-10-21 14:53:37', '{}');
INSERT INTO `timeline` VALUES ('486', '1', '10', '2017-10-21 14:53:37', '{}');
INSERT INTO `timeline` VALUES ('487', '1', '21', '2017-10-21 14:53:57', '{}');
INSERT INTO `timeline` VALUES ('488', '1', '10', '2017-10-21 14:53:57', '{}');
INSERT INTO `timeline` VALUES ('489', '1', '21', '2017-10-21 14:56:35', '{}');
INSERT INTO `timeline` VALUES ('490', '1', '10', '2017-10-21 14:56:35', '{}');
INSERT INTO `timeline` VALUES ('491', '1', '21', '2017-10-21 14:57:31', '{}');
INSERT INTO `timeline` VALUES ('492', '1', '10', '2017-10-21 14:57:31', '{}');
INSERT INTO `timeline` VALUES ('493', '1', '21', '2017-10-21 15:01:02', '{}');
INSERT INTO `timeline` VALUES ('494', '1', '10', '2017-10-21 15:01:02', '{}');
INSERT INTO `timeline` VALUES ('495', '1', '21', '2017-10-21 15:01:35', '{}');
INSERT INTO `timeline` VALUES ('496', '1', '10', '2017-10-21 15:01:36', '{}');
INSERT INTO `timeline` VALUES ('497', '1', '21', '2017-10-21 15:04:13', '{}');
INSERT INTO `timeline` VALUES ('498', '1', '10', '2017-10-21 15:04:14', '{}');
INSERT INTO `timeline` VALUES ('499', '1', '21', '2017-10-21 15:04:41', '{}');
INSERT INTO `timeline` VALUES ('500', '1', '10', '2017-10-21 15:04:42', '{}');
INSERT INTO `timeline` VALUES ('501', '1', '2', '2017-10-21 15:05:11', '{}');
INSERT INTO `timeline` VALUES ('502', '1', '5', '2017-10-21 15:05:11', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('503', '1', '21', '2017-10-21 15:05:14', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('504', '1', '10', '2017-10-21 15:05:14', '{}');
INSERT INTO `timeline` VALUES ('505', '1', '2', '2017-10-21 15:07:17', '{}');
INSERT INTO `timeline` VALUES ('506', '1', '5', '2017-10-21 15:07:18', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('507', '1', '21', '2017-10-21 15:07:19', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('508', '1', '10', '2017-10-21 15:07:20', '{}');
INSERT INTO `timeline` VALUES ('509', '1', '21', '2017-10-21 15:07:55', '{}');
INSERT INTO `timeline` VALUES ('510', '1', '10', '2017-10-21 15:07:56', '{}');
INSERT INTO `timeline` VALUES ('511', '1', '21', '2017-10-21 15:07:57', '{}');
INSERT INTO `timeline` VALUES ('512', '1', '10', '2017-10-21 15:07:57', '{}');
INSERT INTO `timeline` VALUES ('513', '1', '2', '2017-10-21 15:07:59', '{}');
INSERT INTO `timeline` VALUES ('514', '1', '5', '2017-10-21 15:07:59', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('515', '1', '21', '2017-10-21 15:08:01', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('516', '1', '10', '2017-10-21 15:08:01', '{}');
INSERT INTO `timeline` VALUES ('517', '1', '21', '2017-10-21 15:08:04', '{}');
INSERT INTO `timeline` VALUES ('518', '1', '10', '2017-10-21 15:08:04', '{}');
INSERT INTO `timeline` VALUES ('519', '1', '2', '2017-10-21 15:08:09', '{}');
INSERT INTO `timeline` VALUES ('520', '1', '5', '2017-10-21 15:08:10', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('521', '1', '21', '2017-10-21 15:08:11', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('522', '1', '10', '2017-10-21 15:08:12', '{}');
INSERT INTO `timeline` VALUES ('523', '1', '2', '2017-10-21 15:10:49', '{}');
INSERT INTO `timeline` VALUES ('524', '1', '5', '2017-10-21 15:10:49', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('525', '1', '21', '2017-10-21 15:10:51', '{\"int2\":[\"1\"],\"int3\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('526', '1', '10', '2017-10-21 15:10:51', '{}');
INSERT INTO `timeline` VALUES ('527', '1', '21', '2017-10-21 15:14:46', '{}');
INSERT INTO `timeline` VALUES ('528', '1', '21', '2017-10-21 15:14:55', '{}');
INSERT INTO `timeline` VALUES ('529', '1', '2', '2017-10-21 15:15:18', '{}');
INSERT INTO `timeline` VALUES ('530', '1', '5', '2017-10-21 15:15:18', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('531', '1', '21', '2017-10-21 15:15:22', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('532', '1', '10', '2017-10-21 15:15:22', '{}');
INSERT INTO `timeline` VALUES ('533', '1', '21', '2017-10-21 15:18:00', '{}');
INSERT INTO `timeline` VALUES ('534', '1', '21', '2017-10-21 15:18:21', '{}');
INSERT INTO `timeline` VALUES ('535', '1', '10', '2017-10-21 15:18:22', '{}');
INSERT INTO `timeline` VALUES ('536', '1', '2', '2017-10-21 15:19:50', '{}');
INSERT INTO `timeline` VALUES ('537', '1', '5', '2017-10-21 15:19:51', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('538', '1', '21', '2017-10-21 15:19:53', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('539', '1', '10', '2017-10-21 15:19:53', '{}');
INSERT INTO `timeline` VALUES ('540', '1', '21', '2017-10-21 15:21:09', '{}');
INSERT INTO `timeline` VALUES ('541', '1', '10', '2017-10-21 15:21:09', '{}');
INSERT INTO `timeline` VALUES ('542', '1', '2', '2017-10-21 15:21:10', '{}');
INSERT INTO `timeline` VALUES ('543', '1', '5', '2017-10-21 15:21:10', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('544', '1', '21', '2017-10-21 15:21:12', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('545', '1', '10', '2017-10-21 15:21:12', '{}');
INSERT INTO `timeline` VALUES ('546', '1', '2', '2017-10-21 15:22:03', '{}');
INSERT INTO `timeline` VALUES ('547', '1', '5', '2017-10-21 15:22:04', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('548', '1', '21', '2017-10-21 15:22:05', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('549', '1', '10', '2017-10-21 15:22:06', '{}');
INSERT INTO `timeline` VALUES ('550', '1', '21', '2017-10-21 15:22:49', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('551', '1', '10', '2017-10-21 15:22:50', '{}');
INSERT INTO `timeline` VALUES ('552', '1', '2', '2017-10-21 15:22:54', '{}');
INSERT INTO `timeline` VALUES ('553', '1', '5', '2017-10-21 15:22:55', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('554', '1', '21', '2017-10-21 15:22:56', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('555', '1', '10', '2017-10-21 15:22:57', '{}');
INSERT INTO `timeline` VALUES ('556', '1', '21', '2017-10-21 15:24:24', '{}');
INSERT INTO `timeline` VALUES ('557', '1', '10', '2017-10-21 15:24:25', '{}');
INSERT INTO `timeline` VALUES ('558', '1', '2', '2017-10-21 15:24:30', '{}');
INSERT INTO `timeline` VALUES ('559', '1', '5', '2017-10-21 15:24:30', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('560', '1', '21', '2017-10-21 15:24:32', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('561', '1', '10', '2017-10-21 15:24:32', '{}');
INSERT INTO `timeline` VALUES ('562', '1', '21', '2017-10-21 15:24:55', '{}');
INSERT INTO `timeline` VALUES ('563', '1', '10', '2017-10-21 15:24:56', '{}');
INSERT INTO `timeline` VALUES ('564', '1', '21', '2017-10-21 15:26:34', '{}');
INSERT INTO `timeline` VALUES ('565', '1', '10', '2017-10-21 15:26:34', '{}');
INSERT INTO `timeline` VALUES ('566', '1', '2', '2017-10-21 15:26:40', '{}');
INSERT INTO `timeline` VALUES ('567', '1', '5', '2017-10-21 15:26:41', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('568', '1', '21', '2017-10-21 15:26:43', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('569', '1', '10', '2017-10-21 15:26:43', '{}');
INSERT INTO `timeline` VALUES ('570', '1', '21', '2017-10-21 15:27:12', '{}');
INSERT INTO `timeline` VALUES ('571', '1', '10', '2017-10-21 15:27:12', '{}');
INSERT INTO `timeline` VALUES ('572', '1', '2', '2017-10-21 15:27:20', '{}');
INSERT INTO `timeline` VALUES ('573', '1', '5', '2017-10-21 15:27:20', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('574', '1', '21', '2017-10-21 15:27:22', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('575', '1', '10', '2017-10-21 15:27:22', '{}');
INSERT INTO `timeline` VALUES ('576', '1', '2', '2017-10-21 15:27:50', '{}');
INSERT INTO `timeline` VALUES ('577', '1', '5', '2017-10-21 15:27:51', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('578', '1', '21', '2017-10-21 15:27:53', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('579', '1', '10', '2017-10-21 15:27:53', '{}');
INSERT INTO `timeline` VALUES ('580', '1', '2', '2017-10-21 15:27:56', '{}');
INSERT INTO `timeline` VALUES ('581', '1', '5', '2017-10-21 15:27:57', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('582', '1', '21', '2017-10-21 15:27:58', '{\"int2\":[\"1\"],\"int3\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('583', '1', '10', '2017-10-21 15:27:58', '{}');
INSERT INTO `timeline` VALUES ('584', '1', '2', '2017-10-21 15:27:59', '{}');
INSERT INTO `timeline` VALUES ('585', '1', '5', '2017-10-21 15:27:59', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('586', '1', '21', '2017-10-21 15:28:01', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('587', '1', '10', '2017-10-21 15:28:01', '{}');
INSERT INTO `timeline` VALUES ('588', '1', '2', '2017-10-21 15:28:02', '{}');
INSERT INTO `timeline` VALUES ('589', '1', '5', '2017-10-21 15:28:02', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('590', '1', '21', '2017-10-21 15:28:04', '{\"int2\":[\"1\"],\"int3\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('591', '1', '10', '2017-10-21 15:28:04', '{}');
INSERT INTO `timeline` VALUES ('592', '1', '21', '2017-10-21 15:28:29', '{}');
INSERT INTO `timeline` VALUES ('593', '1', '10', '2017-10-21 15:28:29', '{}');
INSERT INTO `timeline` VALUES ('594', '1', '2', '2017-10-21 15:28:31', '{}');
INSERT INTO `timeline` VALUES ('595', '1', '5', '2017-10-21 15:28:31', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('596', '1', '21', '2017-10-21 15:28:32', '{\"int2\":[\"1\"],\"int3\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('597', '1', '10', '2017-10-21 15:28:33', '{}');
INSERT INTO `timeline` VALUES ('598', '1', '21', '2017-10-21 15:28:34', '{}');
INSERT INTO `timeline` VALUES ('599', '1', '10', '2017-10-21 15:28:35', '{}');
INSERT INTO `timeline` VALUES ('600', '1', '2', '2017-10-21 15:28:36', '{}');
INSERT INTO `timeline` VALUES ('601', '1', '5', '2017-10-21 15:28:37', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('602', '1', '21', '2017-10-21 15:28:39', '{\"int2\":[\"1\"],\"int3\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('603', '1', '10', '2017-10-21 15:28:39', '{}');
INSERT INTO `timeline` VALUES ('604', '1', '1', '2017-10-21 15:30:43', '{}');
INSERT INTO `timeline` VALUES ('605', '1', '10', '2017-10-21 15:30:43', '{}');
INSERT INTO `timeline` VALUES ('606', '1', '1', '2017-10-21 15:39:41', '{}');
INSERT INTO `timeline` VALUES ('607', '1', '1', '2017-10-21 15:40:56', '{}');
INSERT INTO `timeline` VALUES ('608', '1', '1', '2017-10-21 15:42:15', '{}');
INSERT INTO `timeline` VALUES ('609', '1', '1', '2017-10-21 15:42:59', '{}');
INSERT INTO `timeline` VALUES ('610', '1', '10', '2017-10-21 15:42:59', '{}');
INSERT INTO `timeline` VALUES ('611', '1', '1', '2017-10-21 15:43:07', '{}');
INSERT INTO `timeline` VALUES ('612', '1', '10', '2017-10-21 15:43:07', '{}');
INSERT INTO `timeline` VALUES ('613', '1', '1', '2017-10-21 15:43:16', '{}');
INSERT INTO `timeline` VALUES ('614', '1', '10', '2017-10-21 15:43:16', '{}');
INSERT INTO `timeline` VALUES ('615', '1', '1', '2017-10-21 15:43:18', '{}');
INSERT INTO `timeline` VALUES ('616', '1', '10', '2017-10-21 15:43:18', '{}');
INSERT INTO `timeline` VALUES ('617', '1', '1', '2017-10-21 15:44:09', '{}');
INSERT INTO `timeline` VALUES ('618', '1', '10', '2017-10-21 15:44:10', '{}');
INSERT INTO `timeline` VALUES ('619', '1', '1', '2017-10-21 15:44:56', '{}');
INSERT INTO `timeline` VALUES ('620', '1', '10', '2017-10-21 15:44:56', '{}');
INSERT INTO `timeline` VALUES ('621', '1', '1', '2017-10-21 15:47:12', '{}');
INSERT INTO `timeline` VALUES ('622', '1', '10', '2017-10-21 15:47:12', '{}');
INSERT INTO `timeline` VALUES ('623', '1', '1', '2017-10-21 15:47:20', '{}');
INSERT INTO `timeline` VALUES ('624', '1', '10', '2017-10-21 15:47:20', '{}');
INSERT INTO `timeline` VALUES ('625', '1', '1', '2017-10-21 15:47:51', '{}');
INSERT INTO `timeline` VALUES ('626', '1', '10', '2017-10-21 15:47:52', '{}');
INSERT INTO `timeline` VALUES ('627', '1', '21', '2017-10-21 15:48:42', '{}');
INSERT INTO `timeline` VALUES ('628', '1', '10', '2017-10-21 15:48:42', '{}');
INSERT INTO `timeline` VALUES ('629', '1', '1', '2017-10-21 15:49:05', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('630', '1', '1', '2017-10-21 15:49:32', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('631', '1', '10', '2017-10-21 15:49:32', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('632', '1', '1', '2017-10-21 15:49:41', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('633', '1', '10', '2017-10-21 15:49:41', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('634', '1', '1', '2017-10-21 15:49:44', '{\"id\":[\"1\"]}');
INSERT INTO `timeline` VALUES ('635', '1', '21', '2017-10-21 15:49:56', '{}');
INSERT INTO `timeline` VALUES ('636', '1', '10', '2017-10-21 15:49:57', '{}');
INSERT INTO `timeline` VALUES ('637', '1', '1', '2017-10-21 15:49:59', '{\"id\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('638', '1', '10', '2017-10-21 15:49:59', '{}');
INSERT INTO `timeline` VALUES ('639', '1', '1', '2017-10-21 15:50:55', '{\"id\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('640', '1', '1', '2017-10-21 15:53:52', '{\"id\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('641', '1', '10', '2017-10-21 15:53:53', '{}');
INSERT INTO `timeline` VALUES ('642', '1', '1', '2017-10-21 15:54:44', '{\"id\":[\"3\"]}');
INSERT INTO `timeline` VALUES ('643', '1', '21', '2017-10-21 15:54:48', '{}');
INSERT INTO `timeline` VALUES ('644', '1', '10', '2017-10-21 15:54:48', '{}');
INSERT INTO `timeline` VALUES ('645', '1', '1', '2017-10-21 15:54:51', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('646', '1', '1', '2017-10-21 15:56:25', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('647', '1', '21', '2017-10-21 15:56:28', '{}');
INSERT INTO `timeline` VALUES ('648', '1', '10', '2017-10-21 15:56:28', '{}');
INSERT INTO `timeline` VALUES ('649', '1', '1', '2017-10-21 15:56:31', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('650', '1', '1', '2017-10-21 15:57:13', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('651', '1', '1', '2017-10-21 16:02:15', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('652', '1', '1', '2017-10-21 16:02:45', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('653', '1', '1', '2017-10-21 16:03:22', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('654', '1', '1', '2017-10-21 16:07:03', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('655', '1', '1', '2017-10-21 16:07:21', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('656', '1', '1', '2017-10-21 16:07:37', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('657', '1', '1', '2017-10-21 16:08:49', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('658', '1', '10', '2017-10-21 16:08:49', '{}');
INSERT INTO `timeline` VALUES ('659', '1', '1', '2017-10-21 16:09:14', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('660', '1', '1', '2017-10-21 16:14:30', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('661', '1', '1', '2017-10-21 16:14:34', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('662', '1', '10', '2017-10-21 16:14:35', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('663', '1', '1', '2017-10-21 16:14:44', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('664', '1', '1', '2017-10-21 16:14:46', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('665', '1', '14', '2017-10-21 16:14:51', '{}');
INSERT INTO `timeline` VALUES ('666', '1', '1', '2017-10-21 16:16:41', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('667', '1', '10', '2017-10-21 16:16:41', '{}');
INSERT INTO `timeline` VALUES ('668', '1', '1', '2017-10-21 16:16:51', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('669', '1', '14', '2017-10-21 16:16:53', '{}');
INSERT INTO `timeline` VALUES ('670', '1', '1', '2017-10-21 16:20:38', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('671', '1', '10', '2017-10-21 16:20:38', '{}');
INSERT INTO `timeline` VALUES ('672', '1', '10', '2017-10-21 16:20:38', '{}');
INSERT INTO `timeline` VALUES ('673', '1', '1', '2017-10-21 16:20:52', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('674', '1', '14', '2017-10-21 16:20:57', '{}');
INSERT INTO `timeline` VALUES ('675', '1', '1', '2017-10-21 16:23:31', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('676', '1', '14', '2017-10-21 16:23:35', '{\"title\":[\"sssssss张顺\"],\"content\":[\"ada大\"],\"summary\":[\"aa\"],\"blIds\":[\"[\\\"1\\\"]\"],\"ishide\":[\"1\"],\"id\":[\"4\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('677', '1', '21', '2017-10-21 16:23:44', '{}');
INSERT INTO `timeline` VALUES ('678', '1', '10', '2017-10-21 16:23:44', '{}');
INSERT INTO `timeline` VALUES ('679', '1', '1', '2017-10-21 16:23:49', '{\"id\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('680', '1', '14', '2017-10-21 16:23:52', '{\"title\":[\"sssssss张顺\"],\"content\":[\"ada大\"],\"summary\":[\"aa\"],\"blIds\":[\"[\\\"1\\\"]\"],\"ishide\":[\"0\"],\"id\":[\"4\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('681', '1', '21', '2017-10-21 16:23:54', '{}');
INSERT INTO `timeline` VALUES ('682', '1', '10', '2017-10-21 16:23:54', '{}');
INSERT INTO `timeline` VALUES ('683', '1', '21', '2017-10-21 16:24:03', '{}');
INSERT INTO `timeline` VALUES ('684', '1', '10', '2017-10-21 16:24:03', '{}');
INSERT INTO `timeline` VALUES ('685', '1', '1', '2017-10-21 16:24:06', '{}');
INSERT INTO `timeline` VALUES ('686', '1', '10', '2017-10-21 16:24:06', '{}');
INSERT INTO `timeline` VALUES ('687', '1', '13', '2017-10-21 16:24:28', '{\"title\":[\"张顺你还好吗\"],\"content\":[\"你好\"],\"summary\":[\"张顺你好\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\",\\\"4\\\"]\"],\"ishide\":[\"0\"]}');
INSERT INTO `timeline` VALUES ('688', '1', '21', '2017-10-21 16:24:30', '{}');
INSERT INTO `timeline` VALUES ('689', '1', '10', '2017-10-21 16:24:30', '{}');
INSERT INTO `timeline` VALUES ('690', '1', '21', '2017-10-21 16:24:35', '{}');
INSERT INTO `timeline` VALUES ('691', '1', '10', '2017-10-21 16:24:35', '{}');
INSERT INTO `timeline` VALUES ('692', '1', '1', '2017-10-21 16:24:47', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('693', '1', '14', '2017-10-21 16:24:49', '{\"title\":[\"张顺你还好吗\"],\"content\":[\"你好\"],\"summary\":[\"张顺你好\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\"]\"],\"ishide\":[\"0\"],\"id\":[\"10\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('694', '1', '21', '2017-10-21 16:24:50', '{}');
INSERT INTO `timeline` VALUES ('695', '1', '10', '2017-10-21 16:24:50', '{}');
INSERT INTO `timeline` VALUES ('696', '1', '2', '2017-10-21 16:24:57', '{}');
INSERT INTO `timeline` VALUES ('697', '1', '5', '2017-10-21 16:24:57', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('698', '1', '21', '2017-10-21 16:25:00', '{\"int2\":[\"1\"],\"int3\":[\"4\"]}');
INSERT INTO `timeline` VALUES ('699', '1', '10', '2017-10-21 16:25:00', '{}');
INSERT INTO `timeline` VALUES ('700', '1', '21', '2017-10-21 16:25:02', '{}');
INSERT INTO `timeline` VALUES ('701', '1', '10', '2017-10-21 16:25:02', '{}');
INSERT INTO `timeline` VALUES ('702', '1', '21', '2017-10-21 16:25:07', '{}');
INSERT INTO `timeline` VALUES ('703', '1', '10', '2017-10-21 16:25:08', '{}');
INSERT INTO `timeline` VALUES ('704', '1', '21', '2017-10-21 16:30:25', '{}');
INSERT INTO `timeline` VALUES ('705', '1', '10', '2017-10-21 16:30:25', '{}');
INSERT INTO `timeline` VALUES ('706', '1', '1', '2017-10-21 16:30:27', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('707', '1', '14', '2017-10-21 16:30:30', '{\"title\":[\"张顺你还好吗\"],\"content\":[\"你好\"],\"summary\":[\"张顺你好\"],\"blIds\":[\"[\\\"1\\\",\\\"2\\\",\\\"3\\\",\\\"4\\\"]\"],\"ishide\":[\"1\"],\"id\":[\"10\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('708', '1', '21', '2017-10-21 16:30:33', '{}');
INSERT INTO `timeline` VALUES ('709', '1', '10', '2017-10-21 16:30:33', '{}');
INSERT INTO `timeline` VALUES ('710', '1', '1', '2017-10-21 16:30:36', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('711', '1', '14', '2017-10-21 16:30:39', '{\"title\":[\"张顺你还好吗\"],\"content\":[\"你好\"],\"summary\":[\"张顺你好\"],\"blIds\":[\"[\\\"2\\\",\\\"3\\\",\\\"4\\\"]\"],\"ishide\":[\"1\"],\"id\":[\"10\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('712', '1', '21', '2017-10-21 16:30:41', '{}');
INSERT INTO `timeline` VALUES ('713', '1', '10', '2017-10-21 16:30:41', '{}');
INSERT INTO `timeline` VALUES ('714', '1', '21', '2017-10-21 16:30:55', '{}');
INSERT INTO `timeline` VALUES ('715', '1', '10', '2017-10-21 16:30:55', '{}');
INSERT INTO `timeline` VALUES ('716', '1', '21', '2017-10-21 16:30:57', '{}');
INSERT INTO `timeline` VALUES ('717', '1', '10', '2017-10-21 16:30:57', '{}');
INSERT INTO `timeline` VALUES ('718', '1', '1', '2017-10-21 16:30:57', '{}');
INSERT INTO `timeline` VALUES ('719', '1', '10', '2017-10-21 16:30:58', '{}');
INSERT INTO `timeline` VALUES ('720', '1', '21', '2017-10-21 16:31:10', '{}');
INSERT INTO `timeline` VALUES ('721', '1', '10', '2017-10-21 16:31:11', '{}');
INSERT INTO `timeline` VALUES ('722', '1', '1', '2017-10-21 16:31:14', '{\"id\":[\"5\"]}');
INSERT INTO `timeline` VALUES ('723', '1', '14', '2017-10-21 16:31:44', '{\"title\":[\"美团App 插件化实践\"],\"content\":[\"\\u003ch3 id\\u003d\\\"-\\\"\\u003e背景\\u003c/h3\\u003e\\r\\n\\u003cp\\u003e在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。但纵观各大插件框架，都是基于自身App的业务来开发的，目标或多或少都有区别，所以很难有一个插件框架能一统江湖解决所有问题。最后就是绕不开的兼容性问题，Android每次版本升级都会给各个插件化框架带来不少冲击，都要费劲心思适配一番，更别提国内各个厂商对在ROM上做的定制了，正如VirtualAPK的作者任玉刚所说：完成一个插件化框架的 Demo 并不是多难的事儿，然而要开发一款完善的插件化框架却并非易事。\\u003c/p\\u003e\\r\\n\\u003cp\\u003e早在2014年美团移动技术团队就开始关注插件化技术了，并且意识到插件化架构是美团这种平台型App最好的集成形式。但由于业务增长、迭代、演化太快，受限于业务耦合和架构问题，插件化一直无法落地。到了2016年底，经过一系列的代码架构调整、技术调研，我们终于能腾出手来让插件化技术落地了。\\u003c/p\\u003e\\r\\n\\u003cp\\u003e美团平台（与点评平台一起）目前承载了美团点评所有事业群近20条业务线的业务。其中有相对成熟的业务，比如外卖、餐饮，他们对插件的要求是稳定性高，不能因为上了插件导致业务出问题；也有迭代变化很快的业务，如交通、跑腿、金融等，他们要求能快速迭代上线；此外，由于美团App采用的二进制AAR依赖方式集成已经运转了两年，各种基础设施都很成熟了，我们不希望换成插件形式的接入之后还要改变开发模式。所以，美团平台对插件的诉求主要集中在兼容性和不影响开发模式这两个点上。\\u003c/p\\u003e\\r\\n\\u003ch3 id\\u003d\\\"-\\\"\\u003e美团插件化框架的原理和特点\\u003c/h3\\u003e\\r\\n\\u003cp\\u003e插件框架的兼容性体现在多个方面，由于Android机制的问题，有些写法在插件化之前运行的很正常，但是接入插件化之后就变得不再有效。如果不解决兼容性问题，插件化的口碑和推广都会很大阻碍。兼容性不仅仅指的是对Android系统、Android碎片化的兼容，还要对已有基础库和构建工具的兼容。特别是后者，我们经常看到Github上开源的插件化框架里面有大量Crash的Issue，就是这个方面原因导致的。每个App的基础库和既有构建工具都不太一样，所以为自己的App选择合适的方案显得尤为重要。\\u003c/p\\u003e\\r\\n\\u003cp\\u003e为了保证插件的兼容性，并能无缝兼容当前AAR开发模式，美团的插件化框架方案主要做了以下几点：：\\u003c/p\\u003e\\r\\n\\u003cul\\u003e\\r\\n\\u003cli\\u003e插件的Dex加载使用类似MultiDex方案，保证对反射的兼容\\u003c/li\\u003e\\r\\n\\u003cli\\u003e替换所有的AssetManager，保证对资源访问的兼容\\u003c/li\\u003e\\r\\n\\u003cli\\u003e四大组件预埋，代理新增Activity\\u003c/li\\u003e\\r\\n\\u003cli\\u003e让构建系统来抹平AAR开发模式和插件化开发模式的差异\\u003c/li\\u003e\\r\\n\\u003c/ul\\u003e\\r\\n\\u003cp\\u003eMultiDex和组件代理这里不细说，网上有很多这方面的博客可以参考。下面重点说一下美团插件化框架对资源的处理和支持AAR、插件一键切换的构建系统。\\u003c/p\\u003e\\r\\n\\u003ch3 id\\u003d\\\"-\\\"\\u003e资源处理\\u003c/h3\\u003e\\r\\n\\u003cp\\u003e了解插件化的读者都知道：如果希望访问插件的资源，需要使用AssetManager把插件的路径加入进去。但这样做是远远不够的。这是因为如果希望这个AssetManager生效，就得把它放到具体的Resources或ResourcesImpl里面，大部分插件化框架的做法是封装一个包含插件路径AssetManager的Resources，然后插件中只使用这一个Resources。\\u003c/p\\u003e\\r\\n\\u003cp\\u003e这样的做法大多数情况是有效的，但是有至少3个问题：\\u003c/p\\u003e\\r\\n\\u003col\\u003e\\r\\n\\u003cli\\u003e如果在插件中使用了宿主Resources，如：\\u003ccode\\u003egetApplicationContext().getResources()\\u003c/code\\u003e。 这个Resources就无法访问插件的资源了\\u003c/li\\u003e\\r\\n\\u003cli\\u003e插件外的Resources 并不唯一，需要全局查找和替换\\u003c/li\\u003e\\r\\n\\u003cli\\u003eResoureces在使用的过程中有很多中间产物，例如Theme、TypedArray等等。这些都需要清理才能正常使用\\u003c/li\\u003e\\r\\n\\u003c/ol\\u003e\\r\\n\\u003cp\\u003e要完全解决这些问题，我们另辟蹊径，做了一个全局的资源处理方式：\\u003c/p\\u003e\\r\\n\\u003cul\\u003e\\r\\n\\u003cli\\u003e新建或者使用已有AssetManger，加载插件资源\\u003c/li\\u003e\\r\\n\\u003cli\\u003e查找所有的Resources/Theme，替换其中的AssetManger\\u003c/li\\u003e\\r\\n\\u003cli\\u003e清理Resources缓存，重建Theme\\u003c/li\\u003e\\r\\n\\u003cli\\u003eAssetManager的重建保护，防止丢失插件路径\\u003c/li\\u003e\\r\\n\\u003c/ul\\u003e\\r\\n\\u003cp\\u003e这个方案和InstantRun有点类似，但是原生InstantRun有太多的问题：\\u003c/p\\u003e\\r\\n\\u003cul\\u003e\\r\\n\\u003cli\\u003e清理顺序错误，应该先清理Applicaiton后清理Activity\\u003c/li\\u003e\\r\\n\\u003cli\\u003eResources/Theme找不全，没有极端情况应对机制\\u003c/li\\u003e\\r\\n\\u003cli\\u003eTheme光清理不重建\\u003c/li\\u003e\\r\\n\\u003cli\\u003e完全不适配 Support包里面自己埋的“雷”\\u003cbr\\u003e等等\\u003c/li\\u003e\\r\\n\\u003c/ul\\u003e\\r\\n\\u003cpre\\u003e\\u003ccode class\\u003d\\\"java\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003efor\\u003c/span\\u003e (Activity activity : activities) {\\r\\n    ... \\u003cspan class\\u003d\\\"comment\\\"\\u003e// 省略部分代码\\u003c/span\\u003e\\r\\n    Resources.Theme theme \\u003d activity.getTheme();\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003etry\\u003c/span\\u003e {\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003etry\\u003c/span\\u003e {\\r\\n            Field ma \\u003d Resources.Theme.class.getDeclaredField(\\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"mAssets\\\"\\u003c/span\\u003e);\\r\\n            ma.setAccessible(\\u003cspan class\\u003d\\\"keyword\\\"\\u003etrue\\u003c/span\\u003e);\\r\\n            ma.set(theme, newAssetManager);\\r\\n        } \\u003cspan class\\u003d\\\"keyword\\\"\\u003ecatch\\u003c/span\\u003e (NoSuchFieldException ignore) {\\r\\n            Field themeField \\u003d Resources.Theme.class.getDeclaredField(\\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"mThemeImpl\\\"\\u003c/span\\u003e);\\r\\n            themeField.setAccessible(\\u003cspan class\\u003d\\\"keyword\\\"\\u003etrue\\u003c/span\\u003e);\\r\\n            Object impl \\u003d themeField.get(theme);\\r\\n            Field ma \\u003d impl.getClass().getDeclaredField(\\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"mAssets\\\"\\u003c/span\\u003e);\\r\\n            ma.setAccessible(\\u003cspan class\\u003d\\\"keyword\\\"\\u003etrue\\u003c/span\\u003e);\\r\\n            ma.set(impl, newAssetManager);\\r\\n        }\\r\\n        ...\\r\\n    } \\u003cspan class\\u003d\\\"keyword\\\"\\u003ecatch\\u003c/span\\u003e (Throwable e) {\\r\\n        Log.e(LOG_TAG, \\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"Failed to update existing theme for activity \\\"\\u003c/span\\u003e + activity,\\r\\n                e);\\r\\n    }\\r\\n    pruneResourceCaches(resources);\\r\\n}\\r\\n\\u003c/code\\u003e\\u003c/pre\\u003e\\r\\n\\u003cp\\u003e这个思路是对的，但是远不够。例如，Google 自己的Support包里面的一个类 android.support.v7.view.ContextThemeWrapper会生成一个新的Theme保存：\\u003c/p\\u003e\\r\\n\\u003cpre\\u003e\\u003ccode class\\u003d\\\"java\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003epublic\\u003c/span\\u003e \\u003cspan class\\u003d\\\"class\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003eclass\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003eContextThemeWrapper\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003eextends\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003eContextWrapper\\u003c/span\\u003e \\u003c/span\\u003e{\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003eprivate\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003eint\\u003c/span\\u003e mThemeResource;\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003eprivate\\u003c/span\\u003e Resources.Theme mTheme;\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003eprivate\\u003c/span\\u003e LayoutInflater mInflater;\\r\\n    ...\\r\\n    \\u003cspan class\\u003d\\\"function\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003eprivate\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003evoid\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003einitializeTheme\\u003c/span\\u003e\\u003cspan class\\u003d\\\"params\\\"\\u003e()\\u003c/span\\u003e \\u003c/span\\u003e{\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003efinal\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003eboolean\\u003c/span\\u003e first \\u003d mTheme \\u003d\\u003d \\u003cspan class\\u003d\\\"keyword\\\"\\u003enull\\u003c/span\\u003e;\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003eif\\u003c/span\\u003e (first) {\\r\\n            mTheme \\u003d getResources().newTheme();\\r\\n            \\u003cspan class\\u003d\\\"keyword\\\"\\u003efinal\\u003c/span\\u003e Resources.Theme theme \\u003d getBaseContext().getTheme();\\r\\n            \\u003cspan class\\u003d\\\"keyword\\\"\\u003eif\\u003c/span\\u003e (theme !\\u003d \\u003cspan class\\u003d\\\"keyword\\\"\\u003enull\\u003c/span\\u003e) {\\r\\n                mTheme.setTo(theme);\\r\\n            }\\r\\n        }\\r\\n        onApplyThemeResource(mTheme, mThemeResource, first);\\r\\n    }\\r\\n    ...\\r\\n}\\r\\n\\u003c/code\\u003e\\u003c/pre\\u003e\\r\\n\\u003cp\\u003e如果没有替换了这个ContextThemeWrapper的Theme，假如配合它使用的Reources/AssetManager是新的，就会导致Crash：\\u003cbr\\u003e\\u003ccode\\u003ejava.lang.RuntimeException: Failed to resolve attribute at index 0\\u003c/code\\u003e\\u003cbr\\u003e这是大部分开源框架都存在的Issue。\\u003cbr\\u003e为了解决这个问题，我们不仅清理所有Activity的Theme，还清理了所有View的Context。\\u003c/p\\u003e\\r\\n\\u003cpre\\u003e\\u003ccode class\\u003d\\\"java\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003etry\\u003c/span\\u003e {\\r\\n    List\\u0026lt;View\\u0026gt; list \\u003d getAllChildViews(activity.getWindow().getDecorView());\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003efor\\u003c/span\\u003e (View v : list) {\\r\\n        Context context \\u003d v.getContext();\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003eif\\u003c/span\\u003e (context \\u003cspan class\\u003d\\\"keyword\\\"\\u003einstanceof\\u003c/span\\u003e ContextThemeWrapper\\r\\n                \\u0026amp;\\u0026amp; context !\\u003d activity\\r\\n                \\u0026amp;\\u0026amp; !clearContextWrapperCaches.contains(context)) {\\r\\n            clearContextWrapperCaches.add((ContextThemeWrapper) context);\\r\\n            pruneSupportContextThemeWrapper((ContextThemeWrapper) context, newAssetManager); \\u003cspan class\\u003d\\\"comment\\\"\\u003e// 清理Theme\\u003c/span\\u003e\\r\\n        }\\r\\n    }\\r\\n} \\u003cspan class\\u003d\\\"keyword\\\"\\u003ecatch\\u003c/span\\u003e (Throwable ignore) {\\r\\n    Log.e(LOG_TAG, ignore.getMessage());\\r\\n}\\r\\n\\u003c/code\\u003e\\u003c/pre\\u003e\\r\\n\\u003cp\\u003e但是这些做法还是不能解决所有问题，有时候为了实现一个产品需求，Android工程师可能会采取一些非常规写法，导致变成插件之后资源加载失败。比如在一个自己的类里面保存了Theme。这种问题不可能一个个改业务代码，那能不能让插件兼容这种写法呢？\\u003cbr\\u003e我们对这种行为也做了兼容：\\u003cstrong\\u003e修改字节码\\u003c/strong\\u003e。\\u003c/p\\u003e\\r\\n\\u003cp\\u003e了解虚拟机指令的同学都知道，如果要保存一个类变量，对应的虚拟机的指令是PUTFIELD/PUTSTATIC，以此为突破口，用ASM写一个MethodVisitor：\\u003c/p\\u003e\\r\\n\\u003cpre\\u003e\\u003ccode class\\u003d\\\"java\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003estatic\\u003c/span\\u003e \\u003cspan class\\u003d\\\"class\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003eclass\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003eMyMethodVisitor\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003eextends\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003eMethodVisitor\\u003c/span\\u003e \\u003c/span\\u003e{\\r\\n    \\u003cspan class\\u003d\\\"keyword\\\"\\u003eint\\u003c/span\\u003e stackSize \\u003d \\u003cspan class\\u003d\\\"number\\\"\\u003e0\\u003c/span\\u003e;\\r\\n\\r\\n    MyMethodVisitor(MethodVisitor mv) {\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003esuper\\u003c/span\\u003e(Opcodes.ASM5, mv);\\r\\n    }\\r\\n\\r\\n    \\u003cspan class\\u003d\\\"annotation\\\"\\u003e@Override\\u003c/span\\u003e\\r\\n    \\u003cspan class\\u003d\\\"function\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003epublic\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003evoid\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003evisitFieldInsn\\u003c/span\\u003e\\u003cspan class\\u003d\\\"params\\\"\\u003e(\\u003cspan class\\u003d\\\"keyword\\\"\\u003eint\\u003c/span\\u003e opcode, String owner, String name, String desc)\\u003c/span\\u003e \\u003c/span\\u003e{\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003eif\\u003c/span\\u003e (opcode \\u003d\\u003d Opcodes.PUTFIELD || opcode \\u003d\\u003d Opcodes.PUTSTATIC) {\\r\\n            \\u003cspan class\\u003d\\\"keyword\\\"\\u003eif\\u003c/span\\u003e (\\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"Landroid/content/res/Resources$Theme;\\\"\\u003c/span\\u003e.equals(desc)) {\\r\\n                stackSize \\u003d \\u003cspan class\\u003d\\\"number\\\"\\u003e1\\u003c/span\\u003e;\\r\\n                visitInsn(Opcodes.DUP);\\r\\n                \\u003cspan class\\u003d\\\"keyword\\\"\\u003esuper\\u003c/span\\u003e.visitMethodInsn(Opcodes.INVOKESTATIC,\\r\\n                        \\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"com/meituan/hydra/runtime/Transformer\\\"\\u003c/span\\u003e,\\r\\n                        \\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"collectTheme\\\"\\u003c/span\\u003e,\\r\\n                        \\u003cspan class\\u003d\\\"string\\\"\\u003e\\\"(Landroid/content/res/Resources$Theme;)V\\\"\\u003c/span\\u003e,\\r\\n                        \\u003cspan class\\u003d\\\"keyword\\\"\\u003efalse\\u003c/span\\u003e);\\r\\n            }\\r\\n        }\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003esuper\\u003c/span\\u003e.visitFieldInsn(opcode, owner, name, desc);\\r\\n    }\\r\\n\\r\\n    \\u003cspan class\\u003d\\\"annotation\\\"\\u003e@Override\\u003c/span\\u003e\\r\\n    \\u003cspan class\\u003d\\\"function\\\"\\u003e\\u003cspan class\\u003d\\\"keyword\\\"\\u003epublic\\u003c/span\\u003e \\u003cspan class\\u003d\\\"keyword\\\"\\u003evoid\\u003c/span\\u003e \\u003cspan class\\u003d\\\"title\\\"\\u003evisitMaxs\\u003c/span\\u003e\\u003cspan class\\u003d\\\"params\\\"\\u003e(\\u003cspan class\\u003d\\\"keyword\\\"\\u003eint\\u003c/span\\u003e maxStack, \\u003cspan class\\u003d\\\"keyword\\\"\\u003eint\\u003c/span\\u003e maxLocals)\\u003c/span\\u003e \\u003c/span\\u003e{\\r\\n        \\u003cspan class\\u003d\\\"keyword\\\"\\u003esuper\\u003c/span\\u003e.visitMaxs(maxStack + stackSize, maxLocals);\\r\\n        stackSize \\u003d \\u003cspan class\\u003d\\\"number\\\"\\u003e0\\u003c/span\\u003e;\\r\\n    }\\r\\n}\\r\\n\\u003c/code\\u003e\\u003c/pre\\u003e\\r\\n\\u003cp\\u003e这样可以保证所有被类保存的Theme都会被收集起来，在插件安装后，统一清理、重建就行了。\\u003c/p\\u003e\\r\\n\\u003ch3 id\\u003d\\\"-\\\"\\u003e插件的构建系统\\u003c/h3\\u003e\\r\\n\\u003cp\\u003e为了实现在AAR集成方式和插件集成方式之间一键切换，并解决插件化遇到的“API陷阱”的问题，我们把大量的时间花在构建系统的建设上面，我们的构建系统除了支持常规的构建插件之外，还支持已有构建工具和未来可能存在的构建工具。\\u003cbr\\u003e我们将正常构建过程分为4个阶段：\\u003c/p\\u003e\\r\\n\\u003col\\u003e\\r\\n\\u003cli\\u003e收集依赖\\u003c/li\\u003e\\r\\n\\u003cli\\u003e处理资源\\u003c/li\\u003e\\r\\n\\u003cli\\u003e处理代码\\u003c/li\\u003e\\r\\n\\u003cli\\u003e打包签名\\u003c/li\\u003e\\r\\n\\u003c/ol\\u003e\\r\\n\\u003cp\\u003e那么如何保证对已有Gradle插件的支持？最好的方式是不对这个构建过程做太多干涉，保证它们的正常、按顺序执行。所以我们的构建系统在不干扰这个顺序的基础上，把插件的构建过程插入进去，对应正常构建的4个阶段，主要做了如下工作。\\u003c/p\\u003e\\r\\n\\u003cul\\u003e\\r\\n\\u003cli\\u003e宿主解析依赖之后，分析插件的依赖，进行依赖仲裁和引用计数分析\\u003c/li\\u003e\\r\\n\\u003cli\\u003e宿主处理资源之前，处理插件资源，规避了资源访问的陷阱，生成需要Merge的资源列表给宿主，开发 美团AAPT 处理插件资源\\u003c/li\\u003e\\r\\n\\u003cli\\u003e宿主处理代码之中，规避插件API使用的陷阱，复用宿主的Proguard和Gradle插件，做到对原生构建过程的最大兼容。我们也修复了Proguard Mapping的问题，后续会有专门的博客介绍\\u003c/li\\u003e\\r\\n\\u003cli\\u003e宿主打包签名之前，构建插件APK，计算升级兼容的Hash特征，使用V2签名加快运行时的验证\\u003c/li\\u003e\\r\\n\\u003c/ul\\u003e\"],\"summary\":[\"在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。\"],\"blIds\":[\"[\\\"1\\\",\\\"4\\\"]\"],\"ishide\":[\"0\"],\"id\":[\"5\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('724', '1', '21', '2017-10-21 16:31:51', '{}');
INSERT INTO `timeline` VALUES ('725', '1', '10', '2017-10-21 16:31:51', '{}');
INSERT INTO `timeline` VALUES ('726', '1', '21', '2017-10-21 16:35:06', '{}');
INSERT INTO `timeline` VALUES ('727', '1', '10', '2017-10-21 16:35:06', '{}');
INSERT INTO `timeline` VALUES ('728', '1', '2', '2017-10-21 16:35:10', '{}');
INSERT INTO `timeline` VALUES ('729', '1', '5', '2017-10-21 16:35:10', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('730', '1', '2', '2017-10-21 16:37:02', '{}');
INSERT INTO `timeline` VALUES ('731', '1', '5', '2017-10-21 16:37:02', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('732', '1', '5', '2017-10-21 16:37:07', '{\"date1\":[\"2017/10/21 16:37:05\"],\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('733', '1', '5', '2017-10-21 16:37:12', '{\"date2\":[\"2017/10/21 16:37:10\"],\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('734', '1', '21', '2017-10-21 16:37:13', '{}');
INSERT INTO `timeline` VALUES ('735', '1', '10', '2017-10-21 16:37:13', '{}');
INSERT INTO `timeline` VALUES ('736', '1', '2', '2017-10-21 16:37:26', '{}');
INSERT INTO `timeline` VALUES ('737', '1', '5', '2017-10-21 16:37:26', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('738', '1', '21', '2017-10-21 16:37:30', '{}');
INSERT INTO `timeline` VALUES ('739', '1', '10', '2017-10-21 16:37:30', '{}');
INSERT INTO `timeline` VALUES ('740', '1', '2', '2017-10-21 16:37:32', '{}');
INSERT INTO `timeline` VALUES ('741', '1', '5', '2017-10-21 16:37:32', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('742', '1', '21', '2017-10-21 16:37:41', '{}');
INSERT INTO `timeline` VALUES ('743', '1', '10', '2017-10-21 16:37:41', '{}');
INSERT INTO `timeline` VALUES ('744', '1', '1', '2017-10-21 16:48:25', '{}');
INSERT INTO `timeline` VALUES ('745', '1', '10', '2017-10-21 16:48:25', '{}');
INSERT INTO `timeline` VALUES ('746', '1', '1', '2017-10-21 16:51:01', '{}');
INSERT INTO `timeline` VALUES ('747', '1', '10', '2017-10-21 16:51:01', '{}');
INSERT INTO `timeline` VALUES ('748', '1', '1', '2017-10-21 16:51:31', '{}');
INSERT INTO `timeline` VALUES ('749', '1', '10', '2017-10-21 16:51:31', '{}');
INSERT INTO `timeline` VALUES ('750', '1', '1', '2017-10-21 16:52:19', '{}');
INSERT INTO `timeline` VALUES ('751', '1', '10', '2017-10-21 16:52:19', '{}');
INSERT INTO `timeline` VALUES ('752', '1', '1', '2017-10-21 16:52:38', '{}');
INSERT INTO `timeline` VALUES ('753', '1', '10', '2017-10-21 16:52:39', '{}');
INSERT INTO `timeline` VALUES ('754', '1', '21', '2017-10-21 17:14:58', '{}');
INSERT INTO `timeline` VALUES ('755', '1', '10', '2017-10-21 17:14:58', '{}');
INSERT INTO `timeline` VALUES ('756', '1', '1', '2017-10-21 17:15:01', '{\"id\":[\"8\"]}');
INSERT INTO `timeline` VALUES ('757', '1', '21', '2017-10-21 17:15:04', '{}');
INSERT INTO `timeline` VALUES ('758', '1', '10', '2017-10-21 17:15:05', '{}');
INSERT INTO `timeline` VALUES ('759', '1', '1', '2017-10-21 17:15:07', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('760', '1', '10', '2017-10-21 17:15:07', '{}');
INSERT INTO `timeline` VALUES ('761', '1', '21', '2017-10-21 17:15:13', '{}');
INSERT INTO `timeline` VALUES ('762', '1', '10', '2017-10-21 17:15:13', '{}');
INSERT INTO `timeline` VALUES ('763', '1', '1', '2017-10-21 17:15:16', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('764', '1', '10', '2017-10-21 17:15:16', '{}');
INSERT INTO `timeline` VALUES ('765', '1', '21', '2017-10-21 17:15:28', '{}');
INSERT INTO `timeline` VALUES ('766', '1', '10', '2017-10-21 17:15:28', '{}');
INSERT INTO `timeline` VALUES ('767', '1', '1', '2017-10-21 17:15:32', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('768', '1', '21', '2017-10-21 17:17:37', '{}');
INSERT INTO `timeline` VALUES ('769', '1', '10', '2017-10-21 17:17:37', '{}');
INSERT INTO `timeline` VALUES ('770', '1', '1', '2017-10-21 17:17:41', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('771', '1', '1', '2017-10-21 17:18:42', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('772', '1', '1', '2017-10-21 17:19:34', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('773', '1', '1', '2017-10-21 17:20:01', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('774', '1', '10', '2017-10-21 17:20:01', '{}');
INSERT INTO `timeline` VALUES ('775', '1', '1', '2017-10-21 17:20:06', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('776', '1', '1', '2017-10-21 17:20:07', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('777', '1', '1', '2017-10-21 17:20:08', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('778', '1', '10', '2017-10-21 17:20:08', '{}');
INSERT INTO `timeline` VALUES ('779', '1', '1', '2017-10-21 17:20:11', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('780', '1', '1', '2017-10-21 17:20:12', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('781', '1', '1', '2017-10-21 17:20:13', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('782', '1', '1', '2017-10-21 17:20:13', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('783', '1', '10', '2017-10-21 17:20:13', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('784', '1', '1', '2017-10-21 17:20:14', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('785', '1', '1', '2017-10-21 17:20:14', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('786', '1', '1', '2017-10-21 17:20:15', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('787', '1', '1', '2017-10-21 17:20:16', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('788', '1', '10', '2017-10-21 17:20:16', '{}');
INSERT INTO `timeline` VALUES ('789', '1', '1', '2017-10-21 17:20:20', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('790', '1', '1', '2017-10-21 17:20:21', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('791', '1', '1', '2017-10-21 17:20:21', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('792', '1', '1', '2017-10-21 17:20:22', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('793', '1', '1', '2017-10-21 17:20:25', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('794', '1', '1', '2017-10-21 17:20:25', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('795', '1', '1', '2017-10-21 17:20:26', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('796', '1', '10', '2017-10-21 17:20:26', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('797', '1', '1', '2017-10-21 17:20:26', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('798', '1', '1', '2017-10-21 17:20:27', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('799', '1', '1', '2017-10-21 17:20:27', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('800', '1', '10', '2017-10-21 17:20:28', '{}');
INSERT INTO `timeline` VALUES ('801', '1', '1', '2017-10-21 17:20:28', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('802', '1', '1', '2017-10-21 17:20:29', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('803', '1', '1', '2017-10-21 17:20:29', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('804', '1', '1', '2017-10-21 17:20:30', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('805', '1', '10', '2017-10-21 17:20:30', '{}');
INSERT INTO `timeline` VALUES ('806', '1', '10', '2017-10-21 17:20:30', '{}');
INSERT INTO `timeline` VALUES ('807', '1', '1', '2017-10-21 17:20:30', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('808', '1', '1', '2017-10-21 17:20:31', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('809', '1', '10', '2017-10-21 17:20:31', '{}');
INSERT INTO `timeline` VALUES ('810', '1', '1', '2017-10-21 17:20:32', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('811', '1', '1', '2017-10-21 17:20:51', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('812', '1', '1', '2017-10-21 17:20:53', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('813', '1', '1', '2017-10-21 17:20:54', '{\"id\":[\"10\"]}');
INSERT INTO `timeline` VALUES ('814', '1', '14', '2017-10-21 17:20:55', '{\"title\":[\"张顺你还好吗\"],\"content\":[\"你好\"],\"summary\":[\"张顺你好\"],\"blIds\":[\"[\\\"2\\\",\\\"3\\\",\\\"4\\\"]\"],\"ishide\":[\"0\"],\"id\":[\"10\"],\"_method\":[\"put\"]}');
INSERT INTO `timeline` VALUES ('815', '1', '21', '2017-10-21 17:20:57', '{}');
INSERT INTO `timeline` VALUES ('816', '1', '10', '2017-10-21 17:20:58', '{}');
INSERT INTO `timeline` VALUES ('817', '1', '2', '2017-10-21 17:22:51', '{}');
INSERT INTO `timeline` VALUES ('818', '1', '5', '2017-10-21 17:22:51', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('819', '1', '21', '2017-10-21 17:24:09', '{}');
INSERT INTO `timeline` VALUES ('820', '1', '10', '2017-10-21 17:24:09', '{}');
INSERT INTO `timeline` VALUES ('821', '1', '21', '2017-10-21 17:24:51', '{}');
INSERT INTO `timeline` VALUES ('822', '1', '10', '2017-10-21 17:24:52', '{}');
INSERT INTO `timeline` VALUES ('823', '1', '1', '2017-10-21 17:24:55', '{\"id\":[\"2\"]}');
INSERT INTO `timeline` VALUES ('824', '1', '1', '2017-10-21 17:25:15', '{}');
INSERT INTO `timeline` VALUES ('825', '1', '10', '2017-10-21 17:25:15', '{}');
INSERT INTO `timeline` VALUES ('826', '1', '2', '2017-10-21 17:32:44', '{}');
INSERT INTO `timeline` VALUES ('827', '1', '5', '2017-10-21 17:32:45', '{\"page\":[\"1\"],\"rows\":[\"25\"]}');
INSERT INTO `timeline` VALUES ('828', '2', '1', '2017-10-24 21:34:13', '{}');
INSERT INTO `timeline` VALUES ('829', '2', '10', '2017-10-24 21:34:13', '{}');
INSERT INTO `timeline` VALUES ('830', '2', '1', '2017-10-24 21:52:17', '{}');
INSERT INTO `timeline` VALUES ('831', '2', '10', '2017-10-24 21:52:17', '{}');
INSERT INTO `timeline` VALUES ('832', '2', '1', '2017-10-24 21:52:32', '{}');
INSERT INTO `timeline` VALUES ('833', '2', '10', '2017-10-24 21:52:32', '{}');
INSERT INTO `timeline` VALUES ('834', '2', '1', '2017-10-24 21:53:14', '{}');
INSERT INTO `timeline` VALUES ('835', '2', '10', '2017-10-24 21:53:14', '{}');
INSERT INTO `timeline` VALUES ('836', '2', '22', '2017-10-24 21:53:15', '{}');
INSERT INTO `timeline` VALUES ('837', '2', '22', '2017-10-24 21:53:19', '{}');
INSERT INTO `timeline` VALUES ('838', '2', '22', '2017-10-24 21:56:31', '{}');
INSERT INTO `timeline` VALUES ('839', '2', '22', '2017-10-24 21:56:37', '{}');
INSERT INTO `timeline` VALUES ('840', '2', '22', '2017-10-24 21:56:38', '{}');
INSERT INTO `timeline` VALUES ('841', '1', '22', '2017-10-24 21:56:46', '{}');
INSERT INTO `timeline` VALUES ('842', '1', '22', '2017-10-24 21:56:56', '{}');
INSERT INTO `timeline` VALUES ('843', '1', '22', '2017-10-24 21:57:11', '{}');
INSERT INTO `timeline` VALUES ('844', '1', '22', '2017-10-24 21:57:12', '{}');
INSERT INTO `timeline` VALUES ('845', '1', '22', '2017-10-24 21:57:52', '{}');
INSERT INTO `timeline` VALUES ('846', '1', '22', '2017-10-24 21:57:57', '{}');
INSERT INTO `timeline` VALUES ('847', '1', '22', '2017-10-24 21:58:46', '{}');
INSERT INTO `timeline` VALUES ('848', '1', '22', '2017-10-24 22:00:21', '{}');
INSERT INTO `timeline` VALUES ('849', '1', '22', '2017-10-24 22:01:00', '{}');
INSERT INTO `timeline` VALUES ('850', '1', '22', '2017-10-24 22:03:30', '{}');
INSERT INTO `timeline` VALUES ('851', '1', '22', '2017-10-24 22:03:49', '{}');
INSERT INTO `timeline` VALUES ('852', '1', '22', '2017-10-24 22:04:11', '{}');
INSERT INTO `timeline` VALUES ('853', '1', '22', '2017-10-24 22:04:29', '{}');
INSERT INTO `timeline` VALUES ('854', '1', '22', '2017-10-24 22:05:41', '{}');
INSERT INTO `timeline` VALUES ('855', '1', '22', '2017-10-24 22:08:48', '{}');
INSERT INTO `timeline` VALUES ('856', '1', '22', '2017-10-24 22:09:50', '{}');
INSERT INTO `timeline` VALUES ('857', '1', '22', '2017-10-24 22:09:56', '{}');
INSERT INTO `timeline` VALUES ('858', '1', '22', '2017-10-24 22:09:57', '{}');
INSERT INTO `timeline` VALUES ('859', '1', '22', '2017-10-24 22:10:09', '{}');
INSERT INTO `timeline` VALUES ('860', '1', '22', '2017-10-24 22:29:29', '{}');
INSERT INTO `timeline` VALUES ('861', '1', '22', '2017-10-24 22:33:24', '{}');
INSERT INTO `timeline` VALUES ('862', '1', '22', '2017-10-24 22:33:43', '{}');
INSERT INTO `timeline` VALUES ('863', '1', '22', '2017-10-24 22:33:45', '{}');
INSERT INTO `timeline` VALUES ('864', '1', '22', '2017-10-24 22:33:53', '{}');
INSERT INTO `timeline` VALUES ('865', '1', '22', '2017-10-24 22:33:53', '{}');
INSERT INTO `timeline` VALUES ('866', '1', '22', '2017-10-24 22:33:54', '{}');
INSERT INTO `timeline` VALUES ('867', '1', '22', '2017-10-24 22:34:01', '{}');
INSERT INTO `timeline` VALUES ('868', '1', '22', '2017-10-24 22:34:08', '{}');
INSERT INTO `timeline` VALUES ('869', '1', '22', '2017-10-24 22:34:08', '{}');
INSERT INTO `timeline` VALUES ('870', '1', '22', '2017-10-24 22:34:31', '{}');

-- ----------------------------
-- Table structure for `token`
-- ----------------------------
DROP TABLE IF EXISTS `token`;
CREATE TABLE `token` (
  `token` varchar(255) NOT NULL,
  `u_id` int(11) NOT NULL,
  `invalid_time` datetime NOT NULL,
  PRIMARY KEY (`token`),
  UNIQUE KEY `token` (`token`),
  KEY `u_id` (`u_id`),
  CONSTRAINT `token_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of token
-- ----------------------------
INSERT INTO `token` VALUES ('242144403063347', '2', '2017-10-25 21:56:38');
INSERT INTO `token` VALUES ('242229271187093', '1', '2017-10-25 22:34:31');

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usernum` varchar(255) NOT NULL,
  `userpass` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `isdelete` int(11) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `rids` varchar(255) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usernum` (`usernum`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'yd7111', '123456', '张顺', null, null, '0', '2017-10-12 14:51:44', '1,2', null);
INSERT INTO `users` VALUES ('2', 'viewer', '123456', '观光者', null, null, '0', '2017-10-18 17:34:52', '1', null);
