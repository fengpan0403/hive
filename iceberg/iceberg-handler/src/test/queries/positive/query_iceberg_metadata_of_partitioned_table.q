-- SORT_QUERY_RESULTS

set hive.vectorized.execution.enabled = false;
set tez.mrreader.config.update.properties=hive.io.file.readcolumn.names,hive.io.file.readcolumn.ids;
set hive.query.results.cache.enabled=false;
set hive.fetch.task.conversion=none;
set hive.cbo.enable=true;

drop table if exists ice_meta_2;
drop table if exists ice_meta_3;

create external table ice_meta_2(a int) partitioned by (b string) stored by iceberg stored as orc;
insert into table ice_meta_2 values (1, 'one'), (2, 'one'), (3, 'one');
truncate table ice_meta_2;
insert into table ice_meta_2 values (4, 'two'), (5, 'two');
truncate table ice_meta_2;
insert into table ice_meta_2 values (6, 'three'), (7, 'three'), (8, 'three');
insert into table ice_meta_2 values (9, 'four');
select * from ice_meta_2;


create external table ice_meta_3(a int) partitioned by (b string, c string) stored as orc;
insert into table ice_meta_3 partition (b='one', c='Monday') values (1), (2), (3);
insert into table ice_meta_3 partition (b='two', c='Tuesday') values (4), (5);
insert into table ice_meta_3 partition (b='two', c='Friday') values (10), (11);
insert into table ice_meta_3 partition (b='three', c='Wednesday') values (6), (7), (8);
insert into table ice_meta_3 partition (b='four', c='Thursday') values (9);
insert into table ice_meta_3 partition (b='four', c='Saturday') values (12), (13), (14);
insert into table ice_meta_3 partition (b='four', c='Sunday') values (15);
alter table ice_meta_3 set tblproperties ('storage_handler'='org.apache.iceberg.mr.hive.HiveIcebergStorageHandler');
select * from ice_meta_3;


select `partition` from default.ice_meta_2.files;
select `partition` from default.ice_meta_3.files;
select `partition`.b from default.ice_meta_2.files;
select data_file.`partition` from default.ice_meta_3.entries;
select data_file.`partition` from default.ice_meta_2.entries;
select data_file.`partition`.c from default.ice_meta_3.entries;
select summary from default.ice_meta_3.snapshots;
select summary['changed-partition-count'] from default.ice_meta_2.snapshots;
select partition_spec_id, partition_summaries from default.ice_meta_2.manifests;
select partition_spec_id, partition_summaries[1].upper_bound from default.ice_meta_3.manifests;
select * from default.ice_meta_2.partitions;
select * from default.ice_meta_3.partitions;
select `partition` from default.ice_meta_2.partitions where `partition`.b='four';
select * from default.ice_meta_3.partitions where `partition`.b='two' and `partition`.c='Tuesday';
select partition_summaries from default.ice_meta_3.manifests where partition_summaries[1].upper_bound='Wednesday';


set hive.fetch.task.conversion=more;

select `partition` from default.ice_meta_2.files;
select `partition` from default.ice_meta_3.files;
select `partition`.b from default.ice_meta_2.files;
select data_file.`partition` from default.ice_meta_3.entries;
select data_file.`partition` from default.ice_meta_2.entries;
select data_file.`partition`.c from default.ice_meta_3.entries;
select summary from default.ice_meta_3.snapshots;
select summary['changed-partition-count'] from default.ice_meta_2.snapshots;
select partition_spec_id, partition_summaries from default.ice_meta_2.manifests;
select partition_spec_id, partition_summaries[1].upper_bound from default.ice_meta_3.manifests;
select * from default.ice_meta_2.partitions;
select * from default.ice_meta_3.partitions;
select `partition` from default.ice_meta_2.partitions where `partition`.b='four';
select * from default.ice_meta_3.partitions where `partition`.b='two' and `partition`.c='Tuesday';
select partition_summaries from default.ice_meta_3.manifests where partition_summaries[1].upper_bound='Wednesday';


drop table ice_meta_2;
drop table ice_meta_3;
