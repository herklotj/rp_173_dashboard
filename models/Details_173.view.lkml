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
       veh.vehicle_make,
       veh.vehicle_model,
       veh.vehicle_value_amount,
       veh.annual_mileage,
       veh.registration_number,
       veh.purchase_dt,
       drv.no_claims,
       drv.no_convictions,
       drv.no_oth_vehicles_driven,
       mi.rct_mi_15 AS risk_attitude,
       CASE
         WHEN sal.insurer_quote_ref IS NULL THEN 0
         ELSE 1
       END AS sale_flag,
       AVG(quotedpremium_ap_notinclipt) AS avg_quoted_premium,
       MIN(drv.quote_dttm) AS quote_dttm
FROM qs_drivers drv
  LEFT JOIN qs_mi_outputs mi ON drv.quote_id = mi.quote_id
  LEFT JOIN qs_vehicles veh ON drv.quote_id = veh.quote_id
  LEFT JOIN qs_cover cov ON drv.quote_id = cov.quote_id
  LEFT JOIN abi_occupation occ ON drv.main_occupation = lpad(occ.abi_code,3,'0')
  LEFT JOIN hourly_sales sal ON drv.quote_id = LEFT (sal.insurer_quote_ref,36)
WHERE drv.driver_id = '0'
AND   rct_mi_13 = '173'
AND   cov.rct_noquote_an = 0
AND   drv.quote_dttm > '2019-11-28'
GROUP BY drv.forename,
         drv.surname,
         drv.birth_dt,
         drv.ncb_years,
         occ.occupation,
         cov.risk_postcode,
         cov.originator_name,
        cov.consumer_name,
         veh.vehicle_make,
         veh.vehicle_model,
         veh.vehicle_value_amount,
         veh.annual_mileage,
         veh.registration_number,
         veh.purchase_dt,
         drv.no_claims,
         drv.no_convictions,
         drv.no_oth_vehicles_driven,
         mi.rct_mi_15,
         CASE
           WHEN sal.insurer_quote_ref IS NULL THEN 0
           ELSE 1
         END

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
  dimension_group: quote {
    description: "Quote date"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.quote_dttm ;;
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
    type: number
    sql: ${TABLE}.risk_attitude ;;
  }
  dimension: av_quoted_premium {
    description: "Average quoted premium"
    type: number
    sql: ${TABLE}.avg_quoted_premium ;;
  }
  dimension: sale_flag {
    description: "indicator of sale on quote"
    type: number
    sql: ${TABLE}.sale_flag ;;
  }

  dimension: originator_name {
    type: string
    sql: CASE WHEN ${TABLE}.originator_name != ' ' THEN ${TABLE}.originator_name ELSE ${TABLE}.consumer_name END ;;
  }
}
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
#   }
