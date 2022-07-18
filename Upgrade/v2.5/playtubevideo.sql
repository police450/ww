DROP TABLE IF EXISTS `member_plans`;
CREATE TABLE `member_plans` (
  `member_plan_id` int(11) UNSIGNED NOT NULL auto_increment,
  `owner_id` int(11) UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `video_categories` TEXT NULL,
  `plan_type` varchar(255) NOT NULL DEFAULT 'month',
  `image` varchar(255) NULL,
  `price` decimal(8,2) NOT NULL, 
  `is_default` tinyint(0) NOT NULL default '0', 
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`member_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `member_plans` (`owner_id`, `title`, `description`, `image`, `price`,`is_default`,`creation_date`,`modified_date`)  SELECT `user_id`,"Free Plan","This is a free plan.",null,'0',1,NOW(),NOW() from users;

ALTER TABLE `subscriptions` ADD INDEX(`owner_id`,`type`,`id`,`status`);

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'member' as `type`,
    'allow_create_subscriptionplans' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','admin','moderator');


  INSERT INTO `settings` (`name`, `value`) VALUES
('default_member_plan','/resources/128937918273923_userPlan.png'),
("member_cancel_user_subscription","1");

INSERT INTO `file_manager` ( `path`,`orgName`) VALUES
( '/resources/128937918273923_userPlan.png','userPlan.png');

INSERT IGNORE INTO `banwords` (`text`, `type`) VALUES
( 'subscription', 'default');

ALTER TABLE `playlists` ADD `view_privacy` VARCHAR(255) NULL;

INSERT INTO `notificationtypes` ( `type`, `body`, `content_type`, `vars`) VALUES
( 'bankdetails_usersubscribe_approved', 'Your Bank Transfer request for Member Subscription is approved.', 'default', '{}');

INSERT INTO `emailtemplates` ( `content_type`, `type`, `vars`) VALUES
( 'default', 'bankdetails_usersubscribe_approved', '{}');