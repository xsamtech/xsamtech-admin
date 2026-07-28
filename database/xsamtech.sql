-- -----------------------------------------------------
-- Schema xsamtech
--
-- == Datamodel for the "xsamtech" platform
-- == Copyright (c) 2026 Xsam Technologies
-- == https://xsamtech.com
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `email` VARCHAR(255) NULL,
  `phone` VARCHAR(20) NULL,
  `password` VARCHAR(255) NULL,
  `remember_token` VARCHAR(100) NULL,
  `status` ENUM('pending', 'active', 'suspended', 'blocked', 'deleted') NULL,
  `email_verified_at` TIMESTAMP NULL,
  `phone_verified_at` TIMESTAMP NULL,
  `last_login_at` TIMESTAMP NULL,
  `last_login_ip` VARCHAR(45) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_users_UNIQUE` (`id` ASC),
  UNIQUE INDEX `email_users_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_users_UNIQUE` (`phone` ASC),
  UNIQUE INDEX `uuid_users_UNIQUE` (`uuid` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `categories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `name` JSON NOT NULL,
  `slug` VARCHAR(255) NULL,
  `image_url` TEXT NULL,
  `icon` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_categories_UNIQUE` (`id` ASC),
  UNIQUE INDEX `slug_categories_UNIQUE` (`slug` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `name` JSON NOT NULL,
  `slug` VARCHAR(255) NULL,
  `is_service` TINYINT(1) NOT NULL DEFAULT 0,
  `quantity` INT NULL,
  `icon` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `is_third_party` TINYINT(1) NOT NULL DEFAULT 0,
  `product_owner` VARCHAR(255) NULL COMMENT 'Name of the owner of the third-party product or service.',
  `is_available` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `category_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_products_UNIQUE` (`id` ASC),
  INDEX `fk_products_categories_idx` (`category_id` ASC),
  UNIQUE INDEX `slug_products_UNIQUE` (`slug` ASC),
  CONSTRAINT `fk_products_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `about_subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `about_subjects` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `subject` JSON NOT NULL,
  `description` JSON NULL,
  `icon` VARCHAR(45) NULL,
  `is_available` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aboutsubjects_UNIQUE` (`id` ASC),
  INDEX `fk_aboutsubjects_products_idx` (`product_id` ASC),
  UNIQUE INDEX `uuid_aboutsubjects_UNIQUE` (`uuid` ASC),
  CONSTRAINT `fk_aboutsubjects_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `about_titles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `about_titles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `title` TEXT NOT NULL,
  `icon` VARCHAR(45) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `about_subject_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_abouttitles_UNIQUE` (`id` ASC),
  INDEX `fk_abouttitles_aboutsubjects_idx` (`about_subject_id` ASC),
  UNIQUE INDEX `uuid_abouttitles_UNIQUE` (`uuid` ASC),
  CONSTRAINT `fk_abouttitles_aboutsubjects`
    FOREIGN KEY (`about_subject_id`)
    REFERENCES `about_subjects` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `about_contents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `about_contents` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `subtitle` TEXT NULL,
  `content` LONGTEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `about_title_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aboutcontents_UNIQUE` (`id` ASC),
  INDEX `fk_aboutcontents_abouttitles_idx` (`about_title_id` ASC),
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC),
  CONSTRAINT `fk_aboutcontents_abouttitles`
    FOREIGN KEY (`about_title_id`)
    REFERENCES `about_titles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `events` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `event_name` VARCHAR(255) NOT NULL,
  `event_description` LONGTEXT NULL,
  `slug` VARCHAR(255) NULL,
  `start_at` DATETIME NULL,
  `end_at` DATETIME NULL,
  `ticket_price` DECIMAL(9,2) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('gala', 'campaign', 'festival') NULL,
  `status` ENUM('pending', 'cancelled', 'started', 'ended') NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_events_UNIQUE` (`id` ASC),
  INDEX `fk_events_products_idx` (`product_id` ASC),
  UNIQUE INDEX `slug_events_UNIQUE` (`slug` ASC),
  CONSTRAINT `fk_events_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `event_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `event_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `event_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_eventuser_UNIQUE` (`id` ASC),
  INDEX `fk_eventuser_events_idx` (`event_id` ASC),
  INDEX `fk_eventuser_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_eventuser_events`
    FOREIGN KEY (`event_id`)
    REFERENCES `events` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_eventuser_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `newsletter_subscribers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `newsletter_subscribers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_newslettersubscribers_UNIQUE` (`id` ASC),
  INDEX `fk_newslettersubscribers_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_newslettersubscribers_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `role_name` JSON NOT NULL,
  `role_description` JSON NULL,
  `slug` VARCHAR(255) NULL,
  `belongs_to` BIGINT NULL COMMENT 'This column allows for the hierarchical arrangement of roles within society.',
  `type` ENUM('application', 'company') NOT NULL DEFAULT 'company',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_roles_UNIQUE` (`id` ASC),
  UNIQUE INDEX `slug_roles_UNIQUE` (`slug` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `job_offers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `job_offers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `offer_message` JSON NOT NULL,
  `offer_code` VARCHAR(255) NULL,
  `is_available` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `role_id` BIGINT NOT NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_joboffers_UNIQUE` (`id` ASC),
  INDEX `fk_joboffers_roles_idx` (`role_id` ASC),
  INDEX `fk_joboffers_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_joboffers_roles`
    FOREIGN KEY (`role_id`)
    REFERENCES `roles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_joboffers_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `role_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `role_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `role_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `assigned_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_roleuser_UNIQUE` (`id` ASC),
  INDEX `fk_roleuser_roles_idx` (`role_id` ASC),
  INDEX `fk_roleuser_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_roleuser_roles`
    FOREIGN KEY (`role_id`)
    REFERENCES `roles` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_roleuser_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `task_title` VARCHAR(255) NOT NULL,
  `task_description` TEXT NULL,
  `start_at` DATETIME NULL,
  `end_at` DATETIME NULL,
  `tasks_score` DECIMAL(5,2) NULL COMMENT 'Percentage of tasks completed.',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('created', 'pending', 'done', 'undone') NOT NULL DEFAULT 'created',
  `from_user_id` BIGINT NULL,
  `to_user_id` BIGINT NULL,
  `to_role_id` BIGINT NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_tasks_UNIQUE` (`id` ASC),
  INDEX `fk_tasks_fromusers1_idx` (`from_user_id` ASC),
  INDEX `fk_tasks_tousers1_idx` (`to_user_id` ASC),
  INDEX `fk_tasks_toroles_idx` (`to_role_id` ASC),
  INDEX `fk_tasks_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_tasks_fromusers1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_tousers1`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_toroles`
    FOREIGN KEY (`to_role_id`)
    REFERENCES `roles` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `groups` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `group_name` VARCHAR(255) NOT NULL,
  `profile_url` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_groups_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `messages` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `message_subject` VARCHAR(255) NULL,
  `message_content` LONGTEXT NULL,
  `answered_for` BIGINT NULL,
  `deleted_by` LONGTEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` ENUM('conversation', 'audio_call', 'video_call', 'report', 'help', 'testimony', 'communique') NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `user_id` BIGINT NULL,
  `addressee_group_id` BIGINT NULL,
  `addressee_role_id` BIGINT NULL,
  `addressee_user_id` BIGINT NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_messages_UNIQUE` (`id` ASC),
  INDEX `fk_messages_users1_idx` (`user_id` ASC),
  INDEX `fk_messages_messagegroups_idx` (`addressee_group_id` ASC),
  INDEX `fk_messages_roles_idx` (`addressee_role_id` ASC),
  INDEX `fk_messages_users2_idx` (`addressee_user_id` ASC),
  INDEX `fk_messages_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_messages_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_messagegroups`
    FOREIGN KEY (`addressee_group_id`)
    REFERENCES `groups` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_roles`
    FOREIGN KEY (`addressee_role_id`)
    REFERENCES `roles` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_users2`
    FOREIGN KEY (`addressee_user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `histories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `word` TEXT NULL COMMENT 'This refers to a search history of a user',
  `entity` ENUM('about_subject', 'event', 'message', 'task', 'job_offer', 'budget', 'expense', 'supply', 'product', 'pricing', 'newsletter', 'user') NULL,
  `entity_id` BIGINT NULL,
  `action` ENUM('search', 'register', 'update', 'subscribe', 'order', 'ask_ai') NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_histories_UNIQUE` (`id` ASC),
  INDEX `fk_histories_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_histories_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `partners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `partners` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `name` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` TINYINT(1) NOT NULL DEFAULT 0,
  `product_id` BIGINT NULL,
  `user_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_partners_UNIQUE` (`id` ASC),
  INDEX `fk_partners_products_idx` (`product_id` ASC),
  INDEX `fk_partners_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_partners_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_partners_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `supplies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `supplies` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `supply_name` VARCHAR(255) NOT NULL,
  `supply_description` TEXT NULL,
  `folder_code` VARCHAR(255) NULL,
  `case_code` VARCHAR(255) NULL,
  `type` ENUM('vehicle', 'other_engin', 'engin_part', 'office_equipment', 'cleaning_equipment', 'repair_equipment', 'decor_event_equipment', 'health_relax_equipment', 'manufacture_equipment', 'building_equipment', 'manufacture_material', 'building_material', 'administrative_legal_document', 'personnel_file', 'invitation_letter', 'other_document') NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_supplies_UNIQUE` (`id` ASC),
  INDEX `fk_supplies_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_supplies_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `files` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `file_name` VARCHAR(255) NULL,
  `file_description` LONGTEXT NULL COMMENT 'This might be useful for describing advertisements, for example.',
  `file_url` TEXT NULL,
  `file_type` ENUM('video', 'photo', 'audio', 'document', 'id_card', 'ad', 'qr_code') NOT NULL DEFAULT 'photo',
  `mime_type` VARCHAR(100) NULL,
  `file_size` BIGINT NULL,
  `width` INT NULL,
  `height` INT NULL,
  `duration` INT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `message_id` BIGINT NULL,
  `partner_id` BIGINT NULL,
  `supply_id` BIGINT NULL,
  `about_content_id` BIGINT NULL,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_files_UNIQUE` (`id` ASC),
  INDEX `fk_files_messages_idx` (`message_id` ASC),
  INDEX `fk_files_partners_idx` (`partner_id` ASC),
  INDEX `fk_files_supplies_idx` (`supply_id` ASC),
  INDEX `fk_files_aboutcontents_idx` (`about_content_id` ASC),
  INDEX `fk_files_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_files_messages`
    FOREIGN KEY (`message_id`)
    REFERENCES `messages` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_files_partners`
    FOREIGN KEY (`partner_id`)
    REFERENCES `partners` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_files_supplies`
    FOREIGN KEY (`supply_id`)
    REFERENCES `supplies` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_files_aboutcontents`
    FOREIGN KEY (`about_content_id`)
    REFERENCES `about_contents` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_files_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `group_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `group_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `group_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `is_admin` TINYINT(1) NOT NULL DEFAULT 0,
  `last_read_message` BIGINT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_groupuser_UNIQUE` (`id` ASC),
  INDEX `fk_groupuser_groups_idx` (`group_id` ASC),
  INDEX `fk_groupuser_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_groupuser_groups`
    FOREIGN KEY (`group_id`)
    REFERENCES `groups` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_groupuser_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `reference` VARCHAR(45) NULL,
  `provider_reference` VARCHAR(45) NULL,
  `order_number` TEXT NULL,
  `amount` DECIMAL(9,2) NULL,
  `amount_customer` DECIMAL(9,2) NULL,
  `phone` VARCHAR(45) NULL,
  `currency` VARCHAR(45) NULL,
  `channel` VARCHAR(45) NULL,
  `reason` ENUM('creation', 'subscription', 'certification', 'boost', 'sale', 'ad', 'sponsoring') NULL,
  `entity` ENUM('cart', 'user', 'pricing') NULL,
  `entity_id` BIGINT NULL,
  `type` INT NULL,
  `status` INT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_payments_UNIQUE` (`id` ASC),
  INDEX `fk_payments_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_payments_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `budgets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `budgets` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `designation` TEXT NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `is_allocated` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_budgets_UNIQUE` (`id` ASC),
  INDEX `fk_budgets_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_budgets_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `notifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `type` ENUM('product_added', 'product_ordered', 'stock_empty', 'message_sent', 'answer_sent', 'new_job_offer', 'new_task', 'deadline_ended', 'payment_done', 'payment_canceled', 'payment_failed', 'budget_established', 'budget_allocated') NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `from_user_id` BIGINT NULL,
  `to_user_id` BIGINT NULL,
  `product_id` BIGINT NULL,
  `message_id` BIGINT NULL,
  `job_offer_id` BIGINT NULL,
  `task_id` BIGINT NULL,
  `payment_id` BIGINT NULL,
  `budget_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_notifications_UNIQUE` (`id` ASC),
  INDEX `fk_notifications_fromusers_idx` (`from_user_id` ASC),
  INDEX `fk_notifications_tousers_idx` (`to_user_id` ASC),
  INDEX `fk_notifications_products_idx` (`product_id` ASC),
  INDEX `fk_notifications_messages_idx` (`message_id` ASC),
  INDEX `fk_notifications_joboffers_idx` (`job_offer_id` ASC),
  INDEX `fk_notifications_tasks_idx` (`task_id` ASC),
  INDEX `fk_notifications_payments_idx` (`payment_id` ASC),
  INDEX `fk_notifications_budgets_idx` (`budget_id` ASC),
  CONSTRAINT `fk_notifications_fromusers`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_tousers`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `users` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_messages`
    FOREIGN KEY (`message_id`)
    REFERENCES `messages` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_joboffers`
    FOREIGN KEY (`job_offer_id`)
    REFERENCES `job_offers` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_tasks`
    FOREIGN KEY (`task_id`)
    REFERENCES `tasks` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_payments`
    FOREIGN KEY (`payment_id`)
    REFERENCES `payments` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notifications_budgets`
    FOREIGN KEY (`budget_id`)
    REFERENCES `budgets` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `expenses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `expenses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `amount` DECIMAL(9,2) NOT NULL,
  `designation` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_expenses_UNIQUE` (`id` ASC),
  INDEX `fk_expenses_products_idx` (`product_id` ASC),
  CONSTRAINT `fk_expenses_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `product_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `product_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `product_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `cv_url` TEXT NULL,
  `letter_url` TEXT NULL,
  `status` ENUM('added', 'accepted', 'rejected', 'ended') NOT NULL DEFAULT 'added',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `role_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_productuser_UNIQUE` (`id` ASC),
  INDEX `fk_productuser_products_idx` (`product_id` ASC),
  INDEX `fk_productuser_users_idx` (`user_id` ASC),
  INDEX `fk_product_user_roles1_idx` (`role_id` ASC),
  CONSTRAINT `fk_productuser_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_productuser_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_product_user_roles1`
    FOREIGN KEY (`role_id`)
    REFERENCES `roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `password_resets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `password_resets` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NULL,
  `phone` VARCHAR(45) NULL,
  `token` VARCHAR(45) NULL,
  `former_password` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_passwordresets_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `websites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `websites` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `website_name` VARCHAR(255) NULL,
  `website_url` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_websites_UNIQUE` (`id` ASC),
  INDEX `fk_websites_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_websites_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NULL,
  `username` VARCHAR(255) NULL,
  `bio` VARCHAR(255) NULL,
  `gender` VARCHAR(45) NULL,
  `birthdate` DATE NULL,
  `country` VARCHAR(255) NULL,
  `city` VARCHAR(255) NULL,
  `address_1` TEXT NULL,
  `address_2` TEXT NULL,
  `language` VARCHAR(45) NULL,
  `locale` VARCHAR(45) NULL,
  `timezone` VARCHAR(45) NULL,
  `avatar_url` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_profiles_UNIQUE` (`id` ASC),
  INDEX `fk_profiles_users_idx` (`user_id` ASC),
  UNIQUE INDEX `username_profiles_UNIQUE` (`username` ASC),
  CONSTRAINT `fk_profiles_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `login_histories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `login_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `ip` VARCHAR(45) NULL,
  `user_agent` TEXT NULL,
  `country` VARCHAR(255) NULL,
  `city` VARCHAR(255) NULL,
  `device` VARCHAR(100) NULL,
  `browser` VARCHAR(100) NULL,
  `os` VARCHAR(100) NULL,
  `login_method` VARCHAR(100) NULL,
  `failure_reason` VARCHAR(100) NULL,
  `successful` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_loginhistories_UNIQUE` (`id` ASC),
  INDEX `fk_loginhistories_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_loginhistories_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_devices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_devices` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `device_uuid` CHAR(36) NOT NULL,
  `device_name` VARCHAR(255) NULL,
  `platform` VARCHAR(255) NULL,
  `push_token` TEXT NULL,
  `app_version` VARCHAR(45) NULL,
  `os_version` VARCHAR(45) NULL,
  `last_ip` VARCHAR(45) NULL,
  `is_trusted` TINYINT(1) NOT NULL DEFAULT 0,
  `last_seen_at` TIMESTAMP NULL,
  `revoked_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_userdevices_UNIQUE` (`id` ASC),
  INDEX `fk_userdevices_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_userdevices_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_verifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_verifications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `type` ENUM('email', 'phone') NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  `code_hash` VARCHAR(255) NOT NULL,
  `attempts` INT NOT NULL DEFAULT 0,
  `max_attempts` INT NOT NULL DEFAULT 5,
  `expires_at` TIMESTAMP NOT NULL,
  `verified_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_userverifications_UNIQUE` (`id` ASC),
  INDEX `fk_userverifications_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_userverifications_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_security_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_security_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `action` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `ip` VARCHAR(45) NULL,
  `user_agent` TEXT NULL,
  `device` VARCHAR(100) NULL,
  `browser` VARCHAR(100) NULL,
  `os` VARCHAR(100) NULL,
  `country` VARCHAR(100) NULL,
  `city` VARCHAR(100) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_usersecuritylogs_UNIQUE` (`id` ASC),
  INDEX `fk_usersecuritylogs_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_usersecuritylogs_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `carts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `payment_code` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_carts_UNIQUE` (`id` ASC),
  INDEX `fk_carts_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_carts_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `customer_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `customer_orders` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `price_at_that_time` DECIMAL(12,2) NULL,
  `currency` VARCHAR(45) NULL,
  `quantity` INT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` BIGINT NOT NULL,
  `cart_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_customerorders_UNIQUE` (`id` ASC),
  INDEX `fk_customerorders_products_idx` (`product_id` ASC),
  INDEX `fk_customerorders_carts_idx` (`cart_id` ASC),
  CONSTRAINT `fk_customerorders_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_customerorders_carts`
    FOREIGN KEY (`cart_id`)
    REFERENCES `carts` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pricings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pricings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `pricing_name` JSON NOT NULL,
  `slug` VARCHAR(255) NULL,
  `pricing_type` ENUM('money', 'percentage') NULL COMMENT 'The user must pay directly or pay a commission (percentage) on the payment he receives.',
  `reason` ENUM('creation', 'subscription', 'sale', 'boost', 'gift', 'certification') NULL,
  `pricing_cost` DECIMAL(12,2) NOT NULL,
  `currency` VARCHAR(45) NOT NULL,
  `image_url` TEXT NULL,
  `icon` VARCHAR(45) NULL,
  `color` VARCHAR(45) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `product_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_pricings_UNIQUE` (`id` ASC),
  INDEX `fk_pricings_products_idx` (`product_id` ASC),
  UNIQUE INDEX `slug_pricings_UNIQUE` (`slug` ASC),
  UNIQUE INDEX `uuid_pricings_UNIQUE` (`uuid` ASC),
  CONSTRAINT `fk_pricings_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `descriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `descriptions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` JSON NULL,
  `content` JSON NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `category_id` BIGINT NULL,
  `product_id` BIGINT NULL,
  `job_offer_id` BIGINT NULL,
  `pricing_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_descriptions_UNIQUE` (`id` ASC),
  INDEX `fk_descriptions_categories_idx` (`category_id` ASC),
  INDEX `fk_descriptions_products_idx` (`product_id` ASC),
  INDEX `fk_descriptions_joboffers_idx` (`job_offer_id` ASC),
  INDEX `fk_descriptions_pricings_idx` (`pricing_id` ASC),
  CONSTRAINT `fk_descriptions_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descriptions_products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descriptions_joboffers`
    FOREIGN KEY (`job_offer_id`)
    REFERENCES `job_offers` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descriptions_pricings`
    FOREIGN KEY (`pricing_id`)
    REFERENCES `pricings` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `personal_access_tokens`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `tokenable_type` VARCHAR(255) NOT NULL,
  `tokenable_id` BIGINT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `token` VARCHAR(64) NOT NULL,
  `abilities` TEXT NULL,
  `last_used_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_personalaccesstokens_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `about_dashes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `about_dashes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `dash_content` JSON NOT NULL,
  `belongs_to` BIGINT NULL COMMENT 'A subdash within another dash.',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `about_content_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aboutdashes_UNIQUE` (`id` ASC),
  INDEX `fk_aboutdashes_aboutcontents_idx` (`about_content_id` ASC),
  CONSTRAINT `fk_aboutdashes_aboutcontents`
    FOREIGN KEY (`about_content_id`)
    REFERENCES `about_contents` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cache`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`),
  INDEX `cache_expiration_index` (`expiration` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cache_locks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` VARCHAR(255) NOT NULL,
  `owner` VARCHAR(255) NOT NULL,
  `expiration` INT NOT NULL,
  PRIMARY KEY (`key`),
  INDEX `cache_locks_expiration_index` (`expiration` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `failed_jobs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(255) NOT NULL,
  `connection` TEXT NOT NULL,
  `queue` VARCHAR(45) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `exception` LONGTEXT NOT NULL,
  `failed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `failed_jobs_uuid_unique` (`uuid` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `jobs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` VARCHAR(255) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `exception` LONGTEXT NOT NULL,
  `attempts` TINYINT UNSIGNED NOT NULL,
  `reserved_at` INT UNSIGNED NULL,
  `available_at` INT UNSIGNED NOT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `jobs_queue_index` (`queue` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `job_batches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `total_jobs` INT NOT NULL,
  `pending_jobs` INT NOT NULL,
  `failed_jobs` INT NOT NULL,
  `failed_job_ids` LONGTEXT NOT NULL,
  `options` VARCHAR(45) NULL,
  `cancelled_at` INT NULL,
  `created_at` INT NOT NULL,
  `finished_at` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ai_conversations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ai_conversations` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `assistant` VARCHAR(50) NOT NULL,
  `system_prompt` LONGTEXT NULL,
  `last_message_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `archived_at` TIMESTAMP NULL,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aiconversations_UNIQUE` (`id` ASC),
  INDEX `fk_aiconversations_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_aiconversations_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ai_messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ai_messages` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `role` ENUM('system', 'user', 'assistant', 'tool') NOT NULL,
  `content` LONGTEXT NOT NULL,
  `model` VARCHAR(100) NULL,
  `prompt_tokens` INT UNSIGNED NULL,
  `completion_tokens` INT UNSIGNED NULL,
  `total_tokens` INT UNSIGNED NULL,
  `response_time_ms` INT UNSIGNED NULL,
  `error_message` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `conversation_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aimessages_UNIQUE` (`id` ASC),
  INDEX `fk_aimessages_aiconversations_idx` (`conversation_id` ASC),
  CONSTRAINT `fk_aimessages_aiconversations`
    FOREIGN KEY (`conversation_id`)
    REFERENCES `ai_conversations` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ai_message_files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ai_message_files` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ai_message_id` BIGINT NOT NULL,
  `file_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aimessagefiles_UNIQUE` (`id` ASC),
  INDEX `fk_aimessagefiles_aimessages_idx` (`ai_message_id` ASC),
  INDEX `fk_aimessagefiles_files_idx` (`file_id` ASC),
  CONSTRAINT `fk_aimessagefiles_aimessages`
    FOREIGN KEY (`ai_message_id`)
    REFERENCES `ai_messages` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_aimessagefiles_files`
    FOREIGN KEY (`file_id`)
    REFERENCES `files` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ai_tool_calls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ai_tool_calls` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `tool_name` VARCHAR(100) NOT NULL,
  `arguments` JSON NULL,
  `response` JSON NULL,
  `status` ENUM('pending', 'success', 'failed') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ai_message_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aitoolcalls_UNIQUE` (`id` ASC),
  INDEX `fk_aitoolcalls_aimessages_idx` (`ai_message_id` ASC),
  CONSTRAINT `fk_aitoolcalls_aimessages`
    FOREIGN KEY (`ai_message_id`)
    REFERENCES `ai_messages` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ai_settings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ai_settings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `provider` VARCHAR(50) NOT NULL,
  `model` VARCHAR(100) NOT NULL,
  `temperature` DECIMAL(3,2) NOT NULL,
  `max_tokens` INT UNSIGNED NOT NULL,
  `stream` TINYINT NOT NULL,
  `enabled` TINYINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_aisettings_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `blocked_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `blocked_users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `uuid` CHAR(36) NOT NULL,
  `complaint` LONGTEXT NULL,
  `is_unlocked` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  `user_id` BIGINT NOT NULL,
  `about_title_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_blockedusers_UNIQUE` (`id` ASC),
  INDEX `fk_blockedusers_users_idx` (`user_id` ASC),
  INDEX `fk_blockedusers_abouttitles_idx` (`about_title_id` ASC),
  CONSTRAINT `fk_blockedusers_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `users` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_blockedusers_abouttitles`
    FOREIGN KEY (`about_title_id`)
    REFERENCES `about_titles` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;
