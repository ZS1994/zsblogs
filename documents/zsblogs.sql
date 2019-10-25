/*
Navicat MySQL Data Transfer

Source Server         : 本地
Source Server Version : 50617
Source Host           : localhost:3306
Source Database       : zsblogs

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2019-10-26 00:13:34
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `api_doc`
-- ----------------------------
DROP TABLE IF EXISTS `api_doc`;
CREATE TABLE `api_doc` (
`id`  int(11) NOT NULL ,
`u_id`  int(11) NOT NULL ,
`create_time`  datetime NOT NULL ,
`name`  varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`project`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`flag`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
`return_eg`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL ,
`url`  varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`method`  varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `api_doc_parameter`
-- ----------------------------
DROP TABLE IF EXISTS `api_doc_parameter`;
CREATE TABLE `api_doc_parameter` (
`id`  int(11) NOT NULL ,
`ad_id`  int(11) NOT NULL ,
`name`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`isMust`  int(11) NOT NULL DEFAULT 1 ,
`introduce`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`eg`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`ad_id`) REFERENCES `api_doc` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `blog`
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
`id`  int(11) NOT NULL ,
`title`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`content`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`create_time`  datetime NOT NULL ,
`summary`  varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`ishide`  int(11) NOT NULL DEFAULT 0 ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `blog_comment`
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
`id`  int(11) NOT NULL ,
`content`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`create_time`  datetime NOT NULL ,
`u_id`  int(11) NULL DEFAULT NULL ,
`b_id`  int(11) NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `blog_list`
-- ----------------------------
DROP TABLE IF EXISTS `blog_list`;
CREATE TABLE `blog_list` (
`id`  int(11) NOT NULL ,
`name`  varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`create_time`  datetime NOT NULL ,
`bl_order`  int(11) NOT NULL ,
`u_id`  int(11) NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `blog_list_rel`
-- ----------------------------
DROP TABLE IF EXISTS `blog_list_rel`;
CREATE TABLE `blog_list_rel` (
`id`  int(11) NOT NULL ,
`bl_id`  int(11) NULL DEFAULT NULL ,
`b_id`  int(11) NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`bl_id`) REFERENCES `blog_list` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `continuous_date`
-- ----------------------------
DROP TABLE IF EXISTS `continuous_date`;
CREATE TABLE `continuous_date` (
`date`  datetime NOT NULL ,
PRIMARY KEY (`date`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `fund_history`
-- ----------------------------
DROP TABLE IF EXISTS `fund_history`;
CREATE TABLE `fund_history` (
`id`  int(11) UNSIGNED NOT NULL ,
`fi_id`  varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`time`  date NOT NULL ,
`netvalue`  double NOT NULL ,
`rate`  double NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`fi_id`) REFERENCES `fund_info` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `fund_info`
-- ----------------------------
DROP TABLE IF EXISTS `fund_info`;
CREATE TABLE `fund_info` (
`id`  varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' ,
`manager`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
`scale`  varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
`type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
`company`  varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
`grade`  int(2) NULL DEFAULT NULL ,
`buy_min`  double NULL DEFAULT NULL ,
`buy_rate`  double NULL DEFAULT NULL ,
`sellout_rate_one`  double NULL DEFAULT NULL ,
`sellout_rate_two`  double NULL DEFAULT NULL ,
`sellout_rate_three`  double NULL DEFAULT NULL ,
`manager_rate`  double NULL DEFAULT NULL ,
`create_date`  date NULL DEFAULT NULL ,
`name`  varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `fund_trade`
-- ----------------------------
DROP TABLE IF EXISTS `fund_trade`;
CREATE TABLE `fund_trade` (
`id`  int(11) UNSIGNED NOT NULL ,
`u_id`  int(11) NOT NULL ,
`fi_id`  varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`buy_money`  double NOT NULL ,
`buy_number`  double NOT NULL ,
`create_time`  datetime NOT NULL ,
`type`  varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`fi_id`) REFERENCES `fund_info` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `permission`
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
`id`  int(11) NOT NULL ,
`name`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL ,
`url`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`method`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`type`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`flag`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`menu_img`  varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`menu_order`  int(11) NULL DEFAULT NULL ,
`menu_parent_id`  int(11) NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`menu_parent_id`) REFERENCES `permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_blob_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`BLOB_DATA`  blob NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`),
FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_calendars`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`CALENDAR_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`CALENDAR`  blob NOT NULL ,
PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_cron_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`CRON_EXPRESSION`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TIME_ZONE_ID`  varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`),
FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_fired_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`ENTRY_ID`  varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`INSTANCE_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`FIRED_TIME`  bigint(13) NOT NULL ,
`SCHED_TIME`  bigint(13) NOT NULL ,
`PRIORITY`  int(11) NOT NULL ,
`STATE`  varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`JOB_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`IS_NONCONCURRENT`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`REQUESTS_RECOVERY`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_job_details`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`DESCRIPTION`  varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`JOB_CLASS_NAME`  varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`IS_DURABLE`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`IS_NONCONCURRENT`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`IS_UPDATE_DATA`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`REQUESTS_RECOVERY`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_DATA`  blob NULL ,
PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_locks`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`LOCK_NAME`  varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_paused_trigger_grps`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_scheduler_state`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`INSTANCE_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`LAST_CHECKIN_TIME`  bigint(13) NOT NULL ,
`CHECKIN_INTERVAL`  bigint(13) NOT NULL ,
PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_simple_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`REPEAT_COUNT`  bigint(7) NOT NULL ,
`REPEAT_INTERVAL`  bigint(12) NOT NULL ,
`TIMES_TRIGGERED`  bigint(10) NOT NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`),
FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_simprop_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`STR_PROP_1`  varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`STR_PROP_2`  varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`STR_PROP_3`  varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`INT_PROP_1`  int(11) NULL DEFAULT NULL ,
`INT_PROP_2`  int(11) NULL DEFAULT NULL ,
`LONG_PROP_1`  bigint(20) NULL DEFAULT NULL ,
`LONG_PROP_2`  bigint(20) NULL DEFAULT NULL ,
`DEC_PROP_1`  decimal(13,4) NULL DEFAULT NULL ,
`DEC_PROP_2`  decimal(13,4) NULL DEFAULT NULL ,
`BOOL_PROP_1`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`BOOL_PROP_2`  varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`),
FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `qrtz_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
`SCHED_NAME`  varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`JOB_GROUP`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`DESCRIPTION`  varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`NEXT_FIRE_TIME`  bigint(13) NULL DEFAULT NULL ,
`PREV_FIRE_TIME`  bigint(13) NULL DEFAULT NULL ,
`PRIORITY`  int(11) NULL DEFAULT NULL ,
`TRIGGER_STATE`  varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`TRIGGER_TYPE`  varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`START_TIME`  bigint(13) NOT NULL ,
`END_TIME`  bigint(13) NULL DEFAULT NULL ,
`CALENDAR_NAME`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`MISFIRE_INSTR`  smallint(2) NULL DEFAULT NULL ,
`JOB_DATA`  blob NULL ,
PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`),
FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `read`
-- ----------------------------
DROP TABLE IF EXISTS `read`;
CREATE TABLE `read` (
`id`  int(11) NOT NULL ,
`u_id`  int(11) NULL DEFAULT NULL ,
`b_id`  int(11) NOT NULL ,
`create_time`  datetime NOT NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`b_id`) REFERENCES `blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `role`
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
`id`  int(11) NOT NULL ,
`name`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`introduction`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`pids`  varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `timeline`
-- ----------------------------
DROP TABLE IF EXISTS `timeline`;
CREATE TABLE `timeline` (
`id`  int(11) NOT NULL ,
`u_id`  int(11) NOT NULL ,
`p_id`  int(11) NOT NULL ,
`create_time`  datetime NOT NULL ,
`info`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
PRIMARY KEY (`id`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
FOREIGN KEY (`p_id`) REFERENCES `permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `token`
-- ----------------------------
DROP TABLE IF EXISTS `token`;
CREATE TABLE `token` (
`token`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`u_id`  int(11) NOT NULL ,
`invalid_time`  datetime NOT NULL ,
PRIMARY KEY (`token`),
FOREIGN KEY (`u_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
`id`  int(11) NOT NULL ,
`usernum`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`userpass`  varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`name`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`mail`  varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`phone`  varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`isdelete`  int(11) NOT NULL DEFAULT 0 ,
`create_time`  datetime NOT NULL ,
`rids`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`img`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Compact

;

-- ----------------------------
-- Indexes structure for table api_doc
-- ----------------------------
CREATE INDEX `u_id` ON `api_doc`(`u_id`) USING BTREE ;
CREATE INDEX `idx_apiDoc_createTime` ON `api_doc`(`create_time`) USING BTREE ;
CREATE INDEX `idx_apiDoc_name` ON `api_doc`(`name`) USING BTREE ;
CREATE INDEX `idx_apiDoc_project` ON `api_doc`(`project`) USING BTREE ;
CREATE INDEX `idx_apiDoc_flag` ON `api_doc`(`flag`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table api_doc_parameter
-- ----------------------------
CREATE INDEX `ad_id` ON `api_doc_parameter`(`ad_id`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table blog
-- ----------------------------
CREATE INDEX `idx_blog_title` ON `blog`(`title`) USING BTREE ;
CREATE INDEX `idx_blog_createTime` ON `blog`(`create_time`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table blog_comment
-- ----------------------------
CREATE INDEX `u_id` ON `blog_comment`(`u_id`) USING BTREE ;
CREATE INDEX `b_id` ON `blog_comment`(`b_id`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table blog_list
-- ----------------------------
CREATE INDEX `u_id` ON `blog_list`(`u_id`) USING BTREE ;
CREATE INDEX `idx_blogList_name` ON `blog_list`(`name`) USING BTREE ;
CREATE INDEX `idx_blogList_createTime` ON `blog_list`(`create_time`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table blog_list_rel
-- ----------------------------
CREATE INDEX `bl_id` ON `blog_list_rel`(`bl_id`) USING BTREE ;
CREATE INDEX `b_id` ON `blog_list_rel`(`b_id`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table fund_history
-- ----------------------------
CREATE UNIQUE INDEX `fi_id_2` ON `fund_history`(`fi_id`, `time`) USING BTREE ;
CREATE INDEX `fi_id` ON `fund_history`(`fi_id`) USING BTREE ;
CREATE INDEX `idx_fundHistory_time` ON `fund_history`(`time`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table fund_info
-- ----------------------------
CREATE INDEX `idx_fundInfo_createDate` ON `fund_info`(`create_date`) USING BTREE ;
CREATE INDEX `idx_fundInfo_name` ON `fund_info`(`name`) USING BTREE ;
CREATE INDEX `idx_fundInfo_company` ON `fund_info`(`company`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table fund_trade
-- ----------------------------
CREATE INDEX `u_id` ON `fund_trade`(`u_id`) USING BTREE ;
CREATE INDEX `fi_id` ON `fund_trade`(`fi_id`) USING BTREE ;
CREATE INDEX `idx_fundTrade_createTime` ON `fund_trade`(`create_time`) USING BTREE ;
CREATE INDEX `idx_fundTrade_type` ON `fund_trade`(`type`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table permission
-- ----------------------------
CREATE UNIQUE INDEX `url` ON `permission`(`url`, `method`) USING BTREE ;
CREATE INDEX `menu_parent_id` ON `permission`(`menu_parent_id`) USING BTREE ;
CREATE INDEX `idx_permission_name` ON `permission`(`name`) USING BTREE ;
CREATE INDEX `idx_permission_url` ON `permission`(`url`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table qrtz_blob_triggers
-- ----------------------------
CREATE INDEX `SCHED_NAME` ON `qrtz_blob_triggers`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table qrtz_fired_triggers
-- ----------------------------
CREATE INDEX `IDX_QRTZ_FT_TRIG_INST_NAME` ON `qrtz_fired_triggers`(`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` ON `qrtz_fired_triggers`(`SCHED_NAME`, `INSTANCE_NAME`, `REQUESTS_RECOVERY`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_FT_J_G` ON `qrtz_fired_triggers`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_FT_JG` ON `qrtz_fired_triggers`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_FT_T_G` ON `qrtz_fired_triggers`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_FT_TG` ON `qrtz_fired_triggers`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table qrtz_job_details
-- ----------------------------
CREATE INDEX `IDX_QRTZ_J_REQ_RECOVERY` ON `qrtz_job_details`(`SCHED_NAME`, `REQUESTS_RECOVERY`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_J_GRP` ON `qrtz_job_details`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table qrtz_triggers
-- ----------------------------
CREATE INDEX `IDX_QRTZ_T_J` ON `qrtz_triggers`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_JG` ON `qrtz_triggers`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_C` ON `qrtz_triggers`(`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_G` ON `qrtz_triggers`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_STATE` ON `qrtz_triggers`(`SCHED_NAME`, `TRIGGER_STATE`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_N_STATE` ON `qrtz_triggers`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_N_G_STATE` ON `qrtz_triggers`(`SCHED_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_NEXT_FIRE_TIME` ON `qrtz_triggers`(`SCHED_NAME`, `NEXT_FIRE_TIME`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_NFT_ST` ON `qrtz_triggers`(`SCHED_NAME`, `TRIGGER_STATE`, `NEXT_FIRE_TIME`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_NFT_MISFIRE` ON `qrtz_triggers`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE` ON `qrtz_triggers`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_STATE`) USING BTREE ;
CREATE INDEX `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` ON `qrtz_triggers`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table read
-- ----------------------------
CREATE INDEX `u_id` ON `read`(`u_id`) USING BTREE ;
CREATE INDEX `b_id` ON `read`(`b_id`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table role
-- ----------------------------
CREATE INDEX `idx_role_name` ON `role`(`name`) USING BTREE ;
CREATE INDEX `idx_role_introduction` ON `role`(`introduction`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table timeline
-- ----------------------------
CREATE INDEX `u_id` ON `timeline`(`u_id`) USING BTREE ;
CREATE INDEX `p_id` ON `timeline`(`p_id`) USING BTREE ;
CREATE INDEX `idx_timeline_createTime` ON `timeline`(`create_time`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table token
-- ----------------------------
CREATE UNIQUE INDEX `token` ON `token`(`token`) USING BTREE ;
CREATE INDEX `u_id` ON `token`(`u_id`) USING BTREE ;

-- ----------------------------
-- Indexes structure for table users
-- ----------------------------
CREATE UNIQUE INDEX `usernum` ON `users`(`usernum`) USING BTREE ;
CREATE INDEX `idx_users_name` ON `users`(`name`) USING BTREE ;
CREATE INDEX `idx_users_createTime` ON `users`(`create_time`) USING BTREE ;
