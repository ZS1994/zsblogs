/*
Navicat MySQL Data Transfer

Source Server         : 本地服务器
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : zsblogs

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2017-10-12 15:02:36
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `blog`
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `context` text NOT NULL,
  `create_time` datetime NOT NULL,
  `bl_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bl_id` (`bl_id`),
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`bl_id`) REFERENCES `blog_list` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog
-- ----------------------------

-- ----------------------------
-- Table structure for `blog_comment`
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `context` varchar(255) NOT NULL,
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
  `order` int(11) NOT NULL,
  `u_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `u_id` (`u_id`),
  CONSTRAINT `blog_list_ibfk_1` FOREIGN KEY (`u_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of blog_list
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of permission
-- ----------------------------

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
  `des` varchar(255) DEFAULT NULL,
  `pids` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of timeline
-- ----------------------------

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
INSERT INTO `token` VALUES ('121454383529552', '1', '2017-10-13 14:54:38');

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `usernum` (`usernum`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'yd7111', '123456', '张顺', null, null, '0', '2017-10-12 14:51:44', null);
