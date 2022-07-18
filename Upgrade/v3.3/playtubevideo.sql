ALTER TABLE `channelvideos` ADD INDEX `searchIndex` (`channel_id`,`video_id`);
ALTER TABLE `channelplaylists` ADD INDEX `searchIndex` (`channel_id`,`playlist_id`);
ALTER TABLE `playlistvideos` ADD INDEX `searchIndex` (`playlist_id`,`video_id`);
ALTER TABLE `followers` ADD INDEX `searchIndex` (`type`,`id`,`owner_id`);
ALTER TABLE `favourites` ADD INDEX `searchIndex` (`type`,`id`,`owner_id`);
ALTER TABLE `watchlaters` ADD INDEX `searchIndex` (`id`,`owner_id`,`type`);
ALTER TABLE `ratings` ADD INDEX `searchIndex` (`type`,`id`,`owner_id`);
ALTER TABLE `likes` ADD INDEX `searchIndex` (`type`,`id`,`owner_id`);

ALTER TABLE `transactions` ADD INDEX `searchIndex` (`state`,`sender_id`,`type`);
ALTER TABLE `transactions` ADD INDEX `id` (`id`);
ALTER TABLE `subscriptions` ADD INDEX `package_id` (`package_id`);
ALTER TABLE `subscriptions` ADD INDEX `searchIndex` (`status`,`type`,`owner_id`);

ALTER TABLE `videos` ADD INDEX `dislike_count` (`dislike_count`);
ALTER TABLE `movies` ADD INDEX `movie_id` (`movie_id`);
ALTER TABLE `blogs` ADD INDEX `blog_id` (`blog_id`);
ALTER TABLE `playlists` ADD INDEX `playlist_id` (`playlist_id`);
ALTER TABLE `channels` ADD INDEX `channel_id` (`channel_id`);

INSERT IGNORE INTO `pages` ( `type`, `label`, `title`, `url`, `description`, `keywords`, `image`, `content`, `view_count`, `custom`, `banner_image`, `banner`) VALUES
( 'messages_browse', 'Messages', 'Messages', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'blog_view', 'Blog View Page', 'Blog View', NULL, '', '', NULL, NULL, 0, 0, 0, NULL);

DROP TABLE IF EXISTS `user_tokens`;
CREATE TABLE `user_tokens`(
  `token_id` int(11) unsigned NOT NULL auto_increment,
  `token` varchar(255) NOT NULL DEFAULT "",
  `owner_id` int(11) NOT NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `token_id` (`token`),
  KEY `modified_date` (`modified_date`),
  KEY `owner_id` (`owner_id`),
  KEY `modified_owner_id` (`owner_id`,`modified_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;