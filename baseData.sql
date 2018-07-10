drop table dzptemp.tmp_20180703_xx_01;
drop table dzptemp.tmp_20180703_xx_02;
drop table dzptemp.tmp_20180703_xx_03;
drop table dzptemp.tmp_20180703_xx_04;
drop table dzptemp.tmp_20180703_xx_05;
drop table dzptemp.tmp_20180703_xx_06;
drop table dzptemp.tmp_20180703_xx_07;
drop table dzptemp.tmp_20180703_xx_08;
drop table dzptemp.tmp_20180703_xx_09;
drop table dzptemp.tmp_20180703_xx_10;
drop table dzptemp.tmp_20180703_xx_11;
drop table dzptemp.tmp_20180703_xx_12;

--西咸用户
create table dzptemp.tmp_20180703_xx_01 as 
select distinct a.user_id
      ,a.serial_number
      ,a.product_id
      ,b.product_name
      ,case when a.product_id in ('96011941','96011942','96011945','96011943','96011944','99110153','99110154','99110155'
                                 ,'96012046','96009989','96017192','96017193','96017194','96017284','96017285','96017286'
                                 ,'96017287','96017288','96017289','96017189','96017190','96017191'
                                 ,'96017165','96017166','96017167')
            then '不限量产品(不含预约)' 
            when a.product_id in ('99110156','99428003','99084001','10284001','99086061','99086102','99086081','99086101','99086161'
                                 ,'99086121','10522001','99220035','10230014','99999999','99110073','10082003','10082004','10082005'
                                 ,'10082006','10225039','99620003','99160003','10101001','99110151','99220056','99220055','99220053'
                                 ,'10106001','10085001','99225001','10283003','99086001','99085007','99220019','10082001','10082002'
                                 ,'99999310','99081001','10225002','10224005','10082008','99160001','99480002','29184028','29184148'
                                 ,'99250001','99250002','29083673','13283004','29183021','13283003','19105003','19081001','11081001'
                                 ,'13081001','14081001','17081001','15081001','29281500','99428001','12081001','16081001','10081001'
                                 ,'14085001','14282005','19282002','19225002','29282669','29282080','29282575','11082007','13282006'
                                 ,'12282008','14282001','14282004','16282008','16282003','16282002','16282009','16282007','11082002'
                                 ,'16282005','13282003','29282553','13282002','11082003','29270001','19225003','12282003','29282570'
                                 ,'29282582','17082001','29282581','13282001','29282001','13282004','19282001','12282002','15282007'
                                 ,'16282006','16282001','16282011','99086021','99999313','29225037','99086041','99110119','99110111'
                                 ,'99160002','99083100','99083102','99083101','99086181','99086141','99530015','99530016','99530017'
                                 ,'99530018','99530033','99530034','99530035','99530036','99530038')
            then '不可营销产品(不含预约)' 
            else '其他' end as type_name
from  dwmid.tm_user_info_day a 
left join dwstr.td_b_product b on a.product_id = b.product_id
where a.stat_date = '20180702'
  and a.city_code in ('A0FD','A0FX','A0JH','A0KG','A0QH','D0FD','D0FX','D0JH','D0KG','D0QH')
  and a.remove_tag = '0' 
  and a.arrive_user_flag = 1
;


--小号副卡
create table dzptemp.tmp_20180703_xx_02 as
select distinct user_id
      ,'小号/副卡' as type_name
from dwstr.tf_f_user_discnt
where discnt_code in ('96000458','99425004','96010038','96009920','10452006','99120002','99120003','99752012','99120005'
                     ,'99425019','96013401','99120004','10752004','99752013','10452010','99144001','10752002','96010037'
                     ,'10452004','96009918','99752008','10452016','10452008','10452002','99225002','10452014'
)
  and relation_end_date >= '20180701'
  and user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
union 
select distinct user_id_b 
      ,'小号/副卡' as type_name
from dwstr.tf_f_relation_uu
where relation_type_code = 'GY' and role_code_b = '2'
  and rsrv_str3 in ('1','2','6','7')
  and relation_end_date > '20180701'
  and user_id_b in (select user_id from dzptemp.tmp_20180703_xx_01)
;


--剔除优惠
create table dzptemp.tmp_20180703_xx_03 as
select distinct a.user_id 
      ,a.discnt_code
      ,b.discnt_name
      ,case when a.discnt_code in ('96017726','96012021','96017531','96017370','96017371','96017372','96013474','96013475','96013476')
            then '不限量优惠(含预约)'
            else '必剔优惠(含预约)'
            end  as type_name
from dwstr.tf_f_user_discnt a
left join dwstr.td_b_discnt b on a.discnt_code = b.discnt_code
where a.discnt_code in ('99418213','99418203','99418198','99418204','99418199','99418205','99418200','99418208','99418209'
                     ,'99418202','99418197','99418153','99418154','99418157','99418158','99418159','99418160','99418161'
                     ,'99418162','99418142','99418201','99418174','99418175','99418176','96000458','99140128','99140129'
                     ,'96004862','96000228','99418210','99418152','99412145','99412146','99412147','99412148','99412186'
                     ,'99425067','99425068','99425069','99425070','99425103','99425104','99425105','99425107','99425109'
                     ,'99452502','99418141','99418143','99418147','99418148','99418149','99418150','99418163','99418164'
                     ,'99425018','99425019','99418212','99453392','99140119','99140120','99410199','99410200','99410203'
                     ,'99410204','99418183','99418195','99418211','99418214','96011949','96011950','96011952','96012045'
                     ,'96012057','96012058','96012059','96012060','88720015','96009985','96009986','96016607','96000475'
                     ,'96012021','96017368','96017369','96017370','96017371','96017372','96017165','96017166','96017167'
                     ,'99752009','99752010','99752011','99752012','99752013','99752014'

                     ,'96017726','96012021','96017531','96017370','96017371','96017372','96013474','96013475','96013476'
)
  and a.relation_end_date >= '20180701'
  and a.user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
;


--剔除营销包
create table dzptemp.tmp_20180703_xx_04 as
select distinct a.user_id 
      ,a.package_id
      ,b.package_name
      ,'必剔营销包(含预约)' as type_name
from dwstr.tf_f_user_sale_active a
left join dwstr.td_b_package b on a.package_id = b.package_id
where a.package_id in ('96000463','69969143','69969144','69969141','69969142','96009385','69966788','69966789'
                    ,'61068675','61068676','69966785','69966786','69966781','69966787','61062550','96010742'
                    ,'69967865','61044124','61061576','61061577','61061578','69967982','69967922','96009978'
                    ,'96000563','69969170','69969169','69969168','96009966','96010729','96010730','96010731'
                    ,'96000171','96010118','69969167','69969166','96010119','69969165','69969163','69969164'
                    ,'69967923','69967924','69967925','69967926'
)
  and a.end_date >= '20180701'
  and a.user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
; 



--预约不可营销产品用户
create table dzptemp.tmp_20180703_xx_05 as
select distinct b.user_id
      ,c.product_id
      ,d.product_name
      ,case when c.product_id in ('96011941','96011942','96011945','96011943','96011944','99110153','99110154','99110155'
                                 ,'96012046','96009989','96017192','96017193','96017194','96017284','96017285','96017286'
                                 ,'96017287','96017288','96017289','96017189','96017190','96017191'
                                 ,'96017165','96017166','96017167')
            then '不限量产品-预约'
            else '不可营销产品-预约'
            end as type_name
from dwstr.tf_bh_trade b
    ,dwstr.tf_b_trade_product c
left join dwstr.td_b_product d on c.product_id = d.product_id
where b.user_id = c.user_id
  and b.trade_id = c.trade_id
  and b.accept_date between '20180701' and '20180731'
  and b.cancel_tag = '0'
  and c.modify_tag <> '1'
  and b.trade_type_code = '110'
  and b.user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
  and c.product_id in ('99110156','99428003','99084001','10284001','99086061','99086102','99086081','99086101','99086161'
                      ,'99086121','10522001','99220035','10230014','99999999','99110073','10082003','10082004','10082005'
                      ,'10082006','10225039','99620003','99160003','10101001','99110151','99220056','99220055','99220053'
                      ,'10106001','10085001','99225001','10283003','99086001','99085007','99220019','10082001','10082002'
                      ,'99999310','99081001','10225002','10224005','10082008','99160001','99480002','29184028','29184148'
                      ,'99250001','99250002','29083673','13283004','29183021','13283003','19105003','19081001','11081001'
                      ,'13081001','14081001','17081001','15081001','29281500','99428001','12081001','16081001','10081001'
                      ,'14085001','14282005','19282002','19225002','29282669','29282080','29282575','11082007','13282006'
                      ,'12282008','14282001','14282004','16282008','16282003','16282002','16282009','16282007','11082002'
                      ,'16282005','13282003','29282553','13282002','11082003','29270001','19225003','12282003','29282570'
                      ,'29282582','17082001','29282581','13282001','29282001','13282004','19282001','12282002','15282007'
                      ,'16282006','16282001','16282011','99086021','99999313','29225037','99086041','99110119','99110111'
                      ,'99160002','99083100','99083102','99083101','99086181','99086141','99530015','99530016','99530017'
                      ,'99530018','99530033','99530034','99530035','99530036','99530038'
                      ,'96011941','96011942','96011945','96011943','96011944','99110153','99110154','99110155'
                      ,'96012046','96009989','96017192','96017193','96017194','96017284','96017285','96017286'
                      ,'96017287','96017288','96017289','96017189','96017190','96017191'
                      ,'96017165','96017166','96017167')
;






--已办理
create table dzptemp.tmp_20180703_xx_06 as
select a.user_id
      ,a.trade_id
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,b.serial_number
      ,b.new_city_code
      ,b.tag
from  dwstr.tf_bh_trade a
     ,dzptemp.tmp_20180625_target_list b
where a.user_id = b.user_id
  and a.cancel_tag = '0'
;  

create table dzptemp.tmp_20180703_xx_07 as
select a.user_id
      ,b.package_id
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,a.tag
      ,a.serial_number
      ,a.new_city_code
from  dzptemp.tmp_20180703_xx_06 a
     ,dwstr.tf_b_trade_sale_active b
where a.user_id = b.user_id
  and a.trade_id = b.trade_id
  and b.modify_tag <> '1'
  and b.package_id in ('96016896','96016897','96016898','96016899')
  and a.tag = '3'
union
select a.user_id
      ,b.package_id
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,a.tag
      ,a.serial_number
      ,a.new_city_code
from  dzptemp.tmp_20180703_xx_06 a
     ,dwstr.tf_b_trade_sale_active b
where a.user_id = b.user_id
  and a.trade_id = b.trade_id
  and b.modify_tag <> '1'
  and b.package_id in ('96016971','96016972')
  and a.tag = '2'
union
select a.user_id
      ,b.product_id
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,a.tag
      ,a.serial_number
      ,a.new_city_code
from dzptemp.tmp_20180703_xx_06 a
    ,dwstr.tf_b_trade_product b
where a.user_id = b.user_id 
  and a.trade_id = b.trade_id
  and b.modify_tag <> '1'
  and b.product_id in ('96017192','96017193','96017194'
                      ,'96011941','96011942','96011943','96011944','96011945'
                      ,'96017189','96017190','96017191'
                      ,'96017165','96017166','96017167')
  and a.tag in ('1','4','5')
union
select a.user_id
      ,b.discnt_code
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,a.tag
      ,a.serial_number
      ,a.new_city_code
from dzptemp.tmp_20180703_xx_06 a
    ,dwstr.tf_b_trade_discnt b
where a.user_id = b.user_id 
  and a.trade_id = b.trade_id
  and b.modify_tag <> '1'
  and b.discnt_code in ('96017726','96012021','96017531'
                       ,'96017370','96017371','96017372'
                       ,'96013474','96013475','96013476')
  and a.tag in ('1','4','5')
;  


--已办理
create table dzptemp.tmp_20180703_xx_08 as
select distinct a.user_id
      ,a.serial_number
      ,a.tag
      ,case when a.tag = 1 then '不限量营销-已办理'
            when a.tag = 2 then '产品升舱-已办理'
            when a.tag = 3 then '流量升舱-已办理'
            when a.tag = 4 then '双降80元以上-已办理'
            when a.tag = 5 then '双降80元以下-已办理'
            else '其他' end as type_name 
      ,a.package_id
      ,a.accept_date
      ,a.accept_staff_id
      ,a.accept_depart_id
      ,nvl(nvl(b.chnl_name,c.chnl_name),'其他') as chnl_name
      ,nvl(c.city_code,'其他') as city_code
      ,nvl(b.city_code,d.city_name) as city_name
      ,case when nvl(b.city_code,d.city_name) = '西咸泾河' then '西咸泾河'
            when nvl(b.city_code,d.city_name) = '西咸秦汉' then '西咸秦汉' 
            when nvl(b.city_code,d.city_name) = '外呼'   then '外呼'  
            when nvl(b.city_code,d.city_name) = '西咸沣东' then '西咸沣东'
            when nvl(b.city_code,d.city_name) = '西咸沣西' then '西咸沣西' 
            else '其他' end as city_class
from dzptemp.tmp_20180703_xx_07 a
left join dzptemp.tmp_20180625_target_list_01 b on a.accept_depart_id = b.chnl_id
left join dwstr.tf_chl_channel c on a.accept_depart_id = c.chnl_id
left join dwpub.td_citycode_new d on c.city_code = d.city_code
;



--办理模组
create table dzptemp.tmp_20180703_xx_09 as
select user_id
      ,max(case when rn = 1 then a.discnt_code else '' end) as discnt_01
      ,max(case when rn = 1 then b.discnt_name else '' end) as discnt_name_01
      ,max(case when rn = 2 then a.discnt_code else '' end) as discnt_02
      ,max(case when rn = 2 then b.discnt_name else '' end) as discnt_name_02
      ,max(case when rn = 3 then a.discnt_code else '' end) as discnt_03
      ,max(case when rn = 3 then b.discnt_name else '' end) as discnt_name_03
from (
      select distinct user_id 
            ,discnt_code
            ,row_number() over(partition by user_id order by discnt_code) as rn
      from dwstr.tf_f_user_discnt
      where discnt_code in ('96017364','96017365','96017366','96017367','96017368','96017369','96017370','96017371','96017372'
                           ,'96004857','96004858','96000473','96000474','96000475','96000476','96000477','96000478','96000479'
                           ,'96012021','96016890','96016891','96016892','96016893','99720478','99720492','99720473','99720479'
                           ,'99720467','99412022','99720470','99720468','99720469','99418035','99418010','99418011','99418012'
                           ,'99418013','99418014','99418036','99418096','99418097','99418098','99418050','99418051','99418052'
                           ,'99418053','99418054','99418055','99418056','99418057','99412084','99412085','99412089','99412090'
                           ,'99412091','99412092','99412093','99412094','10412002','10412003'
                            )
        and relation_end_date >= '20180701'
        and user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
     ) a
left join dwstr.td_b_discnt b on a.discnt_code = b.discnt_code
group by 1
;


--集团用户
create table dzptemp.tmp_20180703_xx_10 as
select distinct user_id
      ,group_id
      ,group_cust_name
from dzpmid.tp_group_member_arrive_mon 
where user_id in (select user_id from dzptemp.tmp_20180703_xx_01)
  and acyc_id = 201805
;

--有往欠用户
create table dzptemp.tmp_20180703_xx_11 as
select a.user_id
      ,nvl(sum(b.balance*0.01),0) one_his
from dzptemp.tmp_20180703_xx_01 a
left join dwstr.ts_a_debbill b on a.user_id = b.user_id and b.acyc_id = 201806
group by 1
;



create table dzptemp.tmp_20180703_xx_12 as 
select distinct a.user_id
      ,a.serial_number
      ,t.recm_name
      ,t.type_code
      ,a.product_id
      ,a.product_name
      ,nvl(b1.type_name,'')  as second_card
      ,nvl(nvl(b2.type_name,nvl(b3.type_name,nvl(b4.type_name,b5.type_name))),'0') as type_name
      ,cast(c1.arpu_03 as int)  as arpu_1
      ,cast(c1.arpu_04 as int)  as arpu_2
      ,cast(c1.arpu_05 as int)  as arpu_3
      ,cast(c2.gprs_03 as int)  as dou_01
      ,cast(c2.gprs_04 as int)  as dou_02
      ,cast(c2.gprs_05 as int)  as dou_03
      ,cast(c3.times_03 as int) as mou_01
      ,cast(c3.times_04 as int) as mou_02
      ,cast(c3.times_05 as int) as mou_03
      ,nvl(b8.one_his,0)      as owe_fee
      ,nvl(b7.group_id       ,'') as group_id
      ,nvl(b7.group_cust_name,'') as group_name
      ,nvl(b6.discnt_01      ,'') as mz_code_01
      ,nvl(b6.discnt_name_01 ,'') as mz_name_01
      ,nvl(b6.discnt_02      ,'') as mz_code_02
      ,nvl(b6.discnt_name_02 ,'') as mz_name_02
      ,nvl(b6.discnt_03      ,'') as mz_code_03
      ,nvl(b6.discnt_name_03 ,'') as mz_name_04
from dzptemp.tmp_20180622_user_list t
--不可营销产品
left join dzptemp.tmp_20180703_xx_01 a on t.user_id = a.serial_number
--小号副卡
left join dzptemp.tmp_20180703_xx_02 b1 on a.user_id = b1.user_id
--必剔优惠
left join (select distinct user_id,type_name from dzptemp.tmp_20180703_xx_03) b2 on a.user_id = b2.user_id
--必剔营销包
left join (select distinct user_id,type_name from dzptemp.tmp_20180703_xx_04) b3 on a.user_id = b3.user_id
--预约不可营销产品
left join (select distinct user_id,type_name from dzptemp.tmp_20180703_xx_05) b4 on a.user_id = b4.user_id
--已办理
left join (select distinct user_id,type_name from dzptemp.tmp_20180703_xx_08) b5 on a.user_id = b5.user_id
--集团
left join dzptemp.tmp_20180703_xx_09 b6 on a.user_id = b6.user_id
--办理模组
left join dzptemp.tmp_20180703_xx_10 b7 on a.user_id = b7.user_id
--往欠
left join dzptemp.tmp_20180703_xx_11 b8 on a.user_id = b8.user_id
left join dzptemp.tmp_20180622_user_list_06 c1 on a.user_id = c1.user_id
left join dzptemp.tmp_20180622_user_list_07 c2 on a.user_id = c2.user_id
left join dzptemp.tmp_20180622_user_list_08 c3 on a.user_id = c3.user_id
;

--type_name = '0' 代表为剔除后的目标清单
@export on;
@export set CsvColumnDelimiter = "|"
            Filename = "X:/01_target_user_afterdeal.txt"
            CsvColumnHeaderIsColumnAlias = "true" ;
      select * 
      from dzptemp.tmp_20180703_xx_12
      order by type_code
      ;      
@export off;

--已办理
@export on;
@export set CsvColumnDelimiter = "|"
            Filename = "X:/02_successful_user.txt"
            CsvColumnHeaderIsColumnAlias = "true" ;
      select * 
      from dzptemp.tmp_20180703_xx_08
      order by type_name
      ;      
@export off;






/**
--产品
@export on;
@export set CsvColumnDelimiter = "|"
            Filename = "X:/xx_llfb_02_product.txt"
            CsvColumnHeaderIsColumnAlias = "true" ;
      select * 
      from dzptemp.tmp_20180703_xx_01
      where type_name <> '其他'
      union 
      select * 
      from dzptemp.tmp_20180703_xx_05
      ;      
@export off;


--优惠
@export on;
@export set CsvColumnDelimiter = "|"
            Filename = "X:/xx_llfb_04_discnt.txt"
            CsvColumnHeaderIsColumnAlias = "true" ;
      select *
      from dzptemp.tmp_20180703_xx_03
      ;      
@export off;
--营销包
@export on;
@export set CsvColumnDelimiter = "|"
            Filename = "X:/xx_llfb_05_package.txt"
            CsvColumnHeaderIsColumnAlias = "true" ;
      select *
      from dzptemp.tmp_20180703_xx_04
      ;      
@export off;

**/

