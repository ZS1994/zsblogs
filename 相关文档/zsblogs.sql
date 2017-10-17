/*
Navicat MySQL Data Transfer

Source Server         : 本地服务器
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : zsblogs

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2017-10-17 18:18:54
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES ('1', 'asa', '湿哒哒所', '2017-10-14 17:43:35', 'ads', '0');
INSERT INTO `blog` VALUES ('2', '第二篇', '社会实践', '2017-10-14 18:03:17', 'ddd', '0');
INSERT INTO `blog` VALUES ('3', '俩sad', '啊啊啊啊', '2017-10-15 20:22:28', 'sss', '0');
INSERT INTO `blog` VALUES ('4', 'sssssss', 'ada大', '2017-10-15 20:22:37', 'aa', '1');
INSERT INTO `blog` VALUES ('5', '美团App 插件化实践', '<h3 id=\"-\">背景</h3>\r\n<p>在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。但纵观各大插件框架，都是基于自身App的业务来开发的，目标或多或少都有区别，所以很难有一个插件框架能一统江湖解决所有问题。最后就是绕不开的兼容性问题，Android每次版本升级都会给各个插件化框架带来不少冲击，都要费劲心思适配一番，更别提国内各个厂商对在ROM上做的定制了，正如VirtualAPK的作者任玉刚所说：完成一个插件化框架的 Demo 并不是多难的事儿，然而要开发一款完善的插件化框架却并非易事。</p>\r\n<p>早在2014年美团移动技术团队就开始关注插件化技术了，并且意识到插件化架构是美团这种平台型App最好的集成形式。但由于业务增长、迭代、演化太快，受限于业务耦合和架构问题，插件化一直无法落地。到了2016年底，经过一系列的代码架构调整、技术调研，我们终于能腾出手来让插件化技术落地了。</p>\r\n<p>美团平台（与点评平台一起）目前承载了美团点评所有事业群近20条业务线的业务。其中有相对成熟的业务，比如外卖、餐饮，他们对插件的要求是稳定性高，不能因为上了插件导致业务出问题；也有迭代变化很快的业务，如交通、跑腿、金融等，他们要求能快速迭代上线；此外，由于美团App采用的二进制AAR依赖方式集成已经运转了两年，各种基础设施都很成熟了，我们不希望换成插件形式的接入之后还要改变开发模式。所以，美团平台对插件的诉求主要集中在兼容性和不影响开发模式这两个点上。</p>\r\n<h3 id=\"-\">美团插件化框架的原理和特点</h3>\r\n<p>插件框架的兼容性体现在多个方面，由于Android机制的问题，有些写法在插件化之前运行的很正常，但是接入插件化之后就变得不再有效。如果不解决兼容性问题，插件化的口碑和推广都会很大阻碍。兼容性不仅仅指的是对Android系统、Android碎片化的兼容，还要对已有基础库和构建工具的兼容。特别是后者，我们经常看到Github上开源的插件化框架里面有大量Crash的Issue，就是这个方面原因导致的。每个App的基础库和既有构建工具都不太一样，所以为自己的App选择合适的方案显得尤为重要。</p>\r\n<p>为了保证插件的兼容性，并能无缝兼容当前AAR开发模式，美团的插件化框架方案主要做了以下几点：：</p>\r\n<ul>\r\n<li>插件的Dex加载使用类似MultiDex方案，保证对反射的兼容</li>\r\n<li>替换所有的AssetManager，保证对资源访问的兼容</li>\r\n<li>四大组件预埋，代理新增Activity</li>\r\n<li>让构建系统来抹平AAR开发模式和插件化开发模式的差异</li>\r\n</ul>\r\n<p>MultiDex和组件代理这里不细说，网上有很多这方面的博客可以参考。下面重点说一下美团插件化框架对资源的处理和支持AAR、插件一键切换的构建系统。</p>\r\n<h3 id=\"-\">资源处理</h3>\r\n<p>了解插件化的读者都知道：如果希望访问插件的资源，需要使用AssetManager把插件的路径加入进去。但这样做是远远不够的。这是因为如果希望这个AssetManager生效，就得把它放到具体的Resources或ResourcesImpl里面，大部分插件化框架的做法是封装一个包含插件路径AssetManager的Resources，然后插件中只使用这一个Resources。</p>\r\n<p>这样的做法大多数情况是有效的，但是有至少3个问题：</p>\r\n<ol>\r\n<li>如果在插件中使用了宿主Resources，如：<code>getApplicationContext().getResources()</code>。 这个Resources就无法访问插件的资源了</li>\r\n<li>插件外的Resources 并不唯一，需要全局查找和替换</li>\r\n<li>Resoureces在使用的过程中有很多中间产物，例如Theme、TypedArray等等。这些都需要清理才能正常使用</li>\r\n</ol>\r\n<p>要完全解决这些问题，我们另辟蹊径，做了一个全局的资源处理方式：</p>\r\n<ul>\r\n<li>新建或者使用已有AssetManger，加载插件资源</li>\r\n<li>查找所有的Resources/Theme，替换其中的AssetManger</li>\r\n<li>清理Resources缓存，重建Theme</li>\r\n<li>AssetManager的重建保护，防止丢失插件路径</li>\r\n</ul>\r\n<p>这个方案和InstantRun有点类似，但是原生InstantRun有太多的问题：</p>\r\n<ul>\r\n<li>清理顺序错误，应该先清理Applicaiton后清理Activity</li>\r\n<li>Resources/Theme找不全，没有极端情况应对机制</li>\r\n<li>Theme光清理不重建</li>\r\n<li>完全不适配 Support包里面自己埋的“雷”<br>等等</li>\r\n</ul>\r\n<pre><code class=\"java\"><span class=\"keyword\">for</span> (Activity activity : activities) {\r\n    ... <span class=\"comment\">// 省略部分代码</span>\r\n    Resources.Theme theme = activity.getTheme();\r\n    <span class=\"keyword\">try</span> {\r\n        <span class=\"keyword\">try</span> {\r\n            Field ma = Resources.Theme.class.getDeclaredField(<span class=\"string\">\"mAssets\"</span>);\r\n            ma.setAccessible(<span class=\"keyword\">true</span>);\r\n            ma.set(theme, newAssetManager);\r\n        } <span class=\"keyword\">catch</span> (NoSuchFieldException ignore) {\r\n            Field themeField = Resources.Theme.class.getDeclaredField(<span class=\"string\">\"mThemeImpl\"</span>);\r\n            themeField.setAccessible(<span class=\"keyword\">true</span>);\r\n            Object impl = themeField.get(theme);\r\n            Field ma = impl.getClass().getDeclaredField(<span class=\"string\">\"mAssets\"</span>);\r\n            ma.setAccessible(<span class=\"keyword\">true</span>);\r\n            ma.set(impl, newAssetManager);\r\n        }\r\n        ...\r\n    } <span class=\"keyword\">catch</span> (Throwable e) {\r\n        Log.e(LOG_TAG, <span class=\"string\">\"Failed to update existing theme for activity \"</span> + activity,\r\n                e);\r\n    }\r\n    pruneResourceCaches(resources);\r\n}\r\n</code></pre>\r\n<p>这个思路是对的，但是远不够。例如，Google 自己的Support包里面的一个类 android.support.v7.view.ContextThemeWrapper会生成一个新的Theme保存：</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">public</span> <span class=\"class\"><span class=\"keyword\">class</span> <span class=\"title\">ContextThemeWrapper</span> <span class=\"keyword\">extends</span> <span class=\"title\">ContextWrapper</span> </span>{\r\n    <span class=\"keyword\">private</span> <span class=\"keyword\">int</span> mThemeResource;\r\n    <span class=\"keyword\">private</span> Resources.Theme mTheme;\r\n    <span class=\"keyword\">private</span> LayoutInflater mInflater;\r\n    ...\r\n    <span class=\"function\"><span class=\"keyword\">private</span> <span class=\"keyword\">void</span> <span class=\"title\">initializeTheme</span><span class=\"params\">()</span> </span>{\r\n        <span class=\"keyword\">final</span> <span class=\"keyword\">boolean</span> first = mTheme == <span class=\"keyword\">null</span>;\r\n        <span class=\"keyword\">if</span> (first) {\r\n            mTheme = getResources().newTheme();\r\n            <span class=\"keyword\">final</span> Resources.Theme theme = getBaseContext().getTheme();\r\n            <span class=\"keyword\">if</span> (theme != <span class=\"keyword\">null</span>) {\r\n                mTheme.setTo(theme);\r\n            }\r\n        }\r\n        onApplyThemeResource(mTheme, mThemeResource, first);\r\n    }\r\n    ...\r\n}\r\n</code></pre>\r\n<p>如果没有替换了这个ContextThemeWrapper的Theme，假如配合它使用的Reources/AssetManager是新的，就会导致Crash：<br><code>java.lang.RuntimeException: Failed to resolve attribute at index 0</code><br>这是大部分开源框架都存在的Issue。<br>为了解决这个问题，我们不仅清理所有Activity的Theme，还清理了所有View的Context。</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">try</span> {\r\n    List&lt;View&gt; list = getAllChildViews(activity.getWindow().getDecorView());\r\n    <span class=\"keyword\">for</span> (View v : list) {\r\n        Context context = v.getContext();\r\n        <span class=\"keyword\">if</span> (context <span class=\"keyword\">instanceof</span> ContextThemeWrapper\r\n                &amp;&amp; context != activity\r\n                &amp;&amp; !clearContextWrapperCaches.contains(context)) {\r\n            clearContextWrapperCaches.add((ContextThemeWrapper) context);\r\n            pruneSupportContextThemeWrapper((ContextThemeWrapper) context, newAssetManager); <span class=\"comment\">// 清理Theme</span>\r\n        }\r\n    }\r\n} <span class=\"keyword\">catch</span> (Throwable ignore) {\r\n    Log.e(LOG_TAG, ignore.getMessage());\r\n}\r\n</code></pre>\r\n<p>但是这些做法还是不能解决所有问题，有时候为了实现一个产品需求，Android工程师可能会采取一些非常规写法，导致变成插件之后资源加载失败。比如在一个自己的类里面保存了Theme。这种问题不可能一个个改业务代码，那能不能让插件兼容这种写法呢？<br>我们对这种行为也做了兼容：<strong>修改字节码</strong>。</p>\r\n<p>了解虚拟机指令的同学都知道，如果要保存一个类变量，对应的虚拟机的指令是PUTFIELD/PUTSTATIC，以此为突破口，用ASM写一个MethodVisitor：</p>\r\n<pre><code class=\"java\"><span class=\"keyword\">static</span> <span class=\"class\"><span class=\"keyword\">class</span> <span class=\"title\">MyMethodVisitor</span> <span class=\"keyword\">extends</span> <span class=\"title\">MethodVisitor</span> </span>{\r\n    <span class=\"keyword\">int</span> stackSize = <span class=\"number\">0</span>;\r\n\r\n    MyMethodVisitor(MethodVisitor mv) {\r\n        <span class=\"keyword\">super</span>(Opcodes.ASM5, mv);\r\n    }\r\n\r\n    <span class=\"annotation\">@Override</span>\r\n    <span class=\"function\"><span class=\"keyword\">public</span> <span class=\"keyword\">void</span> <span class=\"title\">visitFieldInsn</span><span class=\"params\">(<span class=\"keyword\">int</span> opcode, String owner, String name, String desc)</span> </span>{\r\n        <span class=\"keyword\">if</span> (opcode == Opcodes.PUTFIELD || opcode == Opcodes.PUTSTATIC) {\r\n            <span class=\"keyword\">if</span> (<span class=\"string\">\"Landroid/content/res/Resources$Theme;\"</span>.equals(desc)) {\r\n                stackSize = <span class=\"number\">1</span>;\r\n                visitInsn(Opcodes.DUP);\r\n                <span class=\"keyword\">super</span>.visitMethodInsn(Opcodes.INVOKESTATIC,\r\n                        <span class=\"string\">\"com/meituan/hydra/runtime/Transformer\"</span>,\r\n                        <span class=\"string\">\"collectTheme\"</span>,\r\n                        <span class=\"string\">\"(Landroid/content/res/Resources$Theme;)V\"</span>,\r\n                        <span class=\"keyword\">false</span>);\r\n            }\r\n        }\r\n        <span class=\"keyword\">super</span>.visitFieldInsn(opcode, owner, name, desc);\r\n    }\r\n\r\n    <span class=\"annotation\">@Override</span>\r\n    <span class=\"function\"><span class=\"keyword\">public</span> <span class=\"keyword\">void</span> <span class=\"title\">visitMaxs</span><span class=\"params\">(<span class=\"keyword\">int</span> maxStack, <span class=\"keyword\">int</span> maxLocals)</span> </span>{\r\n        <span class=\"keyword\">super</span>.visitMaxs(maxStack + stackSize, maxLocals);\r\n        stackSize = <span class=\"number\">0</span>;\r\n    }\r\n}\r\n</code></pre>\r\n<p>这样可以保证所有被类保存的Theme都会被收集起来，在插件安装后，统一清理、重建就行了。</p>\r\n<h3 id=\"-\">插件的构建系统</h3>\r\n<p>为了实现在AAR集成方式和插件集成方式之间一键切换，并解决插件化遇到的“API陷阱”的问题，我们把大量的时间花在构建系统的建设上面，我们的构建系统除了支持常规的构建插件之外，还支持已有构建工具和未来可能存在的构建工具。<br>我们将正常构建过程分为4个阶段：</p>\r\n<ol>\r\n<li>收集依赖</li>\r\n<li>处理资源</li>\r\n<li>处理代码</li>\r\n<li>打包签名</li>\r\n</ol>\r\n<p>那么如何保证对已有Gradle插件的支持？最好的方式是不对这个构建过程做太多干涉，保证它们的正常、按顺序执行。所以我们的构建系统在不干扰这个顺序的基础上，把插件的构建过程插入进去，对应正常构建的4个阶段，主要做了如下工作。</p>\r\n<ul>\r\n<li>宿主解析依赖之后，分析插件的依赖，进行依赖仲裁和引用计数分析</li>\r\n<li>宿主处理资源之前，处理插件资源，规避了资源访问的陷阱，生成需要Merge的资源列表给宿主，开发 美团AAPT 处理插件资源</li>\r\n<li>宿主处理代码之中，规避插件API使用的陷阱，复用宿主的Proguard和Gradle插件，做到对原生构建过程的最大兼容。我们也修复了Proguard Mapping的问题，后续会有专门的博客介绍</li>\r\n<li>宿主打包签名之前，构建插件APK，计算升级兼容的Hash特征，使用V2签名加快运行时的验证</li>\r\n</ul>', '2017-10-16 14:40:36', '在Android开发行业里，插件化已经不是一门新鲜的技术了，在稍大的平台型App上早已是标配。进入2017年，Atlas、Replugin、VirtualAPK相继开源，标志着插件化技术进入了成熟阶段。', '0');

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
  CONSTRAINT `blog_comment_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`),
  CONSTRAINT `blog_comment_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_comment
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_list
-- ----------------------------
INSERT INTO `blog_list` VALUES ('1', '测试', '2017-10-14 17:43:16', '1', '1');
INSERT INTO `blog_list` VALUES ('2', '随笔', '2017-10-17 17:23:51', '2', '1');
INSERT INTO `blog_list` VALUES ('3', '成功日记', '2017-10-17 17:24:14', '3', '1');
INSERT INTO `blog_list` VALUES ('4', '设计思想', '2017-10-17 17:24:25', '4', '1');

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
  CONSTRAINT `blog_list_rel_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`),
  CONSTRAINT `blog_list_rel_ibfk_1` FOREIGN KEY (`bl_id`) REFERENCES `blog_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_list_rel
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES ('1', '写博客', '/zsblogs/menu/blogList/blog/edit', 'GET', 'menu', '博客', null, '1', null);
INSERT INTO `permission` VALUES ('2', '博客栏目', '/zsblogs/menu/blogList', 'GET', 'menu', '博客', null, '2', null);
INSERT INTO `permission` VALUES ('3', '所有博客', '/zsblogs/menu/blogList/blog', 'GET', 'menu', '博客', null, '3', null);
INSERT INTO `permission` VALUES ('4', '查看博客', '/zsblogs/menu/blogList/blog/%', 'GET', 'menu', '博客', null, '4', null);
INSERT INTO `permission` VALUES ('5', '博客栏目分页查询', '/zsblogs/api/blogList/list', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('6', '博客栏目单条查询', '/zsblogs/api/blogList/%', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('7', '博客栏目单条添加', '/zsblogs/api/blogList', 'POST', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('8', '博客栏目单条修改', '/zsblogs/api/blogList', 'PUT', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('9', '博客栏目单条删除', '/zsblogs/api/blogList/%', 'DELETE', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('10', '查询自己所有的博客栏目', '/zsblogs/api/blogList/user/all', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('11', '博客分页查询', '/zsblogs/api/blog/list', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('12', '博客单条查询', '/zsblogs/api/blog/%', 'GET', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('13', '博客单条添加', '/zsblogs/api/blog', 'POST', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('14', '博客单条修改', '/zsblogs/api/blog', 'PUT', 'api', '博客', null, null, null);
INSERT INTO `permission` VALUES ('15', '博客单条删除', '/zsblogs/api/blog/%', 'DELETE', 'api', '博客', null, null, null);

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
  CONSTRAINT `read_ibfk_2` FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`),
  CONSTRAINT `read_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of read
-- ----------------------------

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
INSERT INTO `role` VALUES ('1', '开发者', '拥有所有权限', '1');
INSERT INTO `role` VALUES ('2', '博客作者', '拥有写博客的权限', '1,10');

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
  CONSTRAINT `timeline_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `permission` (`id`),
  CONSTRAINT `timeline_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;

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
INSERT INTO `token` VALUES ('171719546122701', '1', '2017-10-18 17:32:47');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'yd7111', '123456', '张顺', null, null, '0', '2017-10-12 14:51:44', '1,2', null);
