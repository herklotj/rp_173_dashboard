 view: 173_quotes {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql:SELECT cov.quote_id,
       to_date(cov.quote_dttm) AS quote_date,
       cov.quote_dttm,
       CASE
         WHEN timestampdiff (YEAR,drv.birth_dt,cov.cover_start_dt) < 25 AND timestampdiff (YEAR,drv.birth_dt,cov.cover_start_dt) > 20 AND drv.ncb_years > 0 THEN 'Acceptable'
         ELSE 'Invalid'
       END AS AGE_NCD_Acceptable,
       cov.consumer_name,
       cov.originator_name,
       cov.rct_noquote_an AS quotes,
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
       cov.quotedpremium_an_notinclipt,
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
       CASE
         WHEN rct_mi_16 >= 0 AND rct_mi_16 < 0.005 THEN '0-0.005'
         WHEN rct_mi_16 >= 0.005 AND rct_mi_16 < 0.010 THEN '0.005-0.010'
         WHEN rct_mi_16 >= 0.010 AND rct_mi_16 < 0.015 THEN '0.010-0.015'
         WHEN rct_mi_16 >= 0.015 AND rct_mi_16 < 0.020 THEN '0.015-0.020'
         WHEN rct_mi_16 >= 0.020 AND rct_mi_16 < 0.025 THEN '0.020-0.025'
         WHEN rct_mi_16 >= 0.025 AND rct_mi_16 < 0.030 THEN '0.025-0.030'
         WHEN rct_mi_16 >= 0.030 AND rct_mi_16 < 0.035 THEN '0.030-0.035'
         WHEN rct_mi_16 >= 0.035 AND rct_mi_16 < 0.040 THEN '0.035-0.040'
         WHEN rct_mi_16 >= 0.040 AND rct_mi_16 < 0.045 THEN '0.040-0.045'
         WHEN rct_mi_16 >= 0.045 AND rct_mi_16 < 0.050 THEN '0.045-0.050'
         WHEN rct_mi_16 >= 0.050 AND rct_mi_16 < 0.055 THEN '0.050-0.055'
         WHEN rct_mi_16 >= 0.050 THEN '0.050+'
       END AS tp_freq_br,
       rct_mi_15 AS risk_attitude,
       rct_mi_13 AS scheme_number,
       drv.ncb_years,
       veh.vehicle_make,
       manufacturer,
       power_bhp,
       mod.model,
       engine_size,
       geo.postcode_area,
       drv.gender,
       CASE
         WHEN ins.Insight_Match_type IS NULL THEN 'Never Member'
         ELSE ins.Insight_Match_type
       END AS Insight_Match_type,
       CASE
         WHEN sal.insurer_quote_ref IS NULL THEN 0
         ELSE 1
       END AS sale_flag
FROM qs_cover cov
  INNER JOIN qs_mi_outputs mi
          ON cov.quote_id = mi.quote_id
         AND mi.rct_mi_13 = '173'
         AND to_date (SYSDATE) - to_date (cov.quote_dttm) <= 30
  INNER JOIN qs_radar_return rad
          ON cov.quote_id = rad.quote_id
         AND to_date (SYSDATE) - to_date (rad.quote_dttm) <= 30
  INNER JOIN qs_drivers drv
          ON cov.quote_id = drv.quote_id
         AND to_date (SYSDATE) - to_date (drv.quote_dttm) <= 30
         AND drv.driver_id = '0'
  INNER JOIN qs_vehicles veh ON cov.quote_id = veh.quote_id
             AND to_date(SYSDATE) - to_date(veh.quote_dttm) <= 30
  LEFT JOIN vl_vehicle_data vl ON veh.abi_code = vl.abi_code
  LEFT JOIN v_model_abi_code mod ON vl.abi_code = mod.abi_code
  LEFT JOIN postcode_geography geo ON UPPER (replace (cov.risk_postcode,' ','')) = UPPER (geo.postcode)
  LEFT JOIN (SELECT *,
                    CASE
                      WHEN live_member = 'Y' AND aa_score_22sep2015 < 1.1 THEN 'Member'
                      WHEN live_member = 'N' AND aa_score_22sep2015 < 1.1 AND aa_score_22sep2015 > 0 AND tenure_current > 0 THEN 'Ex-Member'
                      WHEN Live_member = 'N' AND (HOME_HISTORY = 'C' OR HOME_HISTORY = 'X') /*and aa_score_22sep2015 < 1.1*/  THEN 'Home'
                      ELSE 'Unacceptable'
                    END AS acceptance,
                    CASE
                      WHEN live_member = 'Y' THEN 'Member'
                      WHEN live_member = 'N' AND aa_score_22sep2015 > 0 AND tenure_current > 0 THEN 'Ex-Member'
                      WHEN Live_member = 'N' AND (HOME_HISTORY = 'C' OR HOME_HISTORY = 'X') THEN 'Home'
                      ELSE 'No Match'
                    END AS Insight_Match_type,
                    1 AS current_match
             FROM insight) ins
         ON LEFT (ins.qas_premise_id,8) = cov.qqas1_address_key1
        AND UPPER (squeeze (concat (LEFT (replace (replace (replace (drv.surname,' ',''),'''',''),'-',''),5),'_',LEFT (replace (drv.forename,' ',''),1)))) = ins.ck_suffix
        AND ins.Insight_match_type <> 'No Match'
  LEFT JOIN hourly_sales sal ON cov.quote_id = LEFT (sal.insurer_quote_ref,36)




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
    sql: CASE WHEN ${TABLE}.originator_name != ' ' THEN ${TABLE}.originator_name ELSE ${TABLE}.consumer_name END ;;
  }
  dimension: agg_would_accept {
    type: number
    sql: ${TABLE}.agg_would_accept ;;
  }
  dimension: acceptable_quotes {
      type: number
      sql: ${TABLE}.quotes ;;
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
  dimension: quoted_date {
    type: date
    sql: ${TABLE}.quote_date ;;
  }
   dimension_group: quote_date {
     type: time
     timeframes: [date, week, month, year]
     sql: ${TABLE}.quote_dttm ;;
   }
  dimension: risk_attitude {
    type: string
    sql: ${TABLE}.risk_attitude_banded;;}

  dimension: tp_freq_br {
    type: string
    sql: ${TABLE}.tp_freq_br;;}

  dimension: driver_gender {
    type: string
    sql: gender ;;
  }

  dimension: member_match {
    type: string
    sql: Insight_Match_type;;
  }

  dimension: sale_flag {
    type: number
    sql: ${TABLE}.sale_flag;;
  }

  dimension: scheme_number {
    type: string
    sql: ${TABLE}.scheme_number ;;
  }

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
    value_format_name: gbp
  }
  measure: av_risk_attitude {
    type: average
    sql: ${TABLE}.risk_attitude ;;
  }

  measure: sales_predicted {
    type: sum
    sql: ${TABLE}.agg_would_accept * 0.018 ;;
  }

  measure: sales {
    type:  sum
    sql: ${TABLE}.sale_flag ;;
  }

  measure: conversion {
    type:  number
  sql: 1.0*(SUM(${TABLE}.sale_flag))/(COUNT(DISTINCT ${TABLE}.quote_id));;
    value_format_name: percent_2
  }

 }
