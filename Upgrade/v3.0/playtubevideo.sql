ALTER TABLE `videos` ADD `scheduled` VARCHAR(25) NULL,ADD `antmedia_app` VARCHAR(25) NULL default 'LiveApp';

DROP TABLE IF EXISTS `movies_imports`;
CREATE TABLE `movies_imports` (
  `import_id` int(11) unsigned NOT NULL auto_increment,
  `type` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL,  
  `modified_date` datetime NOT NULL,
  `page` int(11) unsigned NOT NULL,
  PRIMARY KEY (`import_id`),
  UNIQUE KEY `unique` (`type`,`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT IGNORE INTO `movies_imports` (`type`, `category`,`modified_date`,`page`) VALUES
( 'movie', 'popular',NOW() - INTERVAL 10 DAY,1),
( 'movie', 'top_rated',NOW() - INTERVAL 10 DAY,1),
( 'movie', 'upcoming',NOW() - INTERVAL 10 DAY,1),
( 'movie', 'now_playing',NOW() - INTERVAL 10 DAY,1),
( 'tv', 'popular',NOW() - INTERVAL 10 DAY,1),
( 'tv', 'top_rated',NOW() - INTERVAL 10 DAY,1),
( 'tv', 'on_the_air',NOW() - INTERVAL 10 DAY,1),
( 'tv', 'airing_today',NOW() - INTERVAL 10 DAY,1);

DROP TABLE IF EXISTS `scheduled_videos`;
CREATE TABLE `scheduled_videos` (
  `scheduled_video_id` int(11) unsigned NOT NULL auto_increment,
  `video_id` int(11) unsigned NOT NULL,
  `owner_id` int(11) unsigned NOT NULL default '0',  
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`scheduled_video_id`),
  UNIQUE KEY `unique` (`video_id`,`owner_id`),
  KEY `video_id` (`video_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT INTO `member_plans` (`owner_id`, `title`, `description`, `image`, `price`,`is_default`,`creation_date`,`modified_date`)  SELECT `user_id`,"Free Plan","This is a free plan.",null,'0',1,NOW(),NOW() from users LEFT JOIN member_plans ON member_plans.owner_id = users.user_id AND member_plans.price = 0 WHERE member_plans.owner_id IS NULL;

ALTER TABLE `categories` ADD `show_movies` tinyint(1) NOT NULL DEFAULT '0', ADD `show_series` tinyint(1) NOT NULL  DEFAULT '0';
ALTER TABLE `watchlaters` ADD `type` VARCHAR(40) NOT NULL DEFAULT 'video' AFTER `owner_id`;
ALTER TABLE `watchlaters` DROP INDEX `unique`, ADD UNIQUE KEY `unique` (`id`,`type`,`owner_id`);

INSERT IGNORE INTO `banwords` (`text`, `type`) VALUES
( 'movies', 'default'),
( 'series', 'default'),
( 'cast', 'default'),
( 'crew', 'default');

DROP TABLE IF EXISTS `channelvideoimports`;
CREATE TABLE `channelvideoimports` (
  `channelvideoimport_id` int(11) unsigned NOT NULL auto_increment,
  `channel_id` varchar(255) NULL,
  `owner_id` int(11) NOT NULL default '0',
  `importchannel_id` varchar(255) NOT NULL,
  `params` TEXT NULL,
  `error_description` TEXT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`channelvideoimport_id`),
  KEY `channel_id` (`channel_id`),
  KEY `importchannel_id` (`importchannel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

INSERT IGNORE INTO `tasks` ( `type`, `started`, `start_time`, `timeout`, `priority`) VALUES
('movieVideoEncode',0,NULL,15,1),
('channelVideoImport',0,NULL,15,1),
('movieImportIMDB',0,NULL,43200,1);

INSERT INTO `file_manager` ( `path`,`orgName`) VALUES
(  '/resources/1607062990688_78ug9n_episodes.jpg','episodes.jpg'),
(  '/resources/1607062995120_5c5v1p_movies.jpg','movies.jpg');

 INSERT IGNORE INTO `settings` (`name`, `value`) VALUES
  ("file_cache",'11293871928'),
  ("antserver_media_app",'LiveApp'),
  ('enable_movie', '1'),
  ('cast_crew_member', '1'),
  ('cast_crew_member_comment', '1'),
  ('cast_crew_member_comment_dislike', '1'),
  ('cast_crew_member_comment_like', '1'),
  ('cast_crew_member_dislike', '1'),
  ('cast_crew_member_favourite', '1'),
  ('cast_crew_member_like', '1'),
  ('cast_crew_member_rating', '1'),
  ('episode_default_photo', '/resources/1607062990688_78ug9n_episodes.jpg'),
  ('cast_crew_default_photo', '/resources/1607062990688_78ug9n_episodes.jpg'),
  ('movie_adult', '1'),
  ('movie_category_default_photo', '/resources/1607062995120_5c5v1p_movies.jpg'),
  ('movie_comment', '1'),
  ('movie_comment_dislike', '1'),
  ('movie_comment_like', '1'),
  ('movie_commission_rent_type', '1'),
  ('movie_commission_rent_value', '0'),
  ('movie_commission_type', '1'),
  ('movie_commission_value', '0'),
  ('movie_conversion_type', 'ultrafast'),
  ('movie_conversion_type_label', ''),
  ('movie_default_photo', '/resources/1607062995120_5c5v1p_movies.jpg'),
  ('movie_dislike', '1'),
  ('movie_favourite', '1'),
  ('movie_featured', '1'),
  ('movie_hot', '1'),
  ('movie_like', '1'),
  ('movie_rating', '1'),
  ('movie_rent', '1'),
  ('movie_sell', '1'),
  ('movie_sponsored', '1'),
  ('movie_upload_limit', '0'),
  ('movie_upload_movies_type', '360,480,720'),
  ('movie_watchlater', '1'),
  ('seasons_default_photo', '/resources/1607062990688_78ug9n_episodes.jpg');

INSERT IGNORE INTO `menus` ( `submenu_id`, `subsubmenu_id`, `label`, `params`, `customParam`, `target`, `url`, `enabled`, `order`, `icon`, `custom`, `type`,`content_type`) VALUES
( 0, 0, 'Movies', NULL, '', '_self', '/movies', 0, 4, 'fa fa-film', 1, 1,'movies'),
( 0, 0, 'Series', NULL, '', '_self', '/series', 0, 5, 'fa fa-tv', 1, 1,'movies'),
( 7, 0, 'Movies & Series', '/categories', 'type=movies-series', '_self', '/movies-series/categories', 1, 2, '', 0, 1,'movies'),
( 0, 0, 'Cast & Crew', NULL, '', '_self', '/cast-and-crew', 1, 1, 'fa fa-user', 0, 1,'movies');


INSERT IGNORE INTO `pages` ( `type`, `label`, `title`, `url`, `description`, `keywords`, `image`, `content`, `view_count`, `custom`, `banner_image`, `banner`) VALUES
( 'movie_create', 'Movies Create Page', 'Create Movie', '', '', NULL, '', '0', 0, 0, 0, NULL),
( 'series_create', 'Series Create Page', 'Create Series', '', '', NULL, '', '0', 0, 0, 0, NULL),
( 'movies_browse', 'Movies Browse Page', 'Movies', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'season_browse', 'Seasons Browse Page', 'Seasons', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'movies_series_trailers', 'Trailers Browse Page', 'Trailers', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'movies_series_episodes', 'Episodes Browse Page', 'Episodes', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'movie_edit', 'Movie Edit Page', 'Edit Movie', NULL, '', '', NULL, NULL, 0, 0, 1, NULL),
( 'series_edit', 'Series Edit Page', 'Edit Series', NULL, '', '', NULL, NULL, 0, 0, 1, NULL),
( 'series_browse', 'Series Browse Page', 'Series', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'cast_crew_browse', 'Cast & Crew Browse Page', 'Cast & Crew', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'movies_series_view', 'Movies View Page', '', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'cast_crew_view', 'Cast & Crew View Page', '', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'browse_movie_series_category_view', 'Movies & Series Browse Category Page', 'Movies & Series Categories', NULL, '', '', NULL, NULL, 0, 0, 0, NULL),
( 'movie_series_category_view', 'Movies & Series Category View Page', '', NULL, '', '', NULL, NULL, 0, 0, 0, NULL);


INSERT IGNORE INTO `notificationtypes` ( `type`, `body`, `content_type`, `vars`) VALUES

(  'scheduled_live', '{videos} scheduled by {subject}.','livestreaming', '{\"videos\":\"Live Streaming\"}'),
(  'live_video', '{subject} started a live {videos}.','livestreaming', '{\"videos\":\"Live Streaming\"}'),
(  'livestream_purchased', 'You just grabed a ticket for {videos}. We hope you enjoy this experience.','livestreaming', '{\"videos\":\"Live Streaming\"}'),
(  'livestream_purchased_owner','Your {videos} is purchased by {subject}.','livestreaming', '{\"videos\":\"Live Streaming\"}'),
(  'video_purchased','Thanks for purchasing {videos}.','videos', '{\"videos\":\"video\"}'),
(  'video_purchased_owner','Your {videos} is purchased by {subject}.','videos', '{\"videos\":\"video\"}'),
(  'livestreaming_live','{videos} is live now.','livestreaming', '{\"videos\":\"Live Streaming\"}'),
(  'movie_purchased','Thanks for purchasing {movies}.','movies', '{\"movies\":\"movie\"}'),
(  'movie_purchased_owner','Your {movies} is purchased by {subject}.','movies', '{\"movies\":\"movie\"}'),
(  'movie_rent_purchased','Thanks for purchasing {movies} on rent.','movies', '{\"movies\":\"movie\"}'),
(  'movie_rent_purchased_owner','Your {movies} is purchased by {subject}.','movies', '{\"movies\":\"movie\"}'),
(  'series_purchased','Thanks for purchasing {movies}.','movies', '{\"movies\":\"series\"}'),
(  'series_purchased_owner','Your {movies} is purchased by {subject}.','movies', '{\"movies\":\"series\"}'),
(  'series_rent_purchased','Thanks for purchasing {movies} on rent.','movies', '{\"movies\":\"series\"}'),
(  'series_rent_purchased_owner','Your {movies} is purchased by {subject}.','movies', '{\"movies\":\"series\"}'),
(  'wallet_recharge','Wallet recharged successfully.','members', '{}'),

( 'movies_create', 'Created new Movie.', 'default', '{}'),
( 'series_create', 'Created new Series.', 'default', '{}'),
( 'admin_videos_channel_import_complete', 'Videos imported successfully from Youtube Channel.', 'default', '{}'),
( 'videos_channel_import_error', 'Error importing your videos.', 'default', '{}'),
( 'videos_channel_import_complete', 'Videos Imported successfully in your {channels}.', 'default', '{\"channels\":\"channel\"}'),
( 'movies_like', '{subject} likes your {movies}.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_dislike', '{subject} dislike your {movies}.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_comments_like', '{subject} likes your {comment} on your {movies} {comment_title}.', 'movies', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies_comments_dislike', '{subject} dislike your {comment} on your {movies} {comment_title}.', 'movies', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies_reply_like', '{subject} likes your {reply} on {comment} {reply_title}.', 'movies', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'movies_reply_dislike', '{subject} dislike your {reply} on {comment} {reply_title}.', 'movies', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'movies_reply_comment', '{subject} replied to your {comment} on your {movies} {reply_title}', 'movies', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies_comment', '{subject} commented on your {movies} {comment_title}.', 'movies', '{\"movies\":\"movie\"}'),
( 'movievideos_processed_complete', 'We have completed processing your {movies} video.', 'movies', '{\"movies\":\"movie\"}'),
( 'movievideos_processed_failed', 'We are having trouble processing to your {movies} video.', 'movies', '{\"movies\":\"movie\"}'),
( 'purchase_series_purchase_approved', 'Your Bank Transfer request for Series Purchased is approved.', 'default', '{}'),
( 'purchase_movie_purchase_approved', 'Your Bank Transfer request for Movie Purchased is approved.', 'default', '{}'),
( 'rent_series_purchase_approved', 'Your Bank Transfer request for Rent Series is approved.', 'default', '{}'),
( 'rent_movie_purchase_approved', 'Your Bank Transfer request for Rent Movie is approved.', 'default', '{}'),
( 'movies_admin_approved', 'Site Admin approved your {movies}.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_admin_disapproved', 'Site Admin disapproved your {movies}.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_featured', 'Site Admin marked your {movies} as Featured.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_sponsored', 'Site Admin marked your {movies} as Sponsored.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_hot', 'Site Admin marked your {movies} as Hot.', 'movies', '{\"movies\":\"movie\"}'),
( 'movies_favourite', '{subject} marked your {movies} to Favourite.', 'movies', '{\"movies\":\"movie\"}'),

( 'series_like', '{subject} likes your {movies}.', 'series', '{\"movies\":\"series\"}'),
( 'series_dislike', '{subject} dislike your {movies}.', 'series', '{\"movies\":\"series\"}'),
( 'series_comments_like', '{subject} likes your {comment} on your {movies} {comment_title}.', 'series', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series_comments_dislike', '{subject} dislike your {comment} on your {movies} {comment_title}.', 'series', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series_reply_like', '{subject} likes your {reply} on {comment} {reply_title}.', 'series', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'series_reply_dislike', '{subject} dislike your {reply} on {comment} {reply_title}.', 'series', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'series_reply_comment', '{subject} replied to your {comment} on your {movies} {reply_title}', 'series', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series_comment', '{subject} commented on your {movies} {comment_title}.', 'series', '{\"movies\":\"series\"}'),
( 'seriesvideos_processed_complete', 'We have completed processing your {movies} video.', 'series', '{\"movies\":\"series\"}'),
( 'seriesvideos_processed_failed', 'We are having trouble processing to your {movies} video.', 'series', '{\"movies\":\"series\"}'),
( 'series_admin_approved', 'Site Admin approved your {movies}.', 'series', '{\"movies\":\"series\"}'),
( 'series_admin_disapproved', 'Site Admin disapproved your {movies}.', 'series', '{\"movies\":\"series\"}'),
( 'series_featured', 'Site Admin marked your {movies} as Featured.', 'series', '{\"movies\":\"series\"}'),
( 'series_sponsored', 'Site Admin marked your {movies} as Sponsored.', 'series', '{\"movies\":\"series\"}'),
( 'series_hot', 'Site Admin marked your {movies} as Hot.', 'series', '{\"movies\":\"series\"}'),
( 'series_favourite', '{subject} marked your {movies} to Favourite.', 'series', '{\"movies\":\"series\"}'),
( 'videos_reminder', '{videos} is live now.', 'livestreaming', '{\"videos\":\"Live Streaming\"}');



INSERT IGNORE INTO `emailtemplates` ( `content_type`, `type`, `vars`) VALUES
( 'livestreaming', 'scheduled_live', '{\"videos\":\"Live Streaming\"}'),
( 'livestreaming', 'live_video', '{\"videos\":\"Live Streaming\"}'),
( 'livestreaming', 'livestream_purchased', '{\"videos\":\"Live Streaming\"}'),
( 'livestreaming', 'livestream_purchased_owner', '{\"videos\":\"Live Streaming\"}'),
( 'videos', 'video_purchased', '{\"videos\":\"video\"}'),
( 'videos', 'video_purchased_owner', '{\"videos\":\"video\"}'),
( 'livestreaming', 'livestreaming_live', '{\"videos\":\"Live Streaming\"}'),
( 'movies', 'movie_purchased', '{\"movies\":\"movie\"}'),
( 'movies', 'movie_purchased_owner', '{\"movies\":\"movie\"}'),
( 'movies', 'movie_rent_purchased', '{\"movies\":\"movie\"}'),
( 'movies', 'movie_rent_purchased_owner', '{\"movies\":\"movie\"}'),
( 'movies', 'series_purchased', '{\"movies\":\"series\"}'),
( 'movies', 'series_purchased_owner', '{\"movies\":\"series\"}'),
( 'movies', 'series_rent_purchased', '{\"movies\":\"series\"}'),
( 'movies', 'series_rent_purchased_owner', '{\"movies\":\"series\"}'),
( 'members', 'wallet_recharge', '{}'),

( 'default','admin_videos_channel_import_complete', '{}'),
( 'default', 'videos_channel_import_error', '{}'),
( 'default', 'videos_channel_import_complete', '{\"channels\":\"channel\"}'),
( 'default','bankdetails_moviepurchase_approved', '{}'),
( 'default','bankdetails_rentmovie_approved', '{}'),
( 'livestreaming','live_admin_approved', '{\"videos\":\"Live Streaming\"}'),
( 'livestreaming','live_admin_disapproved', '{\"videos\":\"Live Streaming\"}'),
( 'movies', 'movies_like', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_dislike', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_comments_like', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies', 'movies_comments_dislike', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies', 'movies_reply_like', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'movies', 'movies_reply_dislike', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'movies', 'movies_reply_comment', '{\"movies\":\"movie\",\"comment\":\"comment\"}'),
( 'movies', 'movies_comment', '{\"movies\":\"movie\"}'),
( 'movies', 'movievideos_processed_complete', '{\"movies\":\"movie\"}'),
( 'movies', 'movievideos_processed_failed', '{\"movies\":\"movie\"}'),
( 'default', 'purchase_series_purchase_approved', '{}'),
( 'default', 'purchase_movie_purchase_approved', '{}'),
( 'default', 'rent_series_purchase_approved', '{}'),
( 'default', 'rent_movie_purchase_approved', '{}'),
( 'movies', 'movies_admin_approved', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_admin_disapproved', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_featured', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_sponsored', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_hot', '{\"movies\":\"movie\"}'),
( 'movies', 'movies_favourite', '{\"movies\":\"movie\"}'),
( 'series', 'series_like', '{\"movies\":\"series\"}'),
( 'series', 'series_dislike', '{\"movies\":\"series\"}'),
( 'series', 'series_comments_like', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series', 'series_comments_dislike', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series', 'series_reply_like', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'series', 'series_reply_dislike', '{\"reply\":\"reply\",\"comment\":\"comment\"}'),
( 'series', 'series_reply_comment', '{\"movies\":\"series\",\"comment\":\"comment\"}'),
( 'series', 'series_comment', '{\"movies\":\"series\"}'),
( 'series', 'seriesvideos_processed_complete', '{\"movies\":\"series\"}'),
( 'series', 'seriesvideos_processed_failed', '{\"movies\":\"series\"}'),
( 'series', 'series_admin_approved', '{\"movies\":\"series\"}'),
( 'series', 'series_admin_disapproved', '{\"movies\":\"series\"}'),
( 'series', 'series_featured', '{\"movies\":\"series\"}'),
( 'series', 'series_sponsored', '{\"movies\":\"series\"}'),
( 'series', 'series_hot', '{\"movies\":\"series\"}'),
( 'series', 'series_favourite', '{\"movies\":\"series\"}'),
( 'default', 'videos_reminder', '{\"videos\":\"Live Streaming\"}');

DROP TABLE IF EXISTS `movies`;
CREATE TABLE `movies` (
  `movie_id` int(11) UNSIGNED NOT NULL auto_increment,
  `imdb_id` varchar(255) NULL,
  `tmdb_id` bigint(191) UNSIGNED NOT NULL default '0',
  `title` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `tagline` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `category` VARCHAR(45) NOT NULL DEFAULT 'movie',
  `runtime` int(11) unsigned NOT NULL default '0',
  `season_count` int(11) unsigned NOT NULL default '0',
  `episode_count` int(11) unsigned NOT NULL default '0',
  `series_ended` tinyint(1) NOT NULL default '0',
  `category_id` int(11) unsigned NOT NULL default '0',
  `subcategory_id` int(11) unsigned NOT NULL default '0',
  `subsubcategory_id` int(11) unsigned NOT NULL default '0',
  `owner_id` INT(11) NOT NULL DEFAULT '0',
  `custom_url` varchar(255) NOT NULL,
  `stars` decimal(16,1) NOT NULL DEFAULT '0.0',
  `budget` decimal(16,2) NOT NULL DEFAULT '0.00',
  `revenue` decimal(16,2) NOT NULL DEFAULT '0.00',
  `language` varchar(45) NOT NULL DEFAULT 'en',
  `country` INT(11) NOT NULL DEFAULT '0',
  `image` varchar(255) NOT NULL default '',
  `backdrop` varchar(255) NULL,
  `type` varchar(10) NOT NULL DEFAULT 'movies',
  `rent_price` decimal(16,2) NOT NULL  DEFAULT '0.00',
  `price` decimal(16,2) NOT NULL  DEFAULT '0.00',
  `movie_release` varchar(45) NOT NULL DEFAULT '',
  `rating` float default '0.0',
  `view_count` int(11) UNSIGNED NOT NULL default '0',
  `comment_count` int(11) UNSIGNED NOT NULL default '0',
  `like_count` int(11) UNSIGNED NOT NULL default '0',
  `dislike_count` int(11) UNSIGNED NOT NULL default '0',  
  `search` tinyint(1) NOT NULL default '1',
  `favourite_count` int(11) UNSIGNED NOT NULL default '0',
  `is_sponsored` tinyint(1) NOT NULL default '0',
  `is_featured` tinyint(1) NOT NULL default '0',
  `is_hot` tinyint(1) NOT NULL default '0',
  `show_slider` tinyint(1) NOT NULL default '0',
  `approve` tinyint(1) NOT NULL DEFAULT '1',
  `completed` tinyint(1) NOT NULL DEFAULT '1',
  `adult` tinyint(1) NOT NULL DEFAULT '0',
  `is_locked` tinyint(1) NOT NULL default '0',
  `password` VARCHAR(255) NULL,
  `purchase_count` int(11) not NULL default '0',
  `total_purchase_amount` VARCHAR(255) NOT NULL DEFAULT '0',
  `autoapprove_comments` TINYINT(1) NOT NULL DEFAULT '1',
  `tags` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `view_privacy` VARCHAR(24) NOT NULL,
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`movie_id`),
  KEY `custom_url` (`custom_url`),
  KEY `purchase_count` (`purchase_count`),
  KEY `imdb_id` (`imdb_id`),
  KEY `category_id` (`category_id`),
  KEY `subcategory_id` (`subcategory_id`),
  KEY `subsubcategory_id` (`subsubcategory_id`),
  KEY  `owner_id` (`owner_id`),
  KEY  `is_locked` (`is_locked`),
  KEY `rent_price` (`rent_price`),
  KEY  `price` (`price`),
  KEY `type` (`type`),
  KEY `stars` (`stars`),
  KEY `budget` (`budget`),
  KEY `revenue` (`revenue`),
  KEY `language` (`language`),
  KEY `country` (`country`),
  KEY `movie_release` (`movie_release`),
  KEY `is_sponsored` (`is_sponsored`),
  KEY `is_featured` (`is_featured`),
  KEY `is_hot` (`is_hot`),
  KEY `rating` (`rating`),
  KEY `show_slider` (`show_slider`),
  KEY `view_count` (`view_count`),
  KEY `comment_count` (`comment_count`),
  KEY `like_count` (`like_count`),
  KEY `dislike_count` (`dislike_count`),
  KEY `search` (`search`),
  KEY `favourite_count` (`favourite_count`),
  KEY `approve` (`approve`),
  KEY `completed` (`completed`),
  KEY `adult` (`adult`),
  KEY `view_privacy` (`view_privacy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `movie_videos`;
CREATE TABLE `movie_videos` (
  `movie_video_id` int(11) UNSIGNED NOT NULL auto_increment,
  `movie_id` int(11) UNSIGNED NOT NULL,
  `tmdb_id` varchar(255) NULL,
  `owner_id` int(11) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(45) NULL,
  `season_id` int(11) UNSIGNED NOT NULL,
  `episode_id` int(11) UNSIGNED NOT NULL,
  `video_location` varchar(255) NULL,
  `image` varchar(255) NULL,
  `type` varchar(45) NOT NULL DEFAULT '',
   `size` varchar(255) NULL,
  `duration` varchar(50) NULL,
  `code` TEXT NULL,
  `language` varchar(45) NOT NULL DEFAULT 'en',
  `quality` varchar(45) NULL,
  `sample` tinyint(1) NOT NULL DEFAULT '0',
  `240p` tinyint(1) NOT NULL DEFAULT '0',
  `360p` tinyint(1) NOT NULL DEFAULT '0',
  `480p` tinyint(1) NOT NULL DEFAULT '0',
  `720p` tinyint(1) NOT NULL DEFAULT '0',
  `1080p` tinyint(1) NOT NULL DEFAULT '0',
  `2048p` tinyint(1) NOT NULL DEFAULT '0',
  `4096p` tinyint(1) NOT NULL DEFAULT '0',
  `completed` TINYINT(1) NOT NULL DEFAULT '0',
  `status` TINYINT(1) NOT NULL DEFAULT '1',
  `plays` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`movie_video_id`),
  KEY `movie_id` (`movie_id`),
  KEY `tmdb_id` (`tmdb_id`),
  KEY  `completed` (`completed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `seasons`;
CREATE TABLE `seasons` (
  `season_id` int(11) UNSIGNED NOT NULL auto_increment,
  `movie_id` int(11) UNSIGNED NOT NULL default '0',
  `tmdb_id` bigint(191) UNSIGNED NOT NULL default '0',
  `season` int(11) UNSIGNED NOT NULL default '0',
  `image` varchar(255) NULL,
  PRIMARY KEY (`season_id`),
  KEY `movie_id` (`movie_id`),
  KEY `tmdb_id` (`tmdb_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `episodes`;
CREATE TABLE `episodes` (
  `episode_id` int(11) UNSIGNED NOT NULL auto_increment,
  `tmdb_id` bigint(191) UNSIGNED NOT NULL default '0',
  `season_id` int(11) UNSIGNED NOT NULL,
  `movie_id` int(11) UNSIGNED NOT NULL,
  `owner_id` INT(11) NOT NULL,
  `title`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `episode_number` int(11) NOT NULL DEFAULT '1',
  `image` varchar(255) NULL DEFAULT '',
  `release_date` varchar(100) NULL,
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `rating` float default '0.0',
  `view_count` int(11) UNSIGNED NOT NULL default '0',
  `comment_count` int(11) UNSIGNED NOT NULL default '0',
  `like_count` int(11) UNSIGNED NOT NULL default '0',
  `dislike_count` int(11) UNSIGNED NOT NULL default '0',  
  `search` tinyint(1) NOT NULL default '1',
  `favourite_count` int(11) UNSIGNED NOT NULL default '0',
  `creation_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
    PRIMARY KEY (`episode_id`),
    KEY `season_id` (`season_id`),
    KEY `tmdb_id` (`tmdb_id`),
    KEY `movie_id` (`movie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
  `photo_id` int(11) UNSIGNED NOT NULL auto_increment,
  `name` VARCHAR(255) NULL,
  `resource_id` int(11) UNSIGNED NOT NULL,
  `resource_type` varchar(45) NOT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`photo_id`),
  KEY `resource_id` (`resource_id`,`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
  `genre_id` int(11) UNSIGNED NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `movie_count` int(11) unsigned NOT NULL default '0',
  `series_count` int(11) unsigned NOT NULL default '0',
  PRIMARY KEY (`genre_id`),
  KEY `slug` (`slug`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `genres` ( `title`, `slug`, `movie_count`, `series_count`) VALUES
( 'Action', 'action', 0, 0),
( 'Adventure', 'adventure', 0, 0),
( 'Animation', 'animation', 0, 0),
( 'Comedy', 'comedy', 0, 0),
( 'Crime', 'crime', 0, 0),
( 'Documentary', 'documentary', 0, 0),
( 'Drama', 'drama', 0, 0),
( 'Family', 'family', 0, 0),
( 'Fantasy', 'fantasy', 0, 0),
( 'History', 'history', 0, 0),
( 'Horror', 'horror', 0, 0),
( 'Music', 'music', 0, 0),
( 'Mystery', 'mystery', 0, 0),
( 'Romance', 'romance', 0, 0),
( 'Science Fiction', 'science-fiction', 0, 0),
( 'TV Movie', 'tv-movie', 0, 0),
( 'Thriller', 'thriller', 0, 0),
( 'War', 'war', 0, 0),
( 'Western', 'western', 0, 0);

DROP TABLE IF EXISTS `movie_genres`;
CREATE TABLE `movie_genres` (
  `movie_genre_id` int(11) UNSIGNED NOT NULL auto_increment,
  `genre_id` int(11) UNSIGNED NOT NULL default '0',
  `movie_id` int(11) UNSIGNED NOT NULL default '0',
  PRIMARY KEY (`movie_genre_id`),
  KEY `movie_id` (`movie_id`),
  KEY `genre_id` (`genre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `keywords`;
CREATE TABLE `keywords` (
  `keyword_id` int(11) UNSIGNED NOT NULL auto_increment,
  `movie_id` int(11) UNSIGNED NOT NULL default '0',
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  PRIMARY KEY (`keyword_id`),
  KEY `movie_id` (`movie_id`),
  KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `review_id` int(11) UNSIGNED NOT NULL auto_increment,
  `owner_id` int(11) UNSIGNED NOT NULL,
  `movie_id` int(11) UNSIGNED NOT NULL,
  `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `rating` float default '0.0',
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`review_id`),
  KEY `movie_id` (`movie_id`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `video_type_categories`;
CREATE TABLE `video_type_categories` (
  `video_type_category_id` int(11) UNSIGNED NOT NULL auto_increment,
  `type` varchar(255) NOT NULL DEFAULT 'full',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  PRIMARY KEY (`video_type_category_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `cast_crew_members`;
CREATE TABLE `cast_crew_members` (
  `cast_crew_member_id` int(11) UNSIGNED NOT NULL auto_increment,
  `custom_url` VARCHAR(255) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `image` varchar(255) NOT NULL,
  `biography` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `gender` varchar(45) NULL,
  `birthdate` varchar(25) NULL,
  `deathdate` varchar(25) NULL,
  `birthplace` varchar(255) NULL,
  `imdb_id` varchar(255) NULL,
  `tmdb_id` bigint(191) UNSIGNED NOT NULL default '0',
  `rating` float default '0.0',
  `view_count` int(11) UNSIGNED NOT NULL default '0',
  `comment_count` int(11) UNSIGNED NOT NULL default '0',
  `like_count` int(11) UNSIGNED NOT NULL default '0',
  `dislike_count` int(11) UNSIGNED NOT NULL default '0',
  `favourite_count` int(11) UNSIGNED NOT NULL default '0',
  `type` VARCHAR(255) NOT NULL DEFAULT 'movie',
  PRIMARY KEY (`cast_crew_member_id`),
  KEY `name` (`name`),
  KEY `imdb_id` (`imdb_id`),
  KEY `tmdb_id` (`tmdb_id`),
  KEY `view_count` (`view_count`),
  KEY `comment_count` (`comment_count`),
  KEY `like_count` (`like_count`),
  KEY `dislike_count` (`dislike_count`),
  KEY `favourite_count` (`favourite_count`),
  KEY `rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `cast_crew`;
CREATE TABLE `cast_crew` (
  `cast_crew_id` int(11) UNSIGNED NOT NULL auto_increment,
  `cast_crew_member_id` int(11) UNSIGNED NOT NULL,
  `character` varchar(255) NULL,
  `job` varchar(255) NULL,
  `department` varchar(255) NULL,
  `resource_type` VARCHAR(255) NOT NULL DEFAULT 'season',
  `resource_id` INT(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`cast_crew_id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `movie_countries` (
  `movie_country_id` int(11) NOT NULL AUTO_INCREMENT,
 `movie_id` INT(11) NOT NULL,
 `country_id` INT(11) NOT NULL,
  PRIMARY KEY (`movie_country_id`),
  KEY `movie_id` (`movie_id`),
  KEY `country_id` (`country_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso` char(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `nicename` varchar(80) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  `phonecode` int(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

INSERT INTO `video_type_categories` (`type`, `title`) VALUES
('trailer', 'Trailer'),
('clip', 'Clip'),
('teaser', 'Teaser'),
('full', 'Full Movie or episode');


INSERT INTO `countries` (`id`, `iso`, `name`, `nicename`, `iso3`, `numcode`, `phonecode`) VALUES
(1, 'AF', 'AFGHANISTAN', 'Afghanistan', 'AFG', 4, 93),
(2, 'AL', 'ALBANIA', 'Albania', 'ALB', 8, 355),
(3, 'DZ', 'ALGERIA', 'Algeria', 'DZA', 12, 213),
(4, 'AS', 'AMERICAN SAMOA', 'American Samoa', 'ASM', 16, 1684),
(5, 'AD', 'ANDORRA', 'Andorra', 'AND', 20, 376),
(6, 'AO', 'ANGOLA', 'Angola', 'AGO', 24, 244),
(7, 'AI', 'ANGUILLA', 'Anguilla', 'AIA', 660, 1264),
(8, 'AQ', 'ANTARCTICA', 'Antarctica', NULL, NULL, 0),
(9, 'AG', 'ANTIGUA AND BARBUDA', 'Antigua and Barbuda', 'ATG', 28, 1268),
(10, 'AR', 'ARGENTINA', 'Argentina', 'ARG', 32, 54),
(11, 'AM', 'ARMENIA', 'Armenia', 'ARM', 51, 374),
(12, 'AW', 'ARUBA', 'Aruba', 'ABW', 533, 297),
(13, 'AU', 'AUSTRALIA', 'Australia', 'AUS', 36, 61),
(14, 'AT', 'AUSTRIA', 'Austria', 'AUT', 40, 43),
(15, 'AZ', 'AZERBAIJAN', 'Azerbaijan', 'AZE', 31, 994),
(16, 'BS', 'BAHAMAS', 'Bahamas', 'BHS', 44, 1242),
(17, 'BH', 'BAHRAIN', 'Bahrain', 'BHR', 48, 973),
(18, 'BD', 'BANGLADESH', 'Bangladesh', 'BGD', 50, 880),
(19, 'BB', 'BARBADOS', 'Barbados', 'BRB', 52, 1246),
(20, 'BY', 'BELARUS', 'Belarus', 'BLR', 112, 375),
(21, 'BE', 'BELGIUM', 'Belgium', 'BEL', 56, 32),
(22, 'BZ', 'BELIZE', 'Belize', 'BLZ', 84, 501),
(23, 'BJ', 'BENIN', 'Benin', 'BEN', 204, 229),
(24, 'BM', 'BERMUDA', 'Bermuda', 'BMU', 60, 1441),
(25, 'BT', 'BHUTAN', 'Bhutan', 'BTN', 64, 975),
(26, 'BO', 'BOLIVIA', 'Bolivia', 'BOL', 68, 591),
(27, 'BA', 'BOSNIA AND HERZEGOVINA', 'Bosnia and Herzegovina', 'BIH', 70, 387),
(28, 'BW', 'BOTSWANA', 'Botswana', 'BWA', 72, 267),
(29, 'BV', 'BOUVET ISLAND', 'Bouvet Island', NULL, NULL, 0),
(30, 'BR', 'BRAZIL', 'Brazil', 'BRA', 76, 55),
(31, 'IO', 'BRITISH INDIAN OCEAN TERRITORY', 'British Indian Ocean Territory', NULL, NULL, 246),
(32, 'BN', 'BRUNEI DARUSSALAM', 'Brunei Darussalam', 'BRN', 96, 673),
(33, 'BG', 'BULGARIA', 'Bulgaria', 'BGR', 100, 359),
(34, 'BF', 'BURKINA FASO', 'Burkina Faso', 'BFA', 854, 226),
(35, 'BI', 'BURUNDI', 'Burundi', 'BDI', 108, 257),
(36, 'KH', 'CAMBODIA', 'Cambodia', 'KHM', 116, 855),
(37, 'CM', 'CAMEROON', 'Cameroon', 'CMR', 120, 237),
(38, 'CA', 'CANADA', 'Canada', 'CAN', 124, 1),
(39, 'CV', 'CAPE VERDE', 'Cape Verde', 'CPV', 132, 238),
(40, 'KY', 'CAYMAN ISLANDS', 'Cayman Islands', 'CYM', 136, 1345),
(41, 'CF', 'CENTRAL AFRICAN REPUBLIC', 'Central African Republic', 'CAF', 140, 236),
(42, 'TD', 'CHAD', 'Chad', 'TCD', 148, 235),
(43, 'CL', 'CHILE', 'Chile', 'CHL', 152, 56),
(44, 'CN', 'CHINA', 'China', 'CHN', 156, 86),
(45, 'CX', 'CHRISTMAS ISLAND', 'Christmas Island', NULL, NULL, 61),
(46, 'CC', 'COCOS (KEELING) ISLANDS', 'Cocos (Keeling) Islands', NULL, NULL, 672),
(47, 'CO', 'COLOMBIA', 'Colombia', 'COL', 170, 57),
(48, 'KM', 'COMOROS', 'Comoros', 'COM', 174, 269),
(49, 'CG', 'CONGO', 'Congo', 'COG', 178, 242),
(50, 'CD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'Congo, the Democratic Republic of the', 'COD', 180, 242),
(51, 'CK', 'COOK ISLANDS', 'Cook Islands', 'COK', 184, 682),
(52, 'CR', 'COSTA RICA', 'Costa Rica', 'CRI', 188, 506),
(53, 'CI', 'COTE D''IVOIRE', 'Cote D''Ivoire', 'CIV', 384, 225),
(54, 'HR', 'CROATIA', 'Croatia', 'HRV', 191, 385),
(55, 'CU', 'CUBA', 'Cuba', 'CUB', 192, 53),
(56, 'CY', 'CYPRUS', 'Cyprus', 'CYP', 196, 357),
(57, 'CZ', 'CZECH REPUBLIC', 'Czech Republic', 'CZE', 203, 420),
(58, 'DK', 'DENMARK', 'Denmark', 'DNK', 208, 45),
(59, 'DJ', 'DJIBOUTI', 'Djibouti', 'DJI', 262, 253),
(60, 'DM', 'DOMINICA', 'Dominica', 'DMA', 212, 1767),
(61, 'DO', 'DOMINICAN REPUBLIC', 'Dominican Republic', 'DOM', 214, 1809),
(62, 'EC', 'ECUADOR', 'Ecuador', 'ECU', 218, 593),
(63, 'EG', 'EGYPT', 'Egypt', 'EGY', 818, 20),
(64, 'SV', 'EL SALVADOR', 'El Salvador', 'SLV', 222, 503),
(65, 'GQ', 'EQUATORIAL GUINEA', 'Equatorial Guinea', 'GNQ', 226, 240),
(66, 'ER', 'ERITREA', 'Eritrea', 'ERI', 232, 291),
(67, 'EE', 'ESTONIA', 'Estonia', 'EST', 233, 372),
(68, 'ET', 'ETHIOPIA', 'Ethiopia', 'ETH', 231, 251),
(69, 'FK', 'FALKLAND ISLANDS (MALVINAS)', 'Falkland Islands (Malvinas)', 'FLK', 238, 500),
(70, 'FO', 'FAROE ISLANDS', 'Faroe Islands', 'FRO', 234, 298),
(71, 'FJ', 'FIJI', 'Fiji', 'FJI', 242, 679),
(72, 'FI', 'FINLAND', 'Finland', 'FIN', 246, 358),
(73, 'FR', 'FRANCE', 'France', 'FRA', 250, 33),
(74, 'GF', 'FRENCH GUIANA', 'French Guiana', 'GUF', 254, 594),
(75, 'PF', 'FRENCH POLYNESIA', 'French Polynesia', 'PYF', 258, 689),
(76, 'TF', 'FRENCH SOUTHERN TERRITORIES', 'French Southern Territories', NULL, NULL, 0),
(77, 'GA', 'GABON', 'Gabon', 'GAB', 266, 241),
(78, 'GM', 'GAMBIA', 'Gambia', 'GMB', 270, 220),
(79, 'GE', 'GEORGIA', 'Georgia', 'GEO', 268, 995),
(80, 'DE', 'GERMANY', 'Germany', 'DEU', 276, 49),
(81, 'GH', 'GHANA', 'Ghana', 'GHA', 288, 233),
(82, 'GI', 'GIBRALTAR', 'Gibraltar', 'GIB', 292, 350),
(83, 'GR', 'GREECE', 'Greece', 'GRC', 300, 30),
(84, 'GL', 'GREENLAND', 'Greenland', 'GRL', 304, 299),
(85, 'GD', 'GRENADA', 'Grenada', 'GRD', 308, 1473),
(86, 'GP', 'GUADELOUPE', 'Guadeloupe', 'GLP', 312, 590),
(87, 'GU', 'GUAM', 'Guam', 'GUM', 316, 1671),
(88, 'GT', 'GUATEMALA', 'Guatemala', 'GTM', 320, 502),
(89, 'GN', 'GUINEA', 'Guinea', 'GIN', 324, 224),
(90, 'GW', 'GUINEA-BISSAU', 'Guinea-Bissau', 'GNB', 624, 245),
(91, 'GY', 'GUYANA', 'Guyana', 'GUY', 328, 592),
(92, 'HT', 'HAITI', 'Haiti', 'HTI', 332, 509),
(93, 'HM', 'HEARD ISLAND AND MCDONALD ISLANDS', 'Heard Island and Mcdonald Islands', NULL, NULL, 0),
(94, 'VA', 'HOLY SEE (VATICAN CITY STATE)', 'Holy See (Vatican City State)', 'VAT', 336, 39),
(95, 'HN', 'HONDURAS', 'Honduras', 'HND', 340, 504),
(96, 'HK', 'HONG KONG', 'Hong Kong', 'HKG', 344, 852),
(97, 'HU', 'HUNGARY', 'Hungary', 'HUN', 348, 36),
(98, 'IS', 'ICELAND', 'Iceland', 'ISL', 352, 354),
(99, 'IN', 'INDIA', 'India', 'IND', 356, 91),
(100, 'ID', 'INDONESIA', 'Indonesia', 'IDN', 360, 62),
(101, 'IR', 'IRAN, ISLAMIC REPUBLIC OF', 'Iran, Islamic Republic of', 'IRN', 364, 98),
(102, 'IQ', 'IRAQ', 'Iraq', 'IRQ', 368, 964),
(103, 'IE', 'IRELAND', 'Ireland', 'IRL', 372, 353),
(104, 'IL', 'ISRAEL', 'Israel', 'ISR', 376, 972),
(105, 'IT', 'ITALY', 'Italy', 'ITA', 380, 39),
(106, 'JM', 'JAMAICA', 'Jamaica', 'JAM', 388, 1876),
(107, 'JP', 'JAPAN', 'Japan', 'JPN', 392, 81),
(108, 'JO', 'JORDAN', 'Jordan', 'JOR', 400, 962),
(109, 'KZ', 'KAZAKHSTAN', 'Kazakhstan', 'KAZ', 398, 7),
(110, 'KE', 'KENYA', 'Kenya', 'KEN', 404, 254),
(111, 'KI', 'KIRIBATI', 'Kiribati', 'KIR', 296, 686),
(112, 'KP', 'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF', 'Korea, Democratic People''s Republic of', 'PRK', 408, 850),
(113, 'KR', 'KOREA, REPUBLIC OF', 'Korea, Republic of', 'KOR', 410, 82),
(114, 'KW', 'KUWAIT', 'Kuwait', 'KWT', 414, 965),
(115, 'KG', 'KYRGYZSTAN', 'Kyrgyzstan', 'KGZ', 417, 996),
(116, 'LA', 'LAO PEOPLE''S DEMOCRATIC REPUBLIC', 'Lao People''s Democratic Republic', 'LAO', 418, 856),
(117, 'LV', 'LATVIA', 'Latvia', 'LVA', 428, 371),
(118, 'LB', 'LEBANON', 'Lebanon', 'LBN', 422, 961),
(119, 'LS', 'LESOTHO', 'Lesotho', 'LSO', 426, 266),
(120, 'LR', 'LIBERIA', 'Liberia', 'LBR', 430, 231),
(121, 'LY', 'LIBYAN ARAB JAMAHIRIYA', 'Libyan Arab Jamahiriya', 'LBY', 434, 218),
(122, 'LI', 'LIECHTENSTEIN', 'Liechtenstein', 'LIE', 438, 423),
(123, 'LT', 'LITHUANIA', 'Lithuania', 'LTU', 440, 370),
(124, 'LU', 'LUXEMBOURG', 'Luxembourg', 'LUX', 442, 352),
(125, 'MO', 'MACAO', 'Macao', 'MAC', 446, 853),
(126, 'MK', 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', 'Macedonia, the Former Yugoslav Republic of', 'MKD', 807, 389),
(127, 'MG', 'MADAGASCAR', 'Madagascar', 'MDG', 450, 261),
(128, 'MW', 'MALAWI', 'Malawi', 'MWI', 454, 265),
(129, 'MY', 'MALAYSIA', 'Malaysia', 'MYS', 458, 60),
(130, 'MV', 'MALDIVES', 'Maldives', 'MDV', 462, 960),
(131, 'ML', 'MALI', 'Mali', 'MLI', 466, 223),
(132, 'MT', 'MALTA', 'Malta', 'MLT', 470, 356),
(133, 'MH', 'MARSHALL ISLANDS', 'Marshall Islands', 'MHL', 584, 692),
(134, 'MQ', 'MARTINIQUE', 'Martinique', 'MTQ', 474, 596),
(135, 'MR', 'MAURITANIA', 'Mauritania', 'MRT', 478, 222),
(136, 'MU', 'MAURITIUS', 'Mauritius', 'MUS', 480, 230),
(137, 'YT', 'MAYOTTE', 'Mayotte', NULL, NULL, 269),
(138, 'MX', 'MEXICO', 'Mexico', 'MEX', 484, 52),
(139, 'FM', 'MICRONESIA, FEDERATED STATES OF', 'Micronesia, Federated States of', 'FSM', 583, 691),
(140, 'MD', 'MOLDOVA, REPUBLIC OF', 'Moldova, Republic of', 'MDA', 498, 373),
(141, 'MC', 'MONACO', 'Monaco', 'MCO', 492, 377),
(142, 'MN', 'MONGOLIA', 'Mongolia', 'MNG', 496, 976),
(143, 'MS', 'MONTSERRAT', 'Montserrat', 'MSR', 500, 1664),
(144, 'MA', 'MOROCCO', 'Morocco', 'MAR', 504, 212),
(145, 'MZ', 'MOZAMBIQUE', 'Mozambique', 'MOZ', 508, 258),
(146, 'MM', 'MYANMAR', 'Myanmar', 'MMR', 104, 95),
(147, 'NA', 'NAMIBIA', 'Namibia', 'NAM', 516, 264),
(148, 'NR', 'NAURU', 'Nauru', 'NRU', 520, 674),
(149, 'NP', 'NEPAL', 'Nepal', 'NPL', 524, 977),
(150, 'NL', 'NETHERLANDS', 'Netherlands', 'NLD', 528, 31),
(151, 'AN', 'NETHERLANDS ANTILLES', 'Netherlands Antilles', 'ANT', 530, 599),
(152, 'NC', 'NEW CALEDONIA', 'New Caledonia', 'NCL', 540, 687),
(153, 'NZ', 'NEW ZEALAND', 'New Zealand', 'NZL', 554, 64),
(154, 'NI', 'NICARAGUA', 'Nicaragua', 'NIC', 558, 505),
(155, 'NE', 'NIGER', 'Niger', 'NER', 562, 227),
(156, 'NG', 'NIGERIA', 'Nigeria', 'NGA', 566, 234),
(157, 'NU', 'NIUE', 'Niue', 'NIU', 570, 683),
(158, 'NF', 'NORFOLK ISLAND', 'Norfolk Island', 'NFK', 574, 672),
(159, 'MP', 'NORTHERN MARIANA ISLANDS', 'Northern Mariana Islands', 'MNP', 580, 1670),
(160, 'NO', 'NORWAY', 'Norway', 'NOR', 578, 47),
(161, 'OM', 'OMAN', 'Oman', 'OMN', 512, 968),
(162, 'PK', 'PAKISTAN', 'Pakistan', 'PAK', 586, 92),
(163, 'PW', 'PALAU', 'Palau', 'PLW', 585, 680),
(164, 'PS', 'PALESTINIAN TERRITORY, OCCUPIED', 'Palestinian Territory, Occupied', NULL, NULL, 970),
(165, 'PA', 'PANAMA', 'Panama', 'PAN', 591, 507),
(166, 'PG', 'PAPUA NEW GUINEA', 'Papua New Guinea', 'PNG', 598, 675),
(167, 'PY', 'PARAGUAY', 'Paraguay', 'PRY', 600, 595),
(168, 'PE', 'PERU', 'Peru', 'PER', 604, 51),
(169, 'PH', 'PHILIPPINES', 'Philippines', 'PHL', 608, 63),
(170, 'PN', 'PITCAIRN', 'Pitcairn', 'PCN', 612, 0),
(171, 'PL', 'POLAND', 'Poland', 'POL', 616, 48),
(172, 'PT', 'PORTUGAL', 'Portugal', 'PRT', 620, 351),
(173, 'PR', 'PUERTO RICO', 'Puerto Rico', 'PRI', 630, 1787),
(174, 'QA', 'QATAR', 'Qatar', 'QAT', 634, 974),
(175, 'RE', 'REUNION', 'Reunion', 'REU', 638, 262),
(176, 'RO', 'ROMANIA', 'Romania', 'ROM', 642, 40),
(177, 'RU', 'RUSSIAN FEDERATION', 'Russian Federation', 'RUS', 643, 70),
(178, 'RW', 'RWANDA', 'Rwanda', 'RWA', 646, 250),
(179, 'SH', 'SAINT HELENA', 'Saint Helena', 'SHN', 654, 290),
(180, 'KN', 'SAINT KITTS AND NEVIS', 'Saint Kitts and Nevis', 'KNA', 659, 1869),
(181, 'LC', 'SAINT LUCIA', 'Saint Lucia', 'LCA', 662, 1758),
(182, 'PM', 'SAINT PIERRE AND MIQUELON', 'Saint Pierre and Miquelon', 'SPM', 666, 508),
(183, 'VC', 'SAINT VINCENT AND THE GRENADINES', 'Saint Vincent and the Grenadines', 'VCT', 670, 1784),
(184, 'WS', 'SAMOA', 'Samoa', 'WSM', 882, 684),
(185, 'SM', 'SAN MARINO', 'San Marino', 'SMR', 674, 378),
(186, 'ST', 'SAO TOME AND PRINCIPE', 'Sao Tome and Principe', 'STP', 678, 239),
(187, 'SA', 'SAUDI ARABIA', 'Saudi Arabia', 'SAU', 682, 966),
(188, 'SN', 'SENEGAL', 'Senegal', 'SEN', 686, 221),
(189, 'CS', 'SERBIA AND MONTENEGRO', 'Serbia and Montenegro', NULL, NULL, 381),
(190, 'SC', 'SEYCHELLES', 'Seychelles', 'SYC', 690, 248),
(191, 'SL', 'SIERRA LEONE', 'Sierra Leone', 'SLE', 694, 232),
(192, 'SG', 'SINGAPORE', 'Singapore', 'SGP', 702, 65),
(193, 'SK', 'SLOVAKIA', 'Slovakia', 'SVK', 703, 421),
(194, 'SI', 'SLOVENIA', 'Slovenia', 'SVN', 705, 386),
(195, 'SB', 'SOLOMON ISLANDS', 'Solomon Islands', 'SLB', 90, 677),
(196, 'SO', 'SOMALIA', 'Somalia', 'SOM', 706, 252),
(197, 'ZA', 'SOUTH AFRICA', 'South Africa', 'ZAF', 710, 27),
(198, 'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'South Georgia and the South Sandwich Islands', NULL, NULL, 0),
(199, 'ES', 'SPAIN', 'Spain', 'ESP', 724, 34),
(200, 'LK', 'SRI LANKA', 'Sri Lanka', 'LKA', 144, 94),
(201, 'SD', 'SUDAN', 'Sudan', 'SDN', 736, 249),
(202, 'SR', 'SURINAME', 'Suriname', 'SUR', 740, 597),
(203, 'SJ', 'SVALBARD AND JAN MAYEN', 'Svalbard and Jan Mayen', 'SJM', 744, 47),
(204, 'SZ', 'SWAZILAND', 'Swaziland', 'SWZ', 748, 268),
(205, 'SE', 'SWEDEN', 'Sweden', 'SWE', 752, 46),
(206, 'CH', 'SWITZERLAND', 'Switzerland', 'CHE', 756, 41),
(207, 'SY', 'SYRIAN ARAB REPUBLIC', 'Syrian Arab Republic', 'SYR', 760, 963),
(208, 'TW', 'TAIWAN, PROVINCE OF CHINA', 'Taiwan, Province of China', 'TWN', 158, 886),
(209, 'TJ', 'TAJIKISTAN', 'Tajikistan', 'TJK', 762, 992),
(210, 'TZ', 'TANZANIA, UNITED REPUBLIC OF', 'Tanzania, United Republic of', 'TZA', 834, 255),
(211, 'TH', 'THAILAND', 'Thailand', 'THA', 764, 66),
(212, 'TL', 'TIMOR-LESTE', 'Timor-Leste', NULL, NULL, 670),
(213, 'TG', 'TOGO', 'Togo', 'TGO', 768, 228),
(214, 'TK', 'TOKELAU', 'Tokelau', 'TKL', 772, 690),
(215, 'TO', 'TONGA', 'Tonga', 'TON', 776, 676),
(216, 'TT', 'TRINIDAD AND TOBAGO', 'Trinidad and Tobago', 'TTO', 780, 1868),
(217, 'TN', 'TUNISIA', 'Tunisia', 'TUN', 788, 216),
(218, 'TR', 'TURKEY', 'Turkey', 'TUR', 792, 90),
(219, 'TM', 'TURKMENISTAN', 'Turkmenistan', 'TKM', 795, 7370),
(220, 'TC', 'TURKS AND CAICOS ISLANDS', 'Turks and Caicos Islands', 'TCA', 796, 1649),
(221, 'TV', 'TUVALU', 'Tuvalu', 'TUV', 798, 688),
(222, 'UG', 'UGANDA', 'Uganda', 'UGA', 800, 256),
(223, 'UA', 'UKRAINE', 'Ukraine', 'UKR', 804, 380),
(224, 'AE', 'UNITED ARAB EMIRATES', 'United Arab Emirates', 'ARE', 784, 971),
(225, 'GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826, 44),
(226, 'US', 'UNITED STATES', 'United States', 'USA', 840, 1),
(227, 'UM', 'UNITED STATES MINOR OUTLYING ISLANDS', 'United States Minor Outlying Islands', NULL, NULL, 1),
(228, 'UY', 'URUGUAY', 'Uruguay', 'URY', 858, 598),
(229, 'UZ', 'UZBEKISTAN', 'Uzbekistan', 'UZB', 860, 998),
(230, 'VU', 'VANUATU', 'Vanuatu', 'VUT', 548, 678),
(231, 'VE', 'VENEZUELA', 'Venezuela', 'VEN', 862, 58),
(232, 'VN', 'VIET NAM', 'Viet Nam', 'VNM', 704, 84),
(233, 'VG', 'VIRGIN ISLANDS, BRITISH', 'Virgin Islands, British', 'VGB', 92, 1284),
(234, 'VI', 'VIRGIN ISLANDS, U.S.', 'Virgin Islands, U.s.', 'VIR', 850, 1340),
(235, 'WF', 'WALLIS AND FUTUNA', 'Wallis and Futuna', 'WLF', 876, 681),
(236, 'EH', 'WESTERN SAHARA', 'Western Sahara', 'ESH', 732, 212),
(237, 'YE', 'YEMEN', 'Yemen', 'YEM', 887, 967),
(238, 'ZM', 'ZAMBIA', 'Zambia', 'ZMB', 894, 260),
(239, 'ZW', 'ZIMBABWE', 'Zimbabwe', 'ZWE', 716, 263);

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'create' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','admin','moderator');


INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'view' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'edit' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'delete' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'view' as `name`,
    2 as `value`
  FROM `levels` WHERE `type` IN('admin');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'edit' as `name`,
    2 as `value`
  FROM `levels` WHERE `type` IN('admin');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'delete' as `name`,
    2 as `value`
  FROM `levels` WHERE `type` IN('admin');



INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'quota' as `name`,
    0 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'storage' as `name`,
    0 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'embedcode' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'sponsored' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'featured' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'hot' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'auto_approve' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'donation' as `name`,
    0 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');

INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'sell_movies' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');
INSERT IGNORE INTO `level_permissions`
  SELECT
    level_id as `level_id`,
    'movie' as `type`,
    'sell_rent_movies' as `name`,
    1 as `value`
  FROM `levels` WHERE `type` IN('admin','user','moderator');


