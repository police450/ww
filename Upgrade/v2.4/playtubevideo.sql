DROP TABLE IF EXISTS `chat_ban_users`;
CREATE TABLE `chat_ban_users` (
  `ban_id` int(11) unsigned NOT NULL auto_increment,
  `user_id` int(11) unsigned NOT NULL default '0',
  `chat_id` varchar(255) NOT NULL,
  PRIMARY KEY (`ban_id`),
  UNIQUE KEY `unique` (`chat_id`,`user_id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS `otp_code`;
CREATE TABLE `otp_code` (
  `code_id` int(11) unsigned NOT NULL auto_increment,
  `code` varchar(10) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`code_id`),
  KEY `phone` (`phone_number`,`code`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

ALTER TABLE `referers` ADD `content_id` INT(11) UNSIGNED NOT NULL AFTER `ip`;
ALTER TABLE `file_manager` ADD `orgName` VARCHAR(255) NULL;
ALTER TABLE `defaultstreaming` ADD `price` VARCHAR(255) NULL ;


INSERT INTO `notificationtypes` ( `type`, `body`, `content_type`, `vars`) VALUES
( 'videos_create', 'Uploaded new Video.', 'default', '{}'),
( 'channels_create', 'Created new Channel.', 'default', '{}'),
( 'playlists_create', 'Created new Playlist.', 'default', '{}'),
( 'blogs_create', 'Created new Blog.', 'default', '{}'),
( 'audio_create', 'Uploaded new Audio.', 'default', '{}'),
( 'go_live', 'Go Live.', 'default', '{}'),
( 'bankdetails_videopurchase_approved', 'Your Bank Transfer request for Video Purchase is approved.', 'default', '{}'),
( 'bankdetails_rechargewallet_approved', 'Your Bank Transfer request for Wallet Recharge is approved.', 'default', '{}'),
( 'bankdetails_membersubscription_approved', 'Your Bank Transfer request for Member Subscription is approved.', 'default', '{}'),
( 'bankdetails_channelsubscription_approved', 'Your Bank Transfer request for Channel Support is approved.', 'default', '{}');

DROP TABLE IF EXISTS `bankdetails`;
CREATE TABLE `bankdetails` (
  `bank_id` int(11) unsigned NOT NULL auto_increment,
  `owner_id` int(11) unsigned NOT NULL,
  `resource_type` varchar(255) not null,
  `resource_id` varchar(255) not null,
  `package_id` INT(11) NOT NULL DEFAULT '0',
  `price` varchar(255) NOT NULL,
  `currency` varchar(255) NOT NULL,
  `type` varchar(45) NOT NULL,
  `creation_date` datetime NOT NULL,
  `approve_date` datetime NOT NULL,
  `image` varchar(255) NOT NULL,
  `status` tinyint (1) NOT NULL default '0',
  PRIMARY KEY (`bank_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


INSERT INTO `emailtemplates` ( `content_type`, `type`, `vars`) VALUES
( 'default', 'bankdetails_videopurchase_approved', '{}'),
( 'default', 'bankdetails_rechargewallet_approved', '{}'),
( 'default', 'bankdetails_membersubscription_approved', '{}'),
( 'default', 'bankdetails_channelsubscription_approved', '{}');

ALTER TABLE `transactions` DROP INDEX `unique`;

INSERT INTO `settings` (`name`, `value`) VALUES
('points_value','0'),
('signup_referrals','1'),
('referrals_points_value','0'),
('payment_bank_method_description1','Account Name:
Account Number:
Bank Name:
Branch Address of Bank:
IFSC Code:'),
('payment_bank_method_note','Upload your bank transfer receipt so we will verify and confirm your order.');

DROP TABLE IF EXISTS `point_settings`;
CREATE TABLE `point_settings` (
  `point_id` int(11) UNSIGNED NOT NULL auto_increment,
  `level_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `resource_type` varchar(45) NOT NULL,
  `first_time` int(11) NOT NULL default '0',
  `next_time` int(11) NOT NULL default '0',
  `max` int(11) NOT NULL default '0',
  `deduct` int(11) NOT NULL default '0',
  `approve` tinyint(1) NOT NULL default '0',
  PRIMARY KEY (`point_id`),
  UNIQUE KEY `UNIQUE` (`resource_type`,`level_id`,`type`),
  KEY `approve` (`approve`),
  KEY `resource_type` (`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `user_point_values`;
CREATE TABLE `user_point_values` (
  `value_id` int(11) UNSIGNED NOT NULL auto_increment,
  `owner_id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `resource_type` varchar(45) NOT NULL,
  `resource_id` int(11) NOT NULL,
  `credit` int(11) NOT NULL default '0',
  `debit` int(11) NOT NULL default '0',
  `receiver_id` int(11) NOT NULL default '0',
  `sender_id` int(11) NOT NULL default '0',
  `custom` text NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `owner_id` (`owner_id`),
  KEY `resource_type` (`resource_type`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `users` ADD `points` INT(11) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD `affiliate_id` INT(11) UNSIGNED NOT NULL DEFAULT '0';

INSERT INTO `menus` ( `submenu_id`, `subsubmenu_id`, `label`, `params`, `customParam`, `target`, `url`, `enabled`, `order`, `icon`, `custom`, `type`,`content_type`) VALUES
( 0, 0, 'Instagram', NULL, NULL, '_self', 'javascript:void(0)', 1, 6, 'fab fa-instagram', 0, 4,NULL);