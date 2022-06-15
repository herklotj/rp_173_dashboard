 view: details_173 {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT drv.forename,
       drv.surname,
       drv.birth_dt,
       drv.ncb_years,
       occ.occupation,
       cov.risk_postcode,
       cov.consumer_name,
       cov.originator_name,
       cov.cover_start_dt,
       veh.vehicle_make,
       veh.vehicle_model,
       veh.vehicle_value_amount,
       veh.annual_mileage,
       veh.registration_number,
       veh.purchase_dt,
       vl.power_bhp,
       drv.no_claims,
       drv.no_convictions,
       drv.no_oth_vehicles_driven,
       drv.gender,
       TIMESTAMPDIFF(YEAR,drv.birth_dt,cov.cover_start_dt) AS driver_age,
       mi.rct_mi_15 AS risk_attitude,
       quotedpremium_an_notinclipt AS avg_quoted_premium,
       drv.quote_dttm AS quote_dttm,
       CASE
         WHEN sal.insurer_quote_ref IS NULL THEN 0
         ELSE 1
       END AS sale_flag,
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
       rct_mi_15 AS risk_attitude
FROM qs_drivers drv
  INNER JOIN  hourly_sales sal ON lower(drv.quote_id) = lower(LEFT (sal.insurer_quote_ref,36)) AND drv.driver_id = 0 AND drv.quote_dttm > '2022-06-01'
  INNER JOIN  qs_mi_outputs mi ON drv.quote_id = mi.quote_id
        AND   drv.driver_id = '0'
        AND   drv.quote_dttm > '2022-06-01'
  INNER JOIN  qs_vehicles veh ON drv.quote_id = veh.quote_id
  INNER JOIN  qs_cover cov ON drv.quote_id = cov.quote_id
        AND   cov.rct_noquote_an = 0 AND marginpricetest_indicator_desc = '37: Smart Mar16'
  INNER JOIN  abi_occupation occ ON drv.main_occupation = lpad(occ.abi_code,3,'0')
  INNER JOIN  vl_vehicle_data vl ON veh.abi_code = vl.abi_code

;;
   }

 dimension: forename {
   description: "PH's first name"
   type: string
   sql: ${TABLE}.forename ;;
 }

  dimension: surname {
    description: "PH's surname"
    type: string
    sql: ${TABLE}.surname ;;
  }

 dimension_group: birth_dt {
   description: "PH's birth date"
   type: time
   timeframes: [date, week, month, year]
   sql: ${TABLE}.birth_dt ;;
 }
  dimension_group: cover_start_date {
    description: "Cover Start Date"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.cover_start_dt ;;
  }
  dimension_group: quote {
    description: "Quote date"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.quote_dttm ;;
  }
  dimension: power_bhp {
    type: tier
    style: interval
    tiers: [0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200]
    sql: ${TABLE}.power_bhp ;;
  }
  dimension: ncd {
    description: "PH's NCD"
    type: number
    sql: ${TABLE}.ncb_years ;;
  }
  dimension: occupation {
    description: "PH's occupation"
    type: string
    sql: ${TABLE}.occupation ;;
  }
  dimension: postcode {
    description: "PH's postcode"
    type: string
    sql: ${TABLE}.risk_postcode ;;
  }
  dimension: vehicle_make {
    description: "Manufacturuer of vehicle"
    type: string
    sql: ${TABLE}.vehicle_make ;;
  }
  dimension: vehicle_model {
    description: "Model of vehicle"
    type: string
    sql: ${TABLE}.vehicle_model ;;
  }
  dimension: vehicle_value {
    description: "Value of vehicle"
    type: number
    sql: ${TABLE}.vehicle_value_amount ;;
  }
  dimension: mileage {
    description: "Annual mileage"
    type: number
    sql: ${TABLE}.annual_mileage ;;
  }
  dimension: registration_number {
    description: "Registration number of vehicle"
    type: string
    sql: ${TABLE}.registration_number ;;
  }
  dimension_group: purchase_date {
    description: "Vehicle purchase date"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.purchase_dt ;;
  }
  dimension: claims {
    description: "Number of claims for PH"
    type: number
    sql: ${TABLE}.no_claims ;;
  }
  dimension: convictions {
    description: "Number of convictions for PH"
    type: string
    sql: ${TABLE}.no_convictions ;;
  }
  dimension: risk_attitude {
    description: "Risk attitude factor"
    type: string
    sql: ${TABLE}.risk_attitude_banded ;;
  }

  dimension: sale_flag {
    description: "indicator of sale on quote"
    type: number
    sql: ${TABLE}.sale_flag ;;
  }

  dimension: driver_gender {
    type: string
    sql: gender ;;
  }

  dimension: originator_name {
    type: string
    sql: CASE WHEN ${TABLE}.originator_name != ' ' THEN ${TABLE}.originator_name ELSE ${TABLE}.consumer_name END ;;
  }

  dimension: driver_age {
    type: number
    sql: ${TABLE}.driver_age ;;
  }


  dimension: tp_freq_br {
    type: string
    sql: ${TABLE}.tp_freq_br;;
    }


  measure: av_quoted_premium {
    description: "Average quoted premium"
    type: average
    sql: ${TABLE}.avg_quoted_premium ;;
    value_format_name: gbp
  }

  measure: sales {
    type:  sum
    sql: ${TABLE}.sale_flag ;;
  }



}
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
#   }
