ALTER TABLE `movie_videos` ADD `resolution` VARCHAR(255) NULL;

DROP TABLE IF EXISTS `live_banners`;
CREATE TABLE `live_banners` (
  `banner_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `text` TEXT NOT NULL,
  `ticker` tinyint(1) NOT NULL default '0',
  `show` tinyint(1) NOT NULL default '0',    
  PRIMARY KEY (`banner_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

 INSERT IGNORE INTO `settings` (`name`, `value`) VALUES
  ("movie_player_type",'element'),
  ("movie_process_type",'1');

INSERT IGNORE INTO `banwords` (`text`, `type`) VALUES
( 'messages', 'default');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'member' as `type`,
    'allow_messages' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator','admin');
  
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'livestreaming' as `type`,
    'branding_livestreaming' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator','admin');

DROP TABLE IF EXISTS `live_brands`;
CREATE TABLE `live_brands` (
  `brand_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL,
  `background_color` varchar(255) NULL,
  `text_color` varchar(255) NULL,
  `theme` varchar(255) NULL,
  `logo` varchar(255) NULL,
  `logo_active` tinyint(1) NOT NULL default '1',
  `overlay` varchar(255) NULL,
  `overlay_active` tinyint(1) NOT NULL default '1',
  `redirect_url` varchar(255) NULL,
  PRIMARY KEY (`brand_id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `message_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) UNSIGNED NOT NULL,
  `resource_id` int(11) UNSIGNED NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`message_id`),
  KEY `user_resource_id` (`user_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `messages_texts`;
CREATE TABLE `messages_texts` (
  `messages_text_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `message_id` int(11) UNSIGNED NOT NULL,
  `message` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `seen` tinyint(1) NOT NULL DEFAULT 0,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`messages_text_id`),
  KEY `message_id` (`message_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

