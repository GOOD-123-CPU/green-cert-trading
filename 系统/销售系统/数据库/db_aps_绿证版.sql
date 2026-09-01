-- MySQL dump 10.13  Distrib 8.4.7, for Win64 (x86_64)
--
-- Host: localhost    Database: db_aps
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `receiver` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人姓名',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,4,'13800138001','北京市朝阳区某街道1号','2025-02-03 02:46:11','2025-06-03 10:22:59','123'),(2,4,'13800138002','北京市海淀区某街道2号','2025-02-03 02:46:11','2025-06-03 10:23:04','456'),(3,5,'13800138003','上海市浦东新区某街道3号','2025-02-03 02:46:11','2025-02-03 02:46:11',NULL),(4,2,'13800138004','广州市天河区某街道4号','2025-02-03 02:46:11','2025-02-03 02:46:11',NULL),(5,3,'13800138005','深圳市南山区某街道5号','2025-02-03 02:46:11','2025-02-03 02:46:11',NULL),(8,8,'13800000008','13800000008','2025-02-17 01:10:44','2025-03-22 13:12:40','演示用户');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资讯标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '资讯内容',
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '资讯摘要',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图片URL',
  `view_count` int DEFAULT '0' COMMENT '浏览量',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态(0下架,1上架)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (1,'绿证交易入门指南','<p>绿色电力证书（简称绿证）是可再生能源发电企业生产的绿色电力的一种权益凭证。购买绿证相当于支持绿色电力的发展，对减少碳排放有重要意义。</p><p>交易流程包括：注册账户、充值积分、选择绿证、完成交易。</p>','本文介绍绿色电力证书交易的基本概念、交易流程和注意事项','https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=600',1251,1,'2025-04-16 15:29:28','2026-01-27 18:14:23'),(2,'风力发电绿证的5大投资优势','<p>风力发电是目前最成熟的可再生能源之一，投资风力发电绿证有以下优势：</p><p>1. 价格稳定 2. 供应充足 3. 技术成熟 4. 环保效益显著 5. 政策支持力度大.</p>','了解为什么风力发电绿证是值得投资的选择，以及它们对环保的独特益处','https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=600',980,1,'2025-04-16 15:29:28','2026-01-27 18:14:23'),(3,'光伏发电绿证选购攻略','<p>光伏发电绿证是太阳能发电产生的绿色电力证书。选购时需考虑：</p><p>1. 发电企业资质 2. 绿证价格 3. 交易量 4. 企业碳中和需求 5. 长期采购计划</p>','企业如何选择适合自己的光伏发电绿证，这些技巧值得了解','https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600',2101,1,'2025-04-16 15:29:28','2026-01-27 18:14:23'),(4,'绿证交易常见问题解答','<p>本文为您解答绿证交易中的常见问题：</p><p>Q1: 绿证有有效期吗？ A: 绿证长期有效。</p><p>Q2: 如何查询绿证真伪？ A: 可通过官方平台验证。</p><p>Q3: 企业购买绿证有什么好处？ A: 可用于碳中和、ESG报告等。</p>','解答绿证交易中的常见疑问，让您的交易更加顺畅','https://images.unsplash.com/photo-1548337138-e87d889cc369?w=600',1560,1,'2025-04-16 15:29:28','2026-01-27 18:14:23'),(5,'碳中和与绿证：企业减排新路径','<p>碳中和是全球气候治理的重要目标，绿证在企业减排中发挥重要作用：</p><p>1. 抵消企业用电碳排放 2. 提升企业绿色形象 3. 满足客户环保要求 4. 响应国家双碳政策</p>','深入了解绿证如何帮助企业实现碳中和目标，助力绿色发展','https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=600',891,1,'2025-04-16 15:29:28','2026-01-27 18:14:23');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carousel_item`
--

DROP TABLE IF EXISTS `carousel_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carousel_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '轮播图片URL',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签文本',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述文本',
  `product_id` bigint DEFAULT '0' COMMENT '商品id',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='首页轮播图表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carousel_item`
--

LOCK TABLES `carousel_item` WRITE;
/*!40000 ALTER TABLE `carousel_item` DISABLE KEYS */;
INSERT INTO `carousel_item` VALUES (1,'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=800','热门','风力发电绿证专场','优质风力发电企业直供绿证，助力企业碳中和目标',1,1,1),(2,'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=800','特惠','光伏发电绿证特惠','优质光伏电站认证绿证，限时优惠',2,2,1),(3,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800','精选','水力发电绿证','大型水电站核发绿证，稳定可靠',22,3,1),(4,'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800','推荐','企业碳中和方案','为企业提供专业绿证采购方案',4,4,1),(5,'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=800','组合','新能源绿证套餐','风能+光伏+水电组合绿证套餐',5,5,1);
/*!40000 ALTER TABLE `carousel_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '商品数量',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (3,5,2,3,'2025-02-03 02:46:11','2025-02-03 02:46:11'),(4,5,4,1,'2025-02-03 02:46:11','2025-02-03 02:46:11'),(11,2,9,2,'2025-02-04 05:52:59','2025-02-04 05:52:59'),(38,8,15,1,'2025-04-30 09:52:40','2025-04-30 09:52:40');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '分类描述',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'风力发电','各类新鲜应季水果','2025-02-03 02:46:11','2026-01-27 16:17:00','el-icon-apple'),(2,'光伏发电','当季新鲜蔬菜','2025-02-03 02:46:11','2026-01-27 16:17:00','el-icon-food'),(3,'水力发电','稻谷、小麦等粮食作物','2025-02-03 02:46:11','2026-01-27 16:17:00','el-icon-dessert'),(4,'生物质能','地方特色农产品','2025-02-03 02:46:11','2026-01-27 16:17:00','el-icon-sugar'),(5,'综合能源','有机认证农产品','2025-02-03 02:46:11','2026-01-27 16:17:00','el-icon-dish');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dict_item`
--

DROP TABLE IF EXISTS `dict_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dict_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联的字典类型code',
  `item_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典项的键',
  `item_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典项的值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '字典项的描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `item_key` (`item_key`) USING BTREE,
  KEY `dict_type_code` (`dict_type_code`) USING BTREE,
  CONSTRAINT `dict_item_ibfk_1` FOREIGN KEY (`dict_type_code`) REFERENCES `sys_dict` (`dict_type_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统字典项表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dict_item`
--

LOCK TABLES `dict_item` WRITE;
/*!40000 ALTER TABLE `dict_item` DISABLE KEYS */;
INSERT INTO `dict_item` VALUES (1,'icon','user','el-icon-user1',NULL,'2024-07-30 23:06:45','2025-02-18 14:40:17'),(2,'icon','house','el-icon-house',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(3,'icon','menu','el-icon-menu',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(4,'icon','s-custom','el-icon-s-custom',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(5,'icon','s-grid','el-icon-s-grid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(6,'icon','document','el-icon-document',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(7,'icon','coffee','el-icon-coffee',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(8,'icon','s-marketing','el-icon-s-marketing',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(9,'icon','phone-outline','el-icon-phone-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(10,'icon','platform-eleme','el-icon-platform-eleme',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(11,'icon','eleme','el-icon-eleme',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(12,'icon','delete-solid','el-icon-delete-solid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(13,'icon','delete','el-icon-delete',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(14,'icon','s-tools','el-icon-s-tools',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(15,'icon','setting','el-icon-setting',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(16,'icon','user-solid','el-icon-user-solid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(17,'icon','phone','el-icon-phone',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(18,'icon','more','el-icon-more',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(19,'icon','more-outline','el-icon-more-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(20,'icon','star-on','el-icon-star-on',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(21,'icon','star-off','el-icon-star-off',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(22,'icon','s-goods','el-icon-s-goods',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(23,'icon','goods','el-icon-goods',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(24,'icon','warning','el-icon-warning',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(25,'icon','warning-outline','el-icon-warning-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(26,'icon','question','el-icon-question',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(27,'icon','info','el-icon-info',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(28,'icon','remove','el-icon-remove',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(29,'icon','circle-plus','el-icon-circle-plus',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(30,'icon','success','el-icon-success',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(31,'icon','error','el-icon-error',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(32,'icon','zoom-in','el-icon-zoom-in',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(33,'icon','zoom-out','el-icon-zoom-out',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(34,'icon','remove-outline','el-icon-remove-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(35,'icon','circle-plus-outline','el-icon-circle-plus-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(36,'icon','circle-check','el-icon-circle-check',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(37,'icon','circle-close','el-icon-circle-close',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(38,'icon','s-help','el-icon-s-help',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(39,'icon','help','el-icon-help',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(40,'icon','minus','el-icon-minus',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(41,'icon','plus','el-icon-plus',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(42,'icon','check','el-icon-check',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(43,'icon','close','el-icon-close',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(44,'icon','picture','el-icon-picture',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(45,'icon','picture-outline','el-icon-picture-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(46,'icon','picture-outline-round','el-icon-picture-outline-round',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(47,'icon','upload','el-icon-upload',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(48,'icon','upload2','el-icon-upload2',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(49,'icon','download','el-icon-download',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(50,'icon','camera-solid','el-icon-camera-solid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(51,'icon','camera','el-icon-camera',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(52,'icon','video-camera-solid','el-icon-video-camera-solid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(53,'icon','video-camera','el-icon-video-camera',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(54,'icon','message-solid','el-icon-message-solid',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(55,'icon','bell','el-icon-bell',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(56,'icon','s-cooperation','el-icon-s-cooperation',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(57,'icon','s-order','el-icon-s-order',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(58,'icon','s-platform','el-icon-s-platform',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(59,'icon','s-fold','el-icon-s-fold',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(60,'icon','s-unfold','el-icon-s-unfold',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(61,'icon','s-operation','el-icon-s-operation',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(62,'icon','s-promotion','el-icon-s-promotion',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(63,'icon','s-home','el-icon-s-home',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(64,'icon','s-release','el-icon-s-release',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(65,'icon','s-ticket','el-icon-s-ticket',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(66,'icon','s-management','el-icon-s-management',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(67,'icon','s-open','el-icon-s-open',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(68,'icon','s-shop','el-icon-s-shop',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(69,'icon','s-flag','el-icon-s-flag',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(70,'icon','s-comment','el-icon-s-comment',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(71,'icon','s-finance','el-icon-s-finance',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(72,'icon','s-claim','el-icon-s-claim',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(73,'icon','s-opportunity','el-icon-s-opportunity',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(74,'icon','s-data','el-icon-s-data',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(75,'icon','s-check','el-icon-s-check',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(76,'icon','share','el-icon-share',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(77,'icon','d-caret','el-icon-d-caret',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(78,'icon','caret-left','el-icon-caret-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(79,'icon','caret-right','el-icon-caret-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(80,'icon','caret-bottom','el-icon-caret-bottom',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(81,'icon','caret-top','el-icon-caret-top',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(82,'icon','bottom-left','el-icon-bottom-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(83,'icon','bottom-right','el-icon-bottom-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(84,'icon','back','el-icon-back',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(85,'icon','right','el-icon-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(86,'icon','bottom','el-icon-bottom',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(87,'icon','top','el-icon-top',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(88,'icon','top-left','el-icon-top-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(89,'icon','top-right','el-icon-top-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(90,'icon','arrow-left','el-icon-arrow-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(91,'icon','arrow-right','el-icon-arrow-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(92,'icon','arrow-down','el-icon-arrow-down',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(93,'icon','arrow-up','el-icon-arrow-up',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(94,'icon','d-arrow-left','el-icon-d-arrow-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(95,'icon','d-arrow-right','el-icon-d-arrow-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(96,'icon','video-pause','el-icon-video-pause',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(97,'icon','video-play','el-icon-video-play',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(98,'icon','refresh','el-icon-refresh',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(99,'icon','refresh-right','el-icon-refresh-right',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(100,'icon','refresh-left','el-icon-refresh-left',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(101,'icon','finished','el-icon-finished',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(102,'icon','sort','el-icon-sort',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(103,'icon','sort-up','el-icon-sort-up',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(104,'icon','sort-down','el-icon-sort-down',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(105,'icon','rank','el-icon-rank',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(106,'icon','loading','el-icon-loading',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(107,'icon','view','el-icon-view',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(108,'icon','c-scale-to-original','el-icon-c-scale-to-original',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(109,'icon','date','el-icon-date',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(110,'icon','edit','el-icon-edit',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(111,'icon','edit-outline','el-icon-edit-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(112,'icon','folder','el-icon-folder',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(113,'icon','folder-opened','el-icon-folder-opened',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(114,'icon','folder-add','el-icon-folder-add',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(115,'icon','folder-remove','el-icon-folder-remove',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(116,'icon','folder-delete','el-icon-folder-delete',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(117,'icon','folder-checked','el-icon-folder-checked',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(118,'icon','tickets','el-icon-tickets',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(119,'icon','document-remove','el-icon-document-remove',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(120,'icon','document-delete','el-icon-document-delete',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(121,'icon','document-copy','el-icon-document-copy',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(122,'icon','document-checked','el-icon-document-checked',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(123,'icon','document-add','el-icon-document-add',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(124,'icon','printer','el-icon-printer',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(125,'icon','paperclip','el-icon-paperclip',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(126,'icon','takeaway-box','el-icon-takeaway-box',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(127,'icon','search','el-icon-search',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(128,'icon','monitor','el-icon-monitor',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(129,'icon','attract','el-icon-attract',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(130,'icon','mobile','el-icon-mobile',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(131,'icon','scissors','el-icon-scissors',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(132,'icon','umbrella','el-icon-umbrella',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(133,'icon','headset','el-icon-headset',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(134,'icon','brush','el-icon-brush',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(135,'icon','mouse','el-icon-mouse',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(136,'icon','coordinate','el-icon-coordinate',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(137,'icon','magic-stick','el-icon-magic-stick',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(138,'icon','reading','el-icon-reading',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(139,'icon','data-line','el-icon-data-line',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(140,'icon','data-board','el-icon-data-board',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(141,'icon','pie-chart','el-icon-pie-chart',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(142,'icon','data-analysis','el-icon-data-analysis',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(143,'icon','collection-tag','el-icon-collection-tag',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(144,'icon','film','el-icon-film',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(145,'icon','suitcase','el-icon-suitcase',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(146,'icon','suitcase-1','el-icon-suitcase-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(147,'icon','receiving','el-icon-receiving',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(148,'icon','collection','el-icon-collection',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(149,'icon','files','el-icon-files',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(150,'icon','notebook-1','el-icon-notebook-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(151,'icon','notebook-2','el-icon-notebook-2',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(152,'icon','toilet-paper','el-icon-toilet-paper',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(153,'icon','office-building','el-icon-office-building',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(154,'icon','school','el-icon-school',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(155,'icon','table-lamp','el-icon-table-lamp',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(156,'icon','no-smoking','el-icon-no-smoking',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(157,'icon','smoking','el-icon-smoking',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(158,'icon','shopping-cart-full','el-icon-shopping-cart-full',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(159,'icon','shopping-cart-1','el-icon-shopping-cart-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(160,'icon','shopping-cart-2','el-icon-shopping-cart-2',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(161,'icon','shopping-bag-1','el-icon-shopping-bag-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(162,'icon','shopping-bag-2','el-icon-shopping-bag-2',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(163,'icon','sold-out','el-icon-sold-out',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(164,'icon','sell','el-icon-sell',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(165,'icon','present','el-icon-present',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(166,'icon','box','el-icon-box',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(167,'icon','bank-card','el-icon-bank-card',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(168,'icon','money','el-icon-money',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(169,'icon','coin','el-icon-coin',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(170,'icon','wallet','el-icon-wallet',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(171,'icon','discount','el-icon-discount',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(172,'icon','price-tag','el-icon-price-tag',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(173,'icon','news','el-icon-news',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(174,'icon','guide','el-icon-guide',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(175,'icon','male','el-icon-male',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(176,'icon','female','el-icon-female',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(177,'icon','thumb','el-icon-thumb',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(178,'icon','cpu','el-icon-cpu',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(179,'icon','link','el-icon-link',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(180,'icon','connection','el-icon-connection',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(181,'icon','open','el-icon-open',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(182,'icon','turn-off','el-icon-turn-off',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(183,'icon','set-up','el-icon-set-up',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(184,'icon','chat-round','el-icon-chat-round',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(185,'icon','chat-line-round','el-icon-chat-line-round',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(186,'icon','chat-square','el-icon-chat-square',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(187,'icon','chat-dot-round','el-icon-chat-dot-round',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(188,'icon','chat-dot-square','el-icon-chat-dot-square',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(189,'icon','chat-line-square','el-icon-chat-line-square',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(190,'icon','message','el-icon-message',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(191,'icon','postcard','el-icon-postcard',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(192,'icon','position','el-icon-position',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(193,'icon','turn-off-microphone','el-icon-turn-off-microphone',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(194,'icon','microphone','el-icon-microphone',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(195,'icon','close-notification','el-icon-close-notification',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(196,'icon','bangzhu','el-icon-bangzhu',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(197,'icon','time','el-icon-time',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(198,'icon','odometer','el-icon-odometer',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(199,'icon','crop','el-icon-crop',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(200,'icon','aim','el-icon-aim',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(201,'icon','switch-button','el-icon-switch-button',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(202,'icon','full-screen','el-icon-full-screen',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(203,'icon','copy-document','el-icon-copy-document',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(204,'icon','mic','el-icon-mic',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(205,'icon','stopwatch','el-icon-stopwatch',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(206,'icon','medal-1','el-icon-medal-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(207,'icon','medal','el-icon-medal',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(208,'icon','trophy','el-icon-trophy',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(209,'icon','trophy-1','el-icon-trophy-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(210,'icon','first-aid-kit','el-icon-first-aid-kit',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(211,'icon','discover','el-icon-discover',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(212,'icon','place','el-icon-place',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(213,'icon','location','el-icon-location',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(214,'icon','location-outline','el-icon-location-outline',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(215,'icon','location-information','el-icon-location-information',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(216,'icon','add-location','el-icon-add-location',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(217,'icon','delete-location','el-icon-delete-location',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(218,'icon','map-location','el-icon-map-location',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(219,'icon','alarm-clock','el-icon-alarm-clock',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(220,'icon','timer','el-icon-timer',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(221,'icon','watch-1','el-icon-watch-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(222,'icon','watch','el-icon-watch',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(223,'icon','lock','el-icon-lock',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(224,'icon','unlock','el-icon-unlock',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(225,'icon','key','el-icon-key',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(226,'icon','service','el-icon-service',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(227,'icon','mobile-phone','el-icon-mobile-phone',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(228,'icon','bicycle','el-icon-bicycle',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(229,'icon','truck','el-icon-truck',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(230,'icon','ship','el-icon-ship',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(231,'icon','basketball','el-icon-basketball',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(232,'icon','football','el-icon-football',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(233,'icon','soccer','el-icon-soccer',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(234,'icon','baseball','el-icon-baseball',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(235,'icon','wind-power','el-icon-wind-power',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(236,'icon','light-rain','el-icon-light-rain',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(237,'icon','lightning','el-icon-lightning',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(238,'icon','heavy-rain','el-icon-heavy-rain',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(239,'icon','sunrise','el-icon-sunrise',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(240,'icon','sunrise-1','el-icon-sunrise-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(241,'icon','sunset','el-icon-sunset',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(242,'icon','sunny','el-icon-sunny',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(243,'icon','cloudy','el-icon-cloudy',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(244,'icon','partly-cloudy','el-icon-partly-cloudy',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(245,'icon','cloudy-and-sunny','el-icon-cloudy-and-sunny',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(246,'icon','moon','el-icon-moon',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(247,'icon','moon-night','el-icon-moon-night',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(248,'icon','dish','el-icon-dish',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(249,'icon','dish-1','el-icon-dish-1',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(250,'icon','food','el-icon-food',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(251,'icon','chicken','el-icon-chicken',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(252,'icon','fork-spoon','el-icon-fork-spoon',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(253,'icon','knife-fork','el-icon-knife-fork',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(254,'icon','burger','el-icon-burger',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(255,'icon','tableware','el-icon-tableware',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(256,'icon','sugar','el-icon-sugar',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(257,'icon','dessert','el-icon-dessert',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(258,'icon','ice-cream','el-icon-ice-cream',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(259,'icon','hot-water','el-icon-hot-water',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(260,'icon','water-cup','el-icon-water-cup',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(261,'icon','coffee-cup','el-icon-coffee-cup',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(262,'icon','cold-drink','el-icon-cold-drink',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(263,'icon','goblet','el-icon-goblet',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(264,'icon','goblet-full','el-icon-goblet-full',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(265,'icon','goblet-square','el-icon-goblet-square',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(266,'icon','goblet-square-full','el-icon-goblet-square-full',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(267,'icon','refrigerator','el-icon-refrigerator',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(268,'icon','grape','el-icon-grape',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(269,'icon','watermelon','el-icon-watermelon',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(270,'icon','cherry','el-icon-cherry',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(271,'icon','apple','el-icon-apple',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(272,'icon','pear','el-icon-pear',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(273,'icon','orange','el-icon-orange',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(274,'icon','ice-tea','el-icon-ice-tea',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(275,'icon','ice-drink','el-icon-ice-drink',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(276,'icon','milk-tea','el-icon-milk-tea',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(277,'icon','potato-strips','el-icon-potato-strips',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(278,'icon','lollipop','el-icon-lollipop',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45'),(279,'icon','ice-cream-square','el-icon-ice-cream-square',NULL,'2024-07-30 23:06:45','2024-07-30 23:06:45');
/*!40000 ALTER TABLE `dict_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '收藏状态:0取消,1收藏',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
INSERT INTO `favorite` VALUES (4,5,4,1,'2025-02-03 02:46:11','2025-02-03 02:46:11'),(5,4,5,1,'2025-02-03 02:46:11','2025-02-03 02:46:11'),(7,4,22,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(8,3,24,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(9,2,2,0,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(11,5,19,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(12,3,1,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(13,2,8,0,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(15,4,7,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(17,2,16,0,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(18,1,23,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(20,5,24,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(21,3,8,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(22,2,18,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(23,1,18,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(25,5,13,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(26,4,15,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(27,3,9,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(28,2,24,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(29,1,16,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(31,5,4,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(32,4,11,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(33,3,20,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(35,1,12,1,'2025-02-03 08:02:13','2025-02-03 08:02:13'),(37,2,1,0,'2025-02-03 12:34:17','2025-02-03 12:34:17'),(49,2,6,1,'2025-02-03 13:22:21','2025-02-03 13:22:21'),(50,2,19,0,'2025-02-03 13:23:43','2025-02-03 13:23:43'),(51,2,7,0,'2025-02-03 13:27:14','2025-02-03 13:27:14'),(52,2,15,0,'2025-02-03 13:49:51','2025-02-03 13:49:51'),(60,8,7,1,'2025-02-07 03:23:48','2025-02-07 03:23:48'),(61,8,6,1,'2025-02-21 02:35:11','2025-02-21 02:35:11'),(62,8,4,0,'2025-03-22 14:29:19','2025-03-22 14:29:19'),(63,8,11,1,'2025-03-22 14:29:21','2025-03-22 14:29:21'),(64,8,15,0,'2025-03-22 14:30:24','2025-03-22 14:30:24'),(65,8,22,1,'2025-03-22 14:30:25','2025-03-22 14:30:25'),(66,8,5,1,'2025-04-03 09:10:22','2025-04-03 09:10:22'),(67,8,24,1,'2025-04-03 09:10:30','2025-04-03 09:10:30'),(68,8,13,1,'2025-04-03 09:11:31','2025-04-03 09:11:31'),(69,8,10,0,'2025-04-03 09:22:34','2025-04-03 09:22:34'),(70,8,16,0,'2025-04-03 13:50:34','2025-04-03 13:50:34'),(71,8,19,0,'2025-04-05 07:53:46','2025-04-05 07:53:46'),(73,4,9,1,'2026-01-27 18:26:40','2026-01-27 18:26:40');
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logistics`
--

DROP TABLE IF EXISTS `logistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logistics` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '物流ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货地址',
  `company_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物流公司名称',
  `tracking_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物流单号',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '物流状态:0待发货,1已发货,2已签收,3已取消',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `expected_arrival_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  KEY `idx_tracking_number` (`tracking_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='物流信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logistics`
--

LOCK TABLES `logistics` WRITE;
/*!40000 ALTER TABLE `logistics` DISABLE KEYS */;
INSERT INTO `logistics` VALUES (3,114,'演示用户','13800000008','13800000008','中通快递','11111',1,'2025-04-01 15:37:28','2025-04-01 15:37:28',NULL),(4,42,'演示卖方一','13800138004','广州市天河区某街道4号','圆通快递','111111',1,'2025-04-01 15:38:58','2025-04-01 15:38:58',NULL),(5,13,'演示卖方一','13800138004','广州市天河区某街道2号','圆通快递','11111111111',1,'2025-04-01 15:42:07','2025-04-01 15:42:07',NULL),(7,110,'演示用户','13800000008','13800000008','圆通快递','1111111',1,'2025-04-01 15:47:19','2025-04-01 15:47:19','2025-04-15 16:00:00'),(8,117,'演示用户','13800000008','13800000008','中通快递','11111111111111',1,'2025-04-15 12:34:22','2025-04-15 12:34:22','2025-04-16 16:00:00'),(9,115,'演示用户','13800000008','13800000008','顺丰快递','SF32435454343453',1,'2025-04-16 15:34:49','2025-04-16 15:34:49','2025-04-22 16:00:00'),(10,119,'演示用户','13800000008','13800000008','圆通快递','YT461638541635413',1,'2025-05-01 16:21:56','2025-05-01 16:21:56','2025-05-21 16:00:00'),(11,120,'演示用户','13800000008','13800000008','中通快递','ZT3456789O0P',1,'2025-05-05 11:46:20','2025-05-05 11:46:20','2025-05-28 16:00:00'),(12,125,'123','13800138001','北京市朝阳区某街道1号','顺丰快递','1123333',1,'2025-06-03 11:44:21','2025-06-03 11:44:21','2025-06-03 11:44:17'),(14,130,'123','13800138001','北京市朝阳区某街道1号','顺丰快递','12345678',2,'2025-06-04 03:50:14','2025-06-04 03:50:14','2025-06-04 16:00:00'),(15,129,'123','13800138001','北京市朝阳区某街道1号','圆通快递','456785211',2,'2025-06-04 03:50:23','2025-06-04 03:50:23','2025-06-04 16:00:00'),(16,123,'演示用户','13800000008','13800000008','顺丰快递','1234566',1,'2025-06-04 04:18:00','2025-06-04 04:18:00','2025-06-04 16:00:00');
/*!40000 ALTER TABLE `logistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公告标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (33,'绿证交易优惠活动开启！','为推广绿色能源交易，平台推出限时优惠活动，购买绿证可享受积分返还！','2024-03-20 08:00:00','预售,特惠'),(34,'平台绿证质量管理公告','为保证绿证交易质量，平台已开展绿证核验行动：1.所有发电企业需提供最新资质证明 2.绿证来源需可追溯 3.交易记录全程可查 请广大用户放心交易！','2024-03-18 10:30:00','质量管理,公告'),(35,'新能源发电企业入驻公告','平台新增多家优质风力发电、光伏发电企业，绿证供应更加充足！','2024-03-15 09:00:00','新能源,入驻'),(36,'绿证交易流程说明','绿证交易流程：注册账户→实名认证→充值积分→选择绿证→完成交易→获取证书','2024-03-12 14:00:00','交易,流程');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_price` decimal(10,2) NOT NULL COMMENT '订单总价',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '订单状态:0待支付,1已支付,2已发货,3已完成,4已取消,5退款中,6已退款,7退款失败',
  `last_status` tinyint NOT NULL DEFAULT '0' COMMENT '上一个订单状态',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单备注',
  `refund_time` timestamp NULL DEFAULT NULL COMMENT '退款时间',
  `refund_status` tinyint DEFAULT '0' COMMENT '退款状态:0无退款,1申请退款,2退款中,3已退款,4退款失败',
  `refund_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '退款原因',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '购买数量',
  `price` decimal(10,2) NOT NULL COMMENT '商品单价',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `recv_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '地址信息',
  `recv_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系方式',
  `recv_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'NULL',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `idx_order_user` (`user_id`) USING BTREE COMMENT '订单用户索引',
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (2,4,59.90,2,0,NULL,NULL,0,NULL,3,1,59.90,'2025-02-03 02:46:11','2025-02-03 02:46:11',NULL,NULL,NULL),(3,5,299.00,1,0,NULL,NULL,0,NULL,4,1,299.00,'2025-02-03 02:46:11','2025-02-03 02:46:11',NULL,NULL,NULL),(5,4,14.40,4,0,NULL,NULL,0,NULL,5,3,4.80,'2025-02-03 02:46:11','2025-02-03 02:46:11',NULL,NULL,NULL),(6,1,47.40,6,5,'111','2025-05-01 15:47:21',3,NULL,5,3,15.80,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(7,1,159.00,4,0,NULL,NULL,0,NULL,12,1,53.00,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(8,1,86.70,1,0,NULL,NULL,0,NULL,18,2,28.90,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(9,1,196.50,0,0,NULL,NULL,0,NULL,22,1,65.50,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(10,1,75.60,4,0,NULL,NULL,0,NULL,8,5,12.60,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(11,1,138.00,6,0,NULL,NULL,0,NULL,15,4,34.50,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(12,2,128.40,2,0,NULL,NULL,0,NULL,3,2,42.80,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(13,2,89.70,2,2,NULL,NULL,0,NULL,20,1,17.94,'2025-02-03 08:02:13','2025-02-03 08:02:13','广州市天河区某街道2号','13800138004',NULL),(14,2,156.00,7,0,NULL,NULL,0,NULL,7,1,39.00,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(15,2,234.50,3,2,NULL,NULL,0,NULL,16,1,78.17,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(16,2,95.40,4,0,NULL,NULL,0,NULL,24,3,15.90,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(17,2,177.00,7,0,'',NULL,0,NULL,11,3,44.25,'2025-02-03 08:02:13','2025-02-04 05:26:37',NULL,NULL,NULL),(18,3,147.00,4,0,NULL,NULL,0,NULL,2,3,49.00,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(19,3,88.50,7,0,NULL,NULL,0,NULL,19,2,22.13,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(20,3,165.00,7,5,'','2025-04-16 15:34:30',4,NULL,6,5,33.00,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(22,3,104.40,1,0,NULL,NULL,0,NULL,23,1,17.40,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(23,3,198.00,5,0,NULL,NULL,0,NULL,10,1,49.50,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(26,4,144.00,3,0,NULL,NULL,0,NULL,4,1,28.80,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(27,4,289.50,1,0,NULL,NULL,0,NULL,13,1,96.50,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(28,4,113.40,6,0,NULL,NULL,0,NULL,21,1,18.90,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(29,4,219.00,2,0,NULL,NULL,0,NULL,9,4,54.75,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(31,5,106.50,4,0,NULL,NULL,0,NULL,15,2,26.63,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(32,5,123.00,6,0,NULL,NULL,0,NULL,5,2,24.60,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(33,5,312.50,4,0,NULL,NULL,0,NULL,11,1,104.17,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(34,5,122.40,4,0,NULL,NULL,0,NULL,20,6,20.40,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(35,5,240.00,5,0,NULL,NULL,0,NULL,8,1,60.00,'2025-02-03 08:02:13','2025-02-03 08:02:13',NULL,NULL,NULL),(42,2,59.80,2,2,NULL,NULL,0,NULL,16,2,29.90,'2025-02-04 01:45:12','2025-02-04 02:45:36','广州市天河区某街道4号','13800138004',NULL),(43,2,55.00,0,0,NULL,NULL,0,NULL,9,1,55.00,'2025-02-04 05:54:35','2025-02-04 05:54:35','广州市天河区某街道4号','13800138004',NULL),(110,8,4.80,2,2,NULL,'2025-03-22 15:48:07',1,'商品与描述不符',5,1,4.80,'2025-03-06 11:58:23','2025-04-01 15:46:34','13800000008','13800000008',NULL),(112,8,299.00,1,0,NULL,NULL,0,NULL,4,10,299.00,'2025-03-22 15:46:39','2025-04-02 06:28:32','13800000008','13800000008',NULL),(114,8,4.80,2,2,NULL,NULL,0,NULL,5,1,4.80,'2025-04-01 15:37:05','2025-04-01 15:37:05','13800000008','13800000008',NULL),(115,8,15.60,2,2,NULL,NULL,0,NULL,6,1,15.60,'2025-04-01 16:10:46','2025-04-01 16:10:46','13800000008','13800000008',NULL),(116,8,65.80,1,0,NULL,NULL,0,NULL,7,4,32.90,'2025-04-01 16:43:13','2025-04-02 06:28:38','13800000008','13800000008',NULL),(117,8,4.80,2,2,NULL,NULL,0,NULL,5,1,4.80,'2025-04-02 06:41:10','2025-04-02 06:41:10','13800000008','13800000008',NULL),(118,8,32.90,1,0,NULL,NULL,0,NULL,7,1,32.90,'2025-04-02 06:45:05','2025-04-02 06:45:05','13800000008','13800000008',NULL),(119,8,89.70,2,2,NULL,NULL,0,NULL,16,3,29.90,'2025-04-16 15:33:16','2025-04-16 15:33:16','13800000008','13800000008',NULL),(120,8,46.80,2,2,NULL,NULL,0,NULL,6,3,15.60,'2025-05-01 16:25:07','2025-05-01 16:25:07','13800000008','13800000008','演示用户'),(121,8,15.80,1,0,NULL,NULL,0,NULL,1,1,15.80,'2025-05-02 08:04:05','2025-05-02 08:04:05','13800000008','13800000008','演示用户'),(122,8,3.50,1,0,NULL,NULL,0,NULL,2,1,3.50,'2025-05-02 08:11:20','2025-05-02 08:11:20','13800000008','13800000008','演示用户'),(123,8,63.20,2,2,NULL,NULL,0,NULL,1,4,15.80,'2025-05-05 11:37:58','2025-05-05 11:37:58','13800000008','13800000008','演示用户'),(125,4,32.90,2,2,NULL,NULL,0,NULL,7,1,32.90,'2025-06-03 10:37:56','2025-06-03 10:37:56','北京市朝阳区某街道1号','13800138001','123'),(126,4,3.90,0,0,NULL,NULL,0,NULL,13,1,3.90,'2025-06-04 03:47:24','2025-06-04 03:47:24','北京市朝阳区某街道1号','13800138001','123'),(127,4,29.90,0,0,NULL,NULL,0,NULL,16,1,29.90,'2025-06-04 03:47:24','2025-06-04 03:47:24','北京市朝阳区某街道1号','13800138001','123'),(128,4,9.60,0,0,NULL,NULL,0,NULL,5,2,4.80,'2025-06-04 03:47:24','2025-06-04 03:47:24','北京市朝阳区某街道1号','13800138001','123'),(129,4,65.80,3,2,NULL,NULL,0,NULL,7,2,32.90,'2025-06-04 03:48:47','2025-06-04 03:48:47','北京市朝阳区某街道1号','13800138001','123'),(130,4,55.00,3,2,NULL,NULL,0,NULL,9,1,55.00,'2025-06-04 03:48:48','2025-06-04 03:48:48','北京市朝阳区某街道1号','13800138001','123'),(131,4,31.20,6,5,'','2025-06-04 04:17:46',3,'商品质量问题',6,2,15.60,'2025-06-04 04:16:26','2025-06-04 04:16:26','北京市朝阳区某街道1号','13800138001','123'),(132,4,12.50,1,0,NULL,NULL,0,NULL,12,1,12.50,'2026-01-27 16:51:30','2026-01-27 16:51:30','北京市朝阳区某街道1号','13800138001','123');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `place_of_origin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '产地',
  `is_discount` tinyint DEFAULT NULL COMMENT '是否开启折扣',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '商品描述',
  `price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `stock` int NOT NULL DEFAULT '0' COMMENT '库存数量',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品图片URL',
  `sales_count` int NOT NULL DEFAULT '0' COMMENT '销量',
  `merchant_id` bigint NOT NULL COMMENT '商户（卖方）ID',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '商品状态:0下架,1上架',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `discount_price` decimal(10,2) DEFAULT NULL COMMENT '折扣价格',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `merchant_id` (`merchant_id`) USING BTREE,
  KEY `idx_product_name` (`name`) USING BTREE COMMENT '商品名称索引',
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`merchant_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('陆上风电',NULL,1,'内蒙古风电场绿证','内蒙古大型风电场绿证，装机容量100MW，年发电量约2.4亿kWh，符合国家可再生能源配额制要求。',15.80,1000,1,'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=400',505,2,1,'2025-02-03 02:46:11','2026-01-27 17:13:57',NULL),('集中式光伏',NULL,2,'青海光伏电站绿证','青海高原集中式光伏电站绿证，装机容量50MW，年均发电约6500万kWh，光照充足，发电效率高。',3.50,489,2,'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400',211,2,1,'2025-02-03 02:46:11','2026-01-27 17:13:57',NULL),('大型水电',NULL,3,'三峡水电站绿证','三峡水电站核发绿证，全球最大水电站，清洁能源典范，稳定可靠。',59.90,996,3,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400',301,3,1,'2025-02-03 02:46:11','2026-01-27 17:13:57',NULL),('农林生物质',NULL,4,'山东秸秆发电绿证','山东农林生物质发电绿证，利用秸秆等农业废弃物发电，变废为宝，助力乡村振兴。',299.00,87,4,'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=400',60,3,1,'2025-02-03 02:46:11','2026-01-27 17:13:57',NULL),('风光互补',NULL,5,'风光互补电站绿证','风光互补电站绿证，风能+太阳能联合发电，24小时稳定供电，效率更高。',4.80,191,5,'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400',151,2,1,'2025-02-03 02:46:11','2026-01-27 17:13:57',NULL),('陆上风电',1,6,'甘肃风电场绿证','甘肃河西走廊风电基地绿证，大规模风力发电场，清洁能源电力输送至全国。',25.80,780,1,'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=400',331,2,0,'2025-02-03 02:46:53','2026-01-27 17:14:05',15.60),('陆上风电',NULL,7,'新疆风电场绿证','新疆达坂城风电场绿证，中国风能资源最丰富地区之一，风力发电效率卓越。',32.90,87,1,'https://images.unsplash.com/photo-1548337138-e87d889cc369?w=400',1289,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:05',NULL),('海上风电',0,8,'江苏海上风电绿证','<p>江苏如东海上风电场绿证，近海风力发电，环保高效，助力东部沿海碳中和。</p>',23.50,404,1,'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=400',150,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:05',NULL),('海上风电',1,9,'山东海上风电绿证','山东半岛海上风电场绿证，渤海海域大型风电项目，稳定持续绿色电力。',68.00,299,1,'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=400',181,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:05',55.00),('集中式光伏',1,10,'宁夏光伏电站绿证','<p>宁夏光伏产业园区绿证，西北地区优质光照资源，光伏发电基地。</p>',5.80,800,2,'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d?w=400',420,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:05',1.00),('高原光伏',NULL,11,'西藏光伏电站绿证','西藏高原光伏电站绿证，世界屋脊光照强度最高地区，清洁能源典范项目。',28.90,253,2,'https://images.unsplash.com/photo-1559302504-64aae6ca6b6d?w=400',91,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:12',NULL),('分布式光伏',NULL,12,'广东分布式光伏绿证','广东工商业分布式光伏绿证，屋顶光伏自发自用余电上网，企业碳减排首选。',12.50,598,2,'https://images.unsplash.com/photo-1613665813446-82a78c468a1d?w=400',231,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:12',NULL),('分布式光伏',NULL,13,'浙江分布式光伏绿证','浙江家庭分布式光伏绿证，户用光伏发电，绿色低碳生活方式。',3.90,999,2,'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400',581,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:12',NULL),('大型水电',NULL,15,'溪洛渡水电站绿证','溪洛渡水电站绿证，金沙江大型水电枢纽，年均发电约640亿kWh。',168.00,200,3,'https://images.unsplash.com/photo-1504297050568-910d24c426d3?w=400',120,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:12',NULL),('大型水电',NULL,16,'白鹤滩水电站绿证','白鹤滩水电站绿证，全球在建最大水电站，装机容量1600万千瓦。',29.90,1495,3,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400',455,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:20',NULL),('农林生物质',NULL,18,'黑龙江生物质绿证','黑龙江农林生物质绿证，东北地区秸秆综合利用发电项目，环保循环经济。',46.80,500,4,'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',280,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:20',NULL),('农林生物质',NULL,19,'广西甘蔗渣发电绿证','广西甘蔗渣生物质发电绿证，糖厂废弃物资源化利用，绿色循环发电。',288.00,98,4,'https://images.unsplash.com/photo-1558449028-b53a39d100fc?w=400',61,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:20',NULL),('垃圾发电',1,20,'河南垃圾发电绿证','河南垃圾焚烧发电绿证，城市生活垃圾无害化处理发电，环保减量。',58.90,300,4,'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400',150,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:20',48.90),('沼气发电',NULL,21,'江苏沼气发电绿证','江苏规模化沼气发电绿证，农业养殖废弃物沼气发电，生态农业循环模式。',8.80,600,4,'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=400',320,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:26',NULL),('光储一体',NULL,22,'光储一体化绿证','光储一体化电站绿证，光伏+储能系统，削峰填谷电力更稳定。',9.90,400,5,'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=400',280,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:26',NULL),('综合能源',NULL,23,'智慧能源园区绿证','智慧能源园区绿证，多能互补综合能源系统，智慧管理高效运营。',6.80,300,5,'https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=400',220,3,1,'2025-02-03 02:46:53','2026-01-27 17:14:26',NULL),('多能互补',NULL,24,'多能互补电站绿证','多能互补电站绿证，风、光、水、储联合运营，清洁能源最优配置。',8.50,797,5,'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=400',463,2,1,'2025-02-03 02:46:53','2026-01-27 17:14:26',NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `rating` tinyint NOT NULL COMMENT '评分(1-5星)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '评价内容',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '评价状态:0待审核,1已通过,2已拒绝',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `idx_review_product` (`product_id`) USING BTREE COMMENT '评价商品索引',
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `review_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,4,1,5,'苹果非常甜，很好吃！',1,'2025-02-03 02:46:11'),(2,4,3,4,'大米品质不错',1,'2025-02-03 02:46:11'),(3,5,2,5,'胡萝卜新鲜爽脆',1,'2025-02-03 02:46:11'),(4,5,4,5,'松茸很新鲜，味道好极了',1,'2025-02-03 02:46:11'),(9,8,5,5,'很好啊！！！！！！666',1,'2025-03-20 16:12:35');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_in`
--

DROP TABLE IF EXISTS `stock_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_in` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '入库ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '入库数量',
  `unit_price` decimal(10,2) NOT NULL COMMENT '单价',
  `total_price` decimal(10,2) NOT NULL COMMENT '总价',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '供应商',
  `stock_date` date NOT NULL COMMENT '入库日期',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态:0-作废,1-正常',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='入库记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_in`
--

LOCK TABLES `stock_in` WRITE;
/*!40000 ALTER TABLE `stock_in` DISABLE KEYS */;
INSERT INTO `stock_in` VALUES (2,11,55,20.00,1100.00,'2222','2025-03-06',2,'',1,'2025-03-06 11:59:03','2025-03-06 11:59:03'),(3,8,1,11.00,11.00,'11','2026-01-27',2,'11',1,'2026-01-27 18:28:30','2026-01-27 18:28:30');
/*!40000 ALTER TABLE `stock_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_out`
--

DROP TABLE IF EXISTS `stock_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_out` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '出库ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '出库数量',
  `unit_price` decimal(10,2) NOT NULL COMMENT '单价',
  `total_price` decimal(10,2) NOT NULL COMMENT '总价',
  `type` tinyint NOT NULL COMMENT '出库类型:1-销售出库,2-损耗出库,3-其他出库',
  `customer_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户姓名',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单号',
  `operator_id` bigint NOT NULL COMMENT '操作人ID',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态:0-作废,1-正常',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='出库记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_out`
--

LOCK TABLES `stock_out` WRITE;
/*!40000 ALTER TABLE `stock_out` DISABLE KEYS */;
INSERT INTO `stock_out` VALUES (1,10,20,5.80,116.00,1,NULL,NULL,1,'',0,'2025-03-05 15:24:46','2025-03-05 15:24:46'),(2,12,1,12.50,12.50,1,'蒋大侠','52425',2,'4245',1,'2025-03-06 11:59:33','2025-03-06 11:59:33');
/*!40000 ALTER TABLE `stock_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_buying`
--

DROP TABLE IF EXISTS `group_buying`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_buying` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '拼团ID',
  `product_id` bigint NOT NULL COMMENT '关联商品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '拼团名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '活动描述',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '活动图片URL',
  `original_price` decimal(10,2) NOT NULL COMMENT '原价',
  `group_price` decimal(10,2) NOT NULL COMMENT '拼团价',
  `target_count` int NOT NULL DEFAULT '10' COMMENT '成团所需数量',
  `current_count` int NOT NULL DEFAULT '0' COMMENT '当前已参团数量',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态:0进行中,1已成团,2已结束',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '截止时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  CONSTRAINT `group_buying_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='绿证拼团活动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_buying`
--

LOCK TABLES `group_buying` WRITE;
/*!40000 ALTER TABLE `group_buying` DISABLE KEYS */;
INSERT INTO `group_buying` VALUES (1,6,'甘肃风电场绿证拼团','甘肃优质风电绿证，拼团享折扣优惠','https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=800',25.80,20.60,50,42,0,'2026-12-31 23:59:59','2026-01-10 09:00:00','2026-01-10 09:00:00'),(2,7,'新疆风电场绿证拼团','新疆大型风电项目绿证，拼团立省20%','https://images.unsplash.com/photo-1548337138-e87d889cc369?w=800',32.90,26.30,30,18,0,'2026-12-31 23:59:59','2026-01-10 09:00:00','2026-01-10 09:00:00'),(3,9,'山东海上风电绿证拼团','山东半岛海上风电项目绿证团购','https://images.unsplash.com/photo-1532601224476-15c79f2f7a51?w=800',68.00,55.00,20,20,1,'2026-06-30 23:59:59','2026-01-05 09:00:00','2026-01-05 09:00:00');
/*!40000 ALTER TABLE `group_buying` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_buying_member`
--

DROP TABLE IF EXISTS `group_buying_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_buying_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `group_id` bigint NOT NULL COMMENT '拼团活动ID',
  `user_id` bigint NOT NULL COMMENT '参团用户ID',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '参团时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `group_id` (`group_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `group_buying_member_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `group_buying` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `group_buying_member_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='拼团参与记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `long_term_agreement`
--

DROP TABLE IF EXISTS `long_term_agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `long_term_agreement` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '协议ID',
  `template_id` bigint DEFAULT NULL COMMENT '协议模板ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '协议名称',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'monthly' COMMENT '协议类型:monthly,quarterly,yearly',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '企业名称',
  `credit_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '统一社会信用代码',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `contact_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系邮箱',
  `quantity` int NOT NULL COMMENT '采购数量',
  `price` decimal(10,2) DEFAULT NULL COMMENT '协议单价',
  `start_date` timestamp NULL DEFAULT NULL COMMENT '预计开始日期',
  `purpose` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用途说明',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态:0待审核,1已通过,2已拒绝,3已终止',
  `user_id` bigint DEFAULT NULL COMMENT '提交用户ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='长期购买协议表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `long_term_agreement`
--

LOCK TABLES `long_term_agreement` WRITE;
/*!40000 ALTER TABLE `long_term_agreement` DISABLE KEYS */;
INSERT INTO `long_term_agreement` VALUES (1,NULL,'年度绿证采购协议','yearly','示例科技有限公司','91110000MA01T3XXXX','王经理','13800000001','demo-buyer@example.com',1200,24.80,'2026-04-01 00:00:00','年度碳中和目标','演示数据',1,4,'2026-01-15 10:30:00','2026-01-15 11:00:00');
/*!40000 ALTER TABLE `long_term_agreement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict`
--

DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典编码',
  `dict_type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_dict_type_code` (`dict_type_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统字典表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict`
--

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
INSERT INTO `sys_dict` VALUES (1,'icon','图标','系统图标字典表',0,'2024-07-30 21:53:19','2024-07-30 21:53:19');
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `role` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单角色',
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `pid` int DEFAULT NULL COMMENT '菜单父id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '页面路径',
  `sort_num` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES ('ADMIN,SUPER_ADMIN,SELLER',1,'数据概览','/showView','el-icon-s-data','系统数据统计',NULL,'ShowView',1),('ADMIN,SUPER_ADMIN,SELLER',2,'个人中心',NULL,'el-icon-user','用户个人信息管理',NULL,NULL,2),('ADMIN,SUPER_ADMIN,SELLER',3,'基本信息','/personInfo','el-icon-info',NULL,2,'PersonInfo',1),('ADMIN,SUPER_ADMIN,SELLER',4,'修改密码','/password','el-icon-lock',NULL,2,'Password',2),('ADMIN,SUPER_ADMIN,SELLER',10,'绿证管理',NULL,'el-icon-shopping-bag-1','农产品相关管理',NULL,NULL,3),('ADMIN,SUPER_ADMIN,SELLER',11,'绿证列表','/productManager','el-icon-shopping-cart-full',NULL,10,'ProductManager',1),('ADMIN,SUPER_ADMIN',12,'绿证类型','/categoryManager','el-icon-folder',NULL,10,'CategoryManager',2),('ADMIN,SUPER_ADMIN,SELLER',20,'交易管理',NULL,'el-icon-shopping-cart-2','订单相关管理',NULL,NULL,4),('ADMIN,SUPER_ADMIN,SELLER',21,'订单列表','/orderManager','el-icon-document',NULL,20,'OrderManager',1),('ADMIN,SUPER_ADMIN',22,'购物车','/cartManager','el-icon-shopping-cart-1',NULL,20,'CartManager',2),('ADMIN,SUPER_ADMIN,SELLER',23,'绿证评价','/reviewManager','el-icon-chat-dot-square',NULL,20,'ReviewManager',3),('ADMIN,SUPER_ADMIN',30,'系统管理',NULL,'el-icon-setting','系统相关配置',NULL,NULL,5),('ADMIN,SUPER_ADMIN',31,'用户管理','/userManager','el-icon-user',NULL,30,'UserManager',1),('ADMIN,SUPER_ADMIN',32,'公告管理','/notices','el-icon-bell',NULL,30,'NoticeList',2),('SELLER,ADMIN,SUPER_ADMIN',33,'轮播图','/carouselManager','el-icon-picture',NULL,30,'CarouselManager',3),('SUPER_ADMIN',40,'开发配置',NULL,'el-icon-s-tools','系统开发配置',NULL,NULL,6),('SUPER_ADMIN',41,'菜单管理','/menu','el-icon-menu',NULL,40,'Menu',1),('SUPER_ADMIN',42,'图标库','/iconItem','el-icon-picture-outline-round',NULL,40,'IconItem',2),('SUPER_ADMIN,ADMIN,SELLER',70,'物流管理','/logisticsManager','el-icon-shopping-cart-1','',20,'LogisticsManager',1),('ADMIN,SUPER_ADMIN,SELLER',71,'库存管理',NULL,'el-icon-tableware',NULL,NULL,NULL,8),('SUPER_ADMIN,ADMIN,SELLER',72,'入库管理','/stockInManager','el-icon-more','',71,'StockInManager',0),('SUPER_ADMIN,ADMIN,SELLER',73,'出库管理','/stockOutManager','el-icon-check','',71,'StockOutManager',0),('ADMIN,SUPER_ADMIN',74,'资讯管理','/articleManager','el-icon-menu',NULL,NULL,'ArticleManager',1);
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `business_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名',
  `role` enum('SUPER_ADMIN','ADMIN','USER','MERCHANT','SELLER','BUYER') NOT NULL DEFAULT 'BUYER',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '电子邮箱',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '账号状态(0禁用,1启用)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `idx_user_username` (`username`) USING BTREE COMMENT '用户名索引'
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (NULL,1,'Sadmin','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','系统管理员','SUPER_ADMIN','superadmin@example.com',1,'2025-02-03 02:46:11','2025-02-03 03:26:45'),('/img/1746233584273.jpeg',2,'seller','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','演示卖方一','SELLER','seller1@example.com',1,'2025-02-03 02:46:11','2026-01-27 15:51:29'),(NULL,3,'seller2','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','演示卖方二','SELLER','seller2@example.com',1,'2025-02-03 02:46:11','2026-01-27 15:51:29'),(NULL,4,'user','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','王小明','BUYER','user1@example.com',1,'2025-02-03 02:46:11','2026-01-27 15:51:29'),(NULL,5,'user2','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','李小红','BUYER','user2@example.com',1,'2025-02-03 02:46:11','2026-01-27 15:51:29'),(NULL,7,'admin','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','管理员1','ADMIN','admin@example.com',1,'2025-02-04 12:22:32','2025-03-22 16:13:24'),(NULL,8,'demo8','$2a$10$rLSOIEHVdA8OxuofPJUmNe.zEJHicLJ.0QyH00YHtWDslBNcJA4W2','演示用户','BUYER','demo8@example.com',1,'2025-02-07 02:49:19','2026-01-27 15:51:29');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-06 22:20:39
