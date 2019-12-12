 view: 173_quotes {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql:SELECT cov.quote_id,
       to_date(cov.quote_dttm) AS quote_date,
       CASE
         WHEN timestampdiff (YEAR,drv.birth_dt,cov.cover_start_dt) < 25 AND timestampdiff (YEAR,drv.birth_dt,cov.cover_start_dt) > 20 AND drv.ncb_years > 0 THEN 'Acceptable'
         ELSE 'Invalid'
       END AS AGE_NCD_Acceptable,
       cov.consumer_name,
       cov.originator_name,
       CASE
         WHEN rad.rct_br047_strategic = 1 AND cov.radar_no_bus_rules_failed = 1 THEN 1
         ELSE 0
       END AS agg_would_accept,
       CASE
         WHEN rad.rct_br047_strategic = 1 AND rad.rct_br011_ncdpdeclined = 1 AND cov.radar_no_bus_rules_failed = 1 THEN 1
         ELSE 0
       END AS agg_would_accept_np,
       cov.radar_no_bus_rules_failed,
       TIMESTAMPDIFF(YEAR,drv.birth_dt,cov.cover_start_dt) AS driver_age,
       drv.driver_id,
       cov.quotedpremium_in_notinclipt,
       CASE
         WHEN rct_mi_15 >= 0 AND rct_mi_15 < 0.05 THEN '0-0.05'
         WHEN rct_mi_15 >= 0.05 AND rct_mi_15 < 0.1 THEN '0.05-0.1'
         WHEN rct_mi_15 >= 0.1 AND rct_mi_15 < 0.15 THEN '0.1-0.15'
         WHEN rct_mi_15 >= 0.15 AND rct_mi_15 < 0.2 THEN '0.15-0.2'
         WHEN rct_mi_15 >= 0.2 AND rct_mi_15 < 0.25 THEN '0.2-0.25'
         WHEN rct_mi_15 >= 0.25 AND rct_mi_15 < 0.3 THEN '0.25-0.3'
         WHEN rct_mi_15 >= 0.3 AND rct_mi_15 < 0.35 THEN '0.3-0.35'
         WHEN rct_mi_15 >= 0.35 AND rct_mi_15 < 0.4 THEN '0.35-0.4'
         WHEN rct_mi_15 >= 0.4 AND rct_mi_15 < 0.45 THEN '0.4-0.45'
         WHEN rct_mi_15 >= 0.45 AND rct_mi_15 < 0.5 THEN '0.45-0.5'
         WHEN rct_mi_15 >= 0.5 AND rct_mi_15 < 0.55 THEN '0.5-0.55'
         WHEN rct_mi_15 >= 0.55 AND rct_mi_15 < 0.6 THEN '0.55-0.6'
         WHEN rct_mi_15 >= 0.6 AND rct_mi_15 < 0.65 THEN '0.6-0.65'
         WHEN rct_mi_15 >= 0.65 AND rct_mi_15 < 0.7 THEN '0.65-0.7'
         WHEN rct_mi_15 >= 0.7 AND rct_mi_15 < 0.75 THEN '0.7-0.75'
         WHEN rct_mi_15 >= 0.75 AND rct_mi_15 < 0.8 THEN '0.75-0.8'
         WHEN rct_mi_15 >= 0.8 AND rct_mi_15 < 0.85 THEN '0.8-0.85'
         WHEN rct_mi_15 >= 0.85 AND rct_mi_15 < 0.9 THEN '0.85-0.9'
         WHEN rct_mi_15 >= 0.9 AND rct_mi_15 < 0.95 THEN '0.9-0.95'
         WHEN rct_mi_15 >= 0.95 AND rct_mi_15 <= 1 THEN '0.95-1'
         ELSE '-1'
       END AS risk_attitude_banded,
       rct_mi_15 AS risk_attitude,
       drv.ncb_years,
       veh.vehicle_make,
       manufacturer,
       power_bhp,
       mod.model,
       engine_size,
       geo.postcode_area
FROM qs_cover cov
  LEFT JOIN qs_mi_outputs mi ON cov.quote_id = mi.quote_id
  LEFT JOIN qs_radar_return rad ON cov.quote_id = rad.quote_id
  LEFT JOIN qs_drivers drv
         ON cov.quote_id = drv.quote_id
        AND drv.driver_id = '0'
  LEFT JOIN qs_vehicles veh ON cov.quote_id = veh.quote_id
  LEFT JOIN vl_vehicle_data vl ON veh.abi_code = vl.abi_code
  LEFT JOIN v_model_abi_code mod ON vl.abi_code = mod.abi_code
  LEFT JOIN postcode_geography geo ON UPPER(replace(cov.risk_postcode, ' ','')) = UPPER(geo.postcode)
WHERE rct_mi_13 = '173'
;;
   }

   # Define your dimensions and measures here, like this:
   dimension: age_NCD_accpetable {
     type: string
     sql: ${TABLE}.AGE_NCD_Acceptable ;;
   }
  dimension: consumer_name {
    type: string
    sql: ${TABLE}.consumer_name ;;
  }
  dimension: originator_name {
    type: string
    sql: ${TABLE}.originator_name ;;
  }
  dimension: agg_would_accept {
    type: number
    sql: ${TABLE}.agg_would_accept ;;
  }
  dimension: no_business_rules_failed{
    type: number
    sql: ${TABLE}.radar_no_bus_rules_failed ;;
  }
  dimension: agg_would_accept_np {
    type: number
    sql: ${TABLE}.agg_would_accept_np ;;
  }
  dimension: engine_size {
    type: string
    sql: ${TABLE}.engine_size ;;
  }
  dimension: postcode_area {
    type: string
    map_layer_name: uk_postcode_areas
    sql: ${TABLE}.postcode_area ;;
  }
  dimension: manufactuer {
    type: string
    drill_fields: [model]
    sql: ${TABLE}.manufacturer ;;
  }
  dimension: model {
    type: string
    drill_fields: [engine_size]
    sql: ${TABLE}.model ;;
  }
  dimension: power_bhp {
    type: tier
    style: interval
    tiers: [0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200]
    sql: ${TABLE}.power_bhp ;;
  }
  dimension: NCD {
    type: number
    sql: ${TABLE}.ncb_years ;;
  }
  dimension: driver_age {
    type: number
    sql: ${TABLE}.driver_age ;;
  }

  dimension: driver_id {
    type: number
    sql: ${TABLE}.driver_id ;;
  }
  dimension: quoted_premium {
    type: number
    sql: ${TABLE}.quotedpremium_in_notinclipt ;;
  }

   dimension_group: quote_date {
     type: time
     timeframes: [date, week, month, year]
     sql: ${TABLE}.quote_date ;;
   }
  dimension: risk_attitude {
    type: string
    sql: ${TABLE}.risk_attitude_banded;;}

   measure: quotes {
     type: count_distinct
     sql: ${TABLE}.quote_id ;;
   }
  measure: agg_acc_quotes {
    type: sum
    sql: ${TABLE}.agg_would_accept ;;
  }
  measure: av_quoted_premium {
    type: average
    sql: ${TABLE}.quotedpremium_in_notinclipt ;;
  }
  measure: av_risk_attitude {
    type: average
    sql: ${TABLE}.risk_attitude ;;
  }
 }
