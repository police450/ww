ALTER TABLE `channelvideoimports` ADD `owner_email` VARCHAR(255) NULL AFTER `creation_date`, ADD `owner_language` VARCHAR(255) NULL AFTER `owner_email`, ADD `owner_displayname` VARCHAR(255) NULL AFTER `owner_language`;

DROP TABLE IF EXISTS `stories`;
CREATE TABLE `stories` (
  `story_id` int(11) unsigned NOT NULL auto_increment,
  `owner_id` int(11) unsigned NOT NULL,
  `type` tinyint(1) unsigned NOT NULL default '0' COMMENT '0-photo,1-video,2-audio,3-text',
  `file` varchar(255) NOT NULL default '',
  `audio_id` int(11) unsigned NOT NULL default '0',
  `image` varchar(255) NULL default '',
  `status` tinyint(1) NOT NULL default '1',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `background_image` int(11) unsigned NOT NULL default '0',
  `font` VARCHAR(40) NULL,
  `seemore` VARCHAR(255) NULL,
  `text_color` varchar(255) NOT NULL default '#ffffff',
  `view_privacy` VARCHAR(24) NOT NULL,
  `view_count` int(11) unsigned NOT NULL default '0',
  `comment_count` int(11) unsigned NOT NULL default '0',
  `like_count` int(11) unsigned NOT NULL default '0',
  `dislike_count` int(11) unsigned NOT NULL default '0',   
  `approve` tinyint NOT NULL default '1',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`story_id`),
  KEY `view_privacy` (`view_privacy`),
  KEY `owner_id` (`owner_id`),
  KEY `approve` (`approve`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `stories_user_settings`;
CREATE TABLE `stories_user_settings` (
  `setting_id` int(11) unsigned NOT NULL auto_increment,
  `owner_id` int(11) unsigned NOT NULL,
  `privacy` int(11) unsigned NOT NULL,
  PRIMARY KEY (`setting_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS `stories_users`;
CREATE TABLE `stories_users` (
  `user_id` int(11) unsigned NOT NULL auto_increment,
  `owner_id` int(11) unsigned NOT NULL,
  `story_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UNIQUE` (`owner_id`,`story_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `stories_muted`;
CREATE TABLE `stories_muted` (
  `mute_id` int(11) unsigned NOT NULL auto_increment,
  `owner_id` int(11) unsigned NOT NULL,
  `resource_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`mute_id`),
  KEY `owner_id` (`owner_id`),
  KEY `resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `stories_attachments`;
CREATE TABLE `stories_attachments` (
  `attachment_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) NULL,
  `file` varchar(255) NOT NULL,
  `type` varchar(45) NOT NULL default 'background_image',
  `approve` TINYINT(1) NOT NULL DEFAULT '1',
  `order` int(12) NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `type` (`type`),
  KEY `order` (`order`),
  KEY `approve` (`approve`),
  KEY `approveOrder` (`approve`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT INTO `stories_attachments` ( `file`, `type`, `approve`, `order`, `creation_date`) VALUES
( '/upload/images/stories/background/1646241557616_40351129_2163632410574708_8668634735213281280_n.jpeg', 'background_image', 1, 4, NOW()),
( '/upload/images/stories/background/1646241561528_40405650_452537128572519_8149774588180430848_n.jpeg', 'background_image', 1, 5, NOW()),
( '/upload/images/stories/background/1646241564100_40514084_525804507859140_4376480479583404032_n.jpeg', 'background_image', 1, 6, NOW()),
( '/upload/images/stories/background/1646241566874_43877190_291719124775874_7179372009489432576_n.jpeg', 'background_image', 1, 7, NOW()),
( '/upload/images/stories/background/1646241570356_51617388_1009318305928625_4482986936855691264_n.jpeg', 'background_image', 1, 8, NOW()),
( '/upload/images/stories/background/1646241575225_51627537_2013736385406998_2008135126298394624_n.jpeg', 'background_image', 1, 9, NOW()),
('/upload/images/stories/background/1646241578074_51628925_241165290132952_3577861053540728832_n.jpeg', 'background_image', 1, 10, NOW()),
( '/upload/images/stories/background/1646241582010_51695285_459530724584487_5283635580326903808_n.jpeg', 'background_image', 1, 11, NOW()),
( '/upload/images/stories/background/1646241584865_51704502_299352557433930_1558310591364333568_n.jpeg', 'background_image', 1, 12, NOW()),
( '/upload/images/stories/background/1646241587519_51709960_316152732351370_2886250832167174144_n.jpeg', 'background_image', 1, 13, NOW()),
( '/upload/images/stories/background/1646241597712_51721060_1793841944061295_1063735769971032064_n.jpeg', 'background_image', 1, 14, NOW()),
( '/upload/images/stories/background/1646241601937_51756802_367314947184741_2104938466470002688_n.jpeg', 'background_image', 1, 15, NOW()),
( '/upload/images/stories/background/1646241604716_51803344_2173297949665928_4264557780788051968_n.jpeg', 'background_image', 1, 16, NOW()),
( '/upload/images/stories/background/1646241607674_64573208_318989072361867_7052361760598130688_n.jpeg', 'background_image', 1, 17, NOW());

DROP TABLE IF EXISTS `tools_announcements`;
CREATE TABLE `tools_announcements` (
  `announcement_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level_id` varchar(100) NULL,
  `start_time` datetime NULL,
  `end_time` datetime NULL,
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`announcement_id`),
  KEY `level_id` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `tools_mass_notifications`;
CREATE TABLE `tools_mass_notifications` (
  `mass_notification_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level_id` varchar(100) NULL,
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`mass_notification_id`),
  KEY `level_id` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT IGNORE INTO `notificationtypes` ( `type`, `body`, `content_type`, `vars`) VALUES
( 'admin_custom_notification', '', 'default', '{}');

DROP TABLE IF EXISTS `tools_channel_subscribe`;
CREATE TABLE `tools_channel_subscribe` (
  `channel_subscribe_id` int(11) unsigned NOT NULL auto_increment,
  `channel_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`channel_subscribe_id`),
  KEY `channel_id` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `tools_user_subscribe`;
CREATE TABLE `tools_user_subscribe` (
  `user_subscribe_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`user_subscribe_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `tools_delete_videos`;
CREATE TABLE `tools_delete_videos` (
  `delete_video_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level_id` varchar(100) NULL,
  `category_id` int(11) unsigned NOT NULL default '0',
  `subcategory_id` int(11) unsigned NOT NULL default '0',
  `subsubcategory_id` int(11) unsigned NOT NULL default '0',
  `tags` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `time_interval` TINYINT(10) unsigned NOT NULL,
  `time_duration` varchar(255) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '0',
  `last_process_video_id` INT(11) UNSIGNED NULL DEFAULT '0',
  `delete_video_count` INT(11) UNSIGNED NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`delete_video_id`),
  KEY `time_interval_duration` (`time_interval`,`time_duration`),
  KEY `level_id` (`level_id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `tools_remove_videos`;
CREATE TABLE `tools_remove_videos` (
  `remove_video_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `sitename` varchar(255) NOT NULL default '',
  `time_interval` TINYINT(10) unsigned NOT NULL,
  `time_duration` varchar(255) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '0',
  `last_process_video_id` INT(11) UNSIGNED NULL DEFAULT '0',
  `delete_video_count` INT(11) UNSIGNED NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`remove_video_id`),
  KEY `time_interval_duration` (`time_interval`,`time_duration`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `tools_newsletters`;
CREATE TABLE `tools_newsletters` (
  `newsletter_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level_id` varchar(100) NULL,
  `gender` varchar(45) NULL default '',
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `last_process_user_id` INT(11) UNSIGNED NULL DEFAULT '0',
  `member_count` INT(11) UNSIGNED NULL DEFAULT '0',
  `active` TINYINT(1) NOT NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`newsletter_id`),
  KEY `level_id` (`level_id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


INSERT IGNORE INTO `tasks` ( `type`, `started`, `start_time`, `timeout`, `priority`) VALUES
('autoDeleteVideos',0,NULL,300,1),
('autoDeleteImportedVideos',0,NULL,300,1),
('newsletters',0,NULL,300,1);

DROP TABLE IF EXISTS `backups`;
CREATE TABLE `backups` (
  `backup_id` int(11) unsigned NOT NULL auto_increment,
  `dirname` varchar(100) NOT NULL,
  `creation_date` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`backup_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT IGNORE INTO `settings` (`name`, `value`) VALUES
  ("enable_stories",'1'),
  ("stories_audio_image",'1'),
  ("stories_video_image",'1'),
  ("stories_duration",'1'),
  ("stories_delay",'10'),
  ("stories_video_upload",'10'),
  ("stories_audio_upload",'5');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'delete' as `name`,
    2 as `value`
  FROM `levels` WHERE `type` IN('admin');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'delete' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator');

  INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'view' as `name`,
    2 as `value`
  FROM `levels` WHERE `type` IN('admin');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'view' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'create' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator','admin');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'stories' as `type`,
    'allowed_types' as `name`,
    'image,video,music' as `value`
  FROM `levels` WHERE `type` IN('user','moderator','admin');