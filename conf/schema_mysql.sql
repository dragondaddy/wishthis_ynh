CREATE TABLE `users` (
   `id`                         INT          PRIMARY KEY AUTO_INCREMENT,
   `email`                      VARCHAR(64)  NOT NULL UNIQUE,
   `password`                   VARCHAR(128) NOT NULL,
   `password_reset_token`       VARCHAR(128) NULL     DEFAULT NULL,
   `password_reset_valid_until` DATETIME     NOT NULL DEFAULT NOW(),
   `last_login`                 DATETIME     NOT NULL DEFAULT NOW(),
   `power`                      INT          NOT NULL DEFAULT 1,
   `birthdate`                  DATE         NULL     DEFAULT NULL,
   `language`                   VARCHAR(5)   NOT NULL DEFAULT "' . DEFAULT_LOCALE . '",
   `currency`                   VARCHAR(3)   NOT NULL DEFAULT "' . $currencyISO . '",
   `name_first`                 VARCHAR(32)  NULL     DEFAULT NULL,
   `name_last`                  VARCHAR(32)  NULL     DEFAULT NULL,
   `name_nick`                  VARCHAR(32)  NULL     DEFAULT NULL,
   `channel`                    VARCHAR(24)  NULL     DEFAULT NULL,
   `advertisements`             TINYINT(1)   NOT NULL DEFAULT 0,

   INDEX `idx_password` (`password`)
);

CREATE TABLE `wishlists` (
  `id`                INT          PRIMARY KEY AUTO_INCREMENT,
  `user`              INT          NOT NULL,
  `name`              VARCHAR(128) NOT NULL,
  `hash`              VARCHAR(128) NOT NULL,
  `notification_sent` TIMESTAMP        NULL DEFAULT NULL,

  INDEX `idx_hash` (`hash`),
  CONSTRAINT `FK_wishlists_user` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE
            );

CREATE TABLE `wishlists_saved` (
  `id`       INT PRIMARY KEY AUTO_INCREMENT,
  `user`     INT NOT NULL,
  `wishlist` INT NOT NULL,

  INDEX `idx_wishlist` (`wishlist`),
  CONSTRAINT `FK_wishlists_saved_user` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE
            );

CREATE TABLE `wishes` (
  `id`             INT          NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `wishlist`       INT          NOT NULL,
  `title`          VARCHAR(128) NULL     DEFAULT NULL,
  `description`    TEXT         NULL     DEFAULT NULL,
  `image`          TEXT         NULL     DEFAULT NULL,
  `url`            VARCHAR(255) NULL     DEFAULT NULL,
  `priority`       TINYINT(1)   NULL     DEFAULT NULL,
  `status`         VARCHAR(32)  NULL     DEFAULT NULL,
  `is_purchasable` BOOLEAN      NOT NULL DEFAULT FALSE,
  `edited`         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX `idx_url` (`url`),
  CONSTRAINT `FK_wishes_wishlists` FOREIGN KEY (`wishlist`) REFERENCES `wishlists` (`id`) ON DELETE CASCADE
            );

CREATE TABLE `products` (
  `wish`  INT   NOT NULL PRIMARY KEY,
  `price` FLOAT NULL     DEFAULT NULL,

  CONSTRAINT `FK_products_wishes` FOREIGN KEY (`wish`) REFERENCES `wishes` (`id`) ON DELETE CASCADE
            );

CREATE TABLE `options` (
  `id`    INT          PRIMARY KEY AUTO_INCREMENT,
  `key`   VARCHAR(64)  NOT NULL UNIQUE,
  `value` VARCHAR(128) NOT NULL
            );

INSERT INTO
  `options` (`key`, `value`)
            VALUES
  ("isInstalled", true),
  ("version", "' . VERSION . '")
            ;

CREATE TABLE `sessions` (
  `id`      INT         NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `user`    INT         NOT NULL,
  `session` VARCHAR(60) NOT NULL,
  `expires` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP(),

  INDEX `idx_user` (`session`),
  CONSTRAINT `FK_sessions_users` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE
            );

SET foreign_key_checks = 1;
