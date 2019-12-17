/*
Navicat MySQL Data Transfer

Source Server         : erp
Source Server Version : 50717
Source Host           : 139.224.1.36:3306
Source Database       : erp

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2017-11-06 11:00:08
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sys_country
-- ----------------------------
DROP TABLE IF EXISTS `sys_country`;
CREATE TABLE `sys_country` (
  `id` varchar(64) NOT NULL,
  `aname` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '英文名称',
  `zh_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '中文名称',
  `code` varchar(5) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '简写',
  `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
  `update_date` datetime DEFAULT NULL COMMENT '更新时间',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`),
  KEY `name` (`aname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_country
-- ----------------------------
INSERT INTO `sys_country` VALUES ('1', 'Afghanistan', '阿富汗', 'AF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('10', 'Argentina', '阿根廷', 'AR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('100', 'India', '印度', 'IN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('101', 'Indonesia', '印度尼西亚', 'ID', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('102', 'Iran (Islamic Republic of)', 'Iran (Islamic Republic of)', 'IR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('103', 'Iraq', '伊拉克', 'IQ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('104', 'Ireland', '爱尔兰', 'IE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('105', 'Isle of Man', '英国属地曼岛', 'IM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('106', 'Israel', '以色列', 'IL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('107', 'Italy', '意大利', 'IT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('108', 'Jamaica', '牙买加', 'JM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('109', 'Japan', '日本', 'JP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('11', 'Armenia', '亚美尼亚', 'AM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('110', 'Jordan', '约旦', 'JO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('111', 'Kazakhstan', '哈萨克', 'KZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('112', 'Kenya', '肯尼亚', 'KE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('113', 'Kiribati', '吉尔巴斯', 'KI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('114', 'Kuwait', '科威特', 'KW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('115', 'Kyrgyzstan', '吉尔吉斯', 'KG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('116', 'Lao People\'s Democratic Republic', 'Lao People\'s Democratic Republic', 'LA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('117', 'Latvia', '拉脱维亚', 'LV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('118', 'Lebanon', '黎巴嫩', 'LB', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('119', 'Lesotho', '莱索托', 'LS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('12', 'Aruba', '阿鲁巴', 'AW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('120', 'Liberia', '利比里亚', 'LR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('121', 'Libyan Arab Jamahiriya', '利比亚', 'LY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('122', 'Liechtenstein', '列支敦士登', 'LI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('123', 'Lithuania', '立陶宛', 'LT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('124', 'Luxembourg', '卢森堡', 'LU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('125', 'Macau', '澳门地区', 'MO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('126', 'Madagascar', '马达加斯加', 'MG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('127', 'Malawi', '马拉维', 'MW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('128', 'Malaysia', '马来西亚', 'MY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('129', 'Maldives', '马尔代夫', 'MV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('13', 'Australia', '澳大利亚', 'AU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('130', 'Mali', '马里', 'ML', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('131', 'Malta', '马尔他', 'MT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('132', 'Marshall Islands', '马绍尔群岛', 'MH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('133', 'Martinique', '马提尼克岛', 'MQ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('134', 'Mauritania', '毛里塔尼亚', 'MR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('135', 'Mauritius', '毛里求斯', 'MU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('136', 'Mayotte', '马约特', 'YT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('137', 'Mexico', '墨西哥', 'MX', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('138', 'Micronesia', '密克罗尼西亚', 'FM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('139', 'Moldova', '摩尔多瓦', 'MD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('14', 'Austria', '奥地利', 'AT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('140', 'Monaco', '摩纳哥', 'MC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('141', 'Mongolia', '外蒙古', 'MN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('142', 'Montenegro', 'Montenegro', 'MNE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('143', 'Montserrat', '蒙特色纳', 'MS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('144', 'Morocco', '摩洛哥', 'MA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('145', 'Mozambique', '莫桑比克', 'MZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('146', 'Myanmar', '缅甸', 'MM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('147', 'Namibia', '那米比亚', 'NA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('148', 'Nauru', '瑙鲁', 'NR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('149', 'Nepal', '尼泊尔', 'NP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('15', 'Azerbaijan', '阿塞拜疆', 'AZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('150', 'Netherlands', '荷兰', 'NL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('151', 'Netherlands Antilles', '荷兰安的列斯群岛', 'AN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('152', 'New Caledonia', '新加勒多尼亚', 'NC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('153', 'New Zealand', '新西兰', 'NZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('154', 'Nicaragua', '尼加拉瓜', 'NI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('155', 'Niger', '尼日尔', 'NE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('156', 'Nigeria', '尼日利亚', 'NG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('157', 'Niue', '纽鄂岛', 'NU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('158', 'Norfolk Island', '诺福克岛', 'NF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('159', 'North Korea', '朝鲜', 'KP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('16', 'Bahamas', '巴哈马', 'BS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('160', 'Northern Mariana Islands', '北马里亚纳群岛', 'MP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('161', 'Norway', '挪威', 'NO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('162', 'Oman', '阿曼', 'OM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('163', 'Pakistan', '巴基斯坦', 'PK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('164', 'Palau', '帛琉', 'PW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('165', 'Palestine', '巴勒斯坦', 'PS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('166', 'Panama', '巴拿马', 'PA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('167', 'Papua New Guinea', '巴布亚新几内亚', 'PG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('168', 'Paraguay', '巴拉圭', 'PY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('169', 'Peru', '秘鲁', 'PE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('17', 'Bahrain', '巴林', 'BH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('170', 'Philippines', '菲律宾共和国', 'PH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('171', 'Pitcairn', '皮特凯恩岛', 'PN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('172', 'Poland', '波兰', 'PL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('173', 'Portugal', '葡萄牙', 'PT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('174', 'Puerto Rico', '波多黎各', 'PR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('175', 'Qatar', '卡塔尔', 'QA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('176', 'Reunion', 'Reunion', 'RE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('177', 'Romania', '罗马尼亚', 'RO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('178', 'Russian Federation', '俄罗斯联邦', 'RU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('179', 'Rwanda', '卢旺达', 'RW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('18', 'Bangladesh', '孟加拉国', 'BD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('180', 'Saint Kitts and Nevis', '圣吉斯和尼维斯', 'KN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('181', 'Saint Lucia', '圣卢西亚', 'LC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('182', 'Saint Vincent and the Grenadines', '圣文森和格林纳丁斯', 'VC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('183', 'Samoa', '美属萨摩亚', 'WS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('184', 'San Marino', 'San Marino', 'SM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('185', 'Sao Tome and Principe', '圣多美和普林西比', 'ST', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('186', 'Saudi Arabia', '沙特阿拉伯', 'SA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('187', 'Senegal', '塞内加尔', 'SN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('188', 'Serbia', '塞尔维亚共和国', 'SRB', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('189', 'Seychelles', '塞锡尔群岛', 'SC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('19', 'Barbados', '巴巴多斯', 'BB', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('190', 'Sierra Leone', '塞拉利昂', 'SL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('191', 'Singapore', '新加坡', 'SG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('192', 'Slovakia (Slovak Republic)', '斯洛伐克（斯洛伐克人的共和国）', 'SK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('193', 'Slovenia', '斯洛文尼亚', 'SI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('194', 'Solomon Islands', '索罗门群岛', 'SB', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('195', 'Somalia', '索马里', 'SO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('196', 'South Africa', '南非', 'ZA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('197', 'South Korea', '韩国', 'KR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('198', 'Spain', '西班牙', 'ES', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('199', 'Sri Lanka', '斯里兰卡', 'LK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('2', 'Albania', '阿尔巴尼亚', 'AL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('20', 'Belarus', '白俄罗斯', 'BY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('200', 'St. Helena', '圣海伦娜', 'SH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('201', 'St. Pierre and Miquelon', '圣皮埃尔和密克罗', 'PM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('202', 'Sudan', '苏丹', 'SD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('203', 'Suriname', '苏里南', 'SR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('204', 'Svalbard and Jan Mayen Islands', '冷岸和央麦恩群岛', 'SJ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('205', 'Swaziland', '斯威士兰', 'SZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('206', 'Sweden', '瑞典', 'SE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('207', 'Switzerland', '瑞士', 'CH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('208', 'Syrian Arab Republic', '叙利亚', 'SY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('209', 'Taiwan', '台湾地区', 'TW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('21', 'Belgium', '比利时', 'BE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('210', 'Tajikistan', '塔吉克', 'TJ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('211', 'Tanzania', '坦桑尼亚', 'TZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('212', 'Thailand', '泰国', 'TH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('213', 'The former Yugoslav Republic of Macedonia', '前马其顿南斯拉夫共和国', 'MK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('214', 'Togo', '多哥', 'TG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('215', 'Tokelau', '托克劳', 'TK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('216', 'Tonga', '汤加', 'TO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('217', 'Trinidad and Tobago', '千里达托贝哥共和国', 'TT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('218', 'Tunisia', '北非共和国', 'TN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('219', 'Turkey', '土耳其', 'TR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('22', 'Belize', '伯利兹城', 'BZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('220', 'Turkmenistan', '土库曼', 'TM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('221', 'Turks and Caicos Islands', '土克斯和开科斯群岛', 'TC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('222', 'Tuvalu', '图瓦卢', 'TV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('223', 'Uganda', '乌干达', 'UG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('224', 'Ukraine', '乌克兰', 'UA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('225', 'United Arab Emirates', '阿拉伯联合酋长国', 'AE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('226', 'United Kingdom', '英国', 'UK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('227', 'United States', '美国', 'US', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('228', 'United States Minor Outlying Islands', '美国小离岛', 'UM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('229', 'Uruguay', '乌拉圭', 'UY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('23', 'Benin', '贝宁', 'BJ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('230', 'Uzbekistan', '乌兹别克斯坦', 'UZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('231', 'Vanuatu', '瓦努阿图', 'VU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('232', 'Vatican City State (Holy See)', '梵蒂冈(罗马教廷)', 'VA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('233', 'Venezuela', '委内瑞拉', 'VE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('234', 'Vietnam', '越南', 'VN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('235', 'Virgin Islands (British)', '维尔京群岛(英国)', 'VG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('236', 'Virgin Islands (U.S.)', '维尔京群岛(美国)', 'VI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('237', 'Wallis And Futuna Islands', '沃利斯和富图纳群岛', 'WF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('238', 'Western Sahara', '西撒哈拉', 'EH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('239', 'Yemen', '也门', 'YE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('24', 'Bermuda', '百慕大', 'BM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('240', 'Yugoslavia', '南斯拉夫', 'YU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('241', 'Zambia', '赞比亚', 'ZM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('242', 'Zimbabwe', '津巴布韦', 'ZW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('25', 'Bhutan', '不丹', 'BT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('26', 'Bolivia', '玻利维亚', 'BO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('27', 'Bosnia and Herzegovina', '波斯尼亚和黑塞哥维那', 'BA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('28', 'Botswana', '博茨瓦纳', 'BW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('29', 'Bouvet Island', '布维岛', 'BV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('3', 'Algeria', '阿尔及利亚', 'DZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('30', 'Brazil', '巴西', 'BR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('31', 'British Indian Ocean Territory', '英属印度洋领地', 'IO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('32', 'Brunei Darussalam', '文莱达鲁萨兰国', 'BN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('33', 'Bulgaria', '保加利亚', 'BG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('34', 'Burkina Faso', '布基纳法索', 'BF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('35', 'Burundi', '布隆迪', 'BI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('36', 'Cambodia', '柬埔寨', 'KH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('37', 'Cameroon', '喀麦隆', 'CM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('38', 'Canada', '加拿大', 'CA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('39', 'Cape Verde', '佛得角', 'CV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('4', 'American Samoa', '萨摩亚', 'AS', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('40', 'Cayman Islands', '开曼群岛', 'KY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('41', 'Central African Republic', '中非共和国', 'CF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('42', 'Chad', '乍得', 'TD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('43', 'Chile', '智利', 'CL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('44', 'China', '中国', 'CN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('45', 'Christmas Island', '圣延岛', 'CX', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('46', 'Cocos (Keeling) Islands', '科科斯群岛', 'CC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('47', 'Colombia', '哥伦比亚', 'CO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('48', 'Comoros', '科摩罗', 'KM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('49', 'Congo', '刚果', 'CG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('5', 'Andorra', '安道尔共和国', 'AD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('50', 'Congo, The Democratic Republic Of The', '刚果民主共和国', 'ZR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('51', 'Cook Islands', '库克群岛', 'CK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('52', 'Costa Rica', '哥斯达黎加', 'CR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('53', 'Cote D\'Ivoire', 'Cote D\'Ivoire', 'CI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('54', 'Croatia (local name: Hrvatska)', '克罗地亚', 'HR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('55', 'Cuba', '古巴', 'CU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('56', 'Cyprus', '塞浦路斯', 'CY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('57', 'Czech Republic', '捷克', 'CZ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('58', 'Denmark', '丹麦', 'DK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('59', 'Djibouti', '吉布提', 'DJ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('6', 'Angola', '安哥拉', 'AO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('60', 'Dominica', '多米尼克国', 'DM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('61', 'Dominican Republic', '多米尼加共和国', 'DO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('62', 'East Timor', '东帝汶', 'TP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('63', 'Ecuador', '厄瓜多尔', 'EC', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('64', 'Egypt', '埃及', 'EG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('65', 'El Salvador', '萨尔瓦多', 'SV', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('66', 'Equatorial Guinea', '赤道几内亚', 'GQ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('67', 'Eritrea', '厄立特里亚国', 'ER', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('68', 'Estonia', '爱沙尼亚', 'EE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('69', 'Ethiopia', '埃塞俄比亚', 'ET', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('7', 'Anguilla', '安圭拉', 'AI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('70', 'Falkland Islands (Malvinas)', '福克兰群岛', 'FK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('71', 'Faroe Islands', '法罗群岛', 'FO', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('72', 'Fiji', '斐济', 'FJ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('73', 'Finland', '芬兰', 'FI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('74', 'France', '法国', 'FR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('75', 'France Metropolitan', '法国大都会', 'FX', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('76', 'French Guiana', '法属圭亚那', 'GF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('77', 'French Polynesia', '法属玻里尼西亚', 'PF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('78', 'French Southern Territories', 'French Southern Territories', 'TF', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('79', 'Gabon', '加蓬', 'GA', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('8', 'Antarctica', '南极洲', 'AQ', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('80', 'Gambia', ' 冈比亚', 'GM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('81', 'Georgia', '格鲁吉亚', 'GE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('82', 'Germany', '德国', 'DE', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('83', 'Ghana', '加纳', 'GH', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('84', 'Gibraltar', '直布罗陀', 'GI', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('85', 'Greece', '希腊', 'GR', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('86', 'Greenland', '格陵兰', 'GL', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('87', 'Grenada', '格林纳达', 'GD', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('88', 'Guadeloupe', '瓜德罗普岛', 'GP', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('89', 'Guam', '关岛', 'GU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('9', 'Antigua and Barbuda', '安提瓜和巴布达', 'AG', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('90', 'Guatemala', '危地马拉', 'GT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('91', 'Guinea', '几内亚', 'GN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('92', 'Guinea-Bissau', '几内亚比绍', 'GW', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('93', 'Guyana', '圭亚那', 'GY', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('94', 'Haiti', '海地', 'HT', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('95', 'Heard and Mc Donald Islands', 'Heard and Mc Donald Islands', 'HM', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('96', 'Honduras', '洪都拉斯', 'HN', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('97', 'Hong Kong', '香港', 'HK', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('98', 'Hungary', '匈牙利', 'HU', null, null, null, null, null, '0');
INSERT INTO `sys_country` VALUES ('99', 'Iceland', '冰岛', 'IS', null, null, null, null, null, '0');
