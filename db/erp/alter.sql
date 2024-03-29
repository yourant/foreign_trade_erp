ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `unit`;

ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_car_parts` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `aname`;

ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_car_type` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `type`;

ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_customer` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `parts`;

ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_docker` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `aname`;

ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_engine_type` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `price`;

ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_express` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `status`;

ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_parts_order` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `scale`;

ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_pay_money` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `sum_price`;

ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_pay_type` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `id_car_parts`;

ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_po_cp` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `count`;

ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_production_items` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `order_time`;

ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_production_order` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `status`;

ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_repair_order` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `status`;

ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_sales_order` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `type`;

ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_send_items` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `status`;

ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_shipments` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `productor`;

ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;

ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;

ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;

ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;

ALTER TABLE `erp`.`erp_vin` 
ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;
