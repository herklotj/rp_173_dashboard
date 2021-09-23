view: 173_renweals_discount  {

  derived_table: {
    sql:
SELECT
policy_reference_number,
term_inception_date,
renewal_date,
membership_no,
reg_no,
origin,
risk_postcode,
declared_avg_miles_per_day,
avg_miles_per_day,
CASE WHEN Avg_miles_per_day <= declared_avg_miles_per_day then 'DISCOUNT' ELSE 'NO ACTION' end as rating

FROM (


      select
          *
          ,annual_mileage / 365.25 as declared_avg_miles_per_day
          ,(can_km_driven/1.6) / device_days as Avg_miles_per_day
        from

(
SELECT policy_reference_number, insurerquoteref as nb_quote_ref, term_inception_date, transaction_period_end_date + 1 as renewal_date

FROM ice_aa_policy_summary
WHERE policy_transaction_type IN ('NEW_BUSINESS','RENEWAL_ACCEPT','CANCELLATION')

AND (CASE WHEN substr (policy_reference_number,6,1) = 1 THEN '103' WHEN substr (policy_reference_number,6,1) = 2 THEN '173' ELSE '102' END) = '173'

GROUP BY policy_reference_number, insurerquoteref, term_inception_date, transaction_period_end_date + 1

HAVING
SUM(CASE WHEN to_date (transaction_period_start_date) <= to_date (sysdate)  AND to_date (transaction_period_end_date) >= to_date (sysdate)  AND policy_transaction_type IN ('NEW_BUSINESS','RENEWAL_ACCEPT') THEN 1 WHEN to_date (transaction_period_start_date) <= to_date (sysdate)  AND to_date (transaction_period_end_date) >= to_date (sysdate)  AND policy_transaction_type = 'CANCELLATION' THEN -1 ELSE 0 END) = 1

          )pol_summary

        left join
          si_v2_file mb
          on mb.membership_no = pol_summary.policy_reference_number

        left join
          (select
              mb_membership_no
              ,min(start_time) as first_journey
              ,max(start_time) as most_recent_journey
              ,TIMESTAMPDIFF(day,min(to_date(start_time)),to_date(sysdate)) as device_days
              ,sum(can_distance)/1000 as can_km_driven
              ,sum(gps_distance)/1000 as gps_km_driven
              ,max(odometer)/1000 as car_odo_km
              ,max(can_max_speed) as can_max_speed
              ,max(gps_max_speed) as gps_max_speed
              ,sum(harsh_acc_count) as harsh_accs
              ,sum(harsh_dec_count) as harsh_decs
              ,sum(overspeed_count) as overspeeds
              ,sum(brake_count) as brakes
              ,sum(max_rpm_count) as max_rpms
              ,count(*) as journeys

            from
              si_journey_summary
            group by mb_membership_no
           ) driving_data
           on pol_summary.policy_reference_number = driving_data.mb_membership_no

        left join
          (select
              quote_id
              ,quote_dttm
              ,risk_postcode
              ,case when consumer_name ='Aggregator' then originator_name else consumer_name end as channel
              ,initial_quote_to_inception
            from
              qs_cover
            where quote_dttm >='2020-10-01'
           ) cov
           on cov.quote_id = pol_summary.nb_quote_ref

        left join
          (select
              quote_id
              ,registration_number
              ,annual_mileage
              ,overnight_postcode
            from
              qs_vehicles
            where quote_dttm >='2020-10-01'
           )veh
           on veh.quote_id = pol_summary.nb_quote_ref

           LEFT JOIN (SELECT DISTINCT policy_number FROM ice_aa_pol2clm) clm ON pol_summary.policy_reference_number = clm.policy_number


) a

WHERE policy_number IS NULL
AND (CASE WHEN Avg_miles_per_day <= declared_avg_miles_per_day then 'DISCOUNT' ELSE 'NO ACTION' end) = 'DISCOUNT'


          ;;
  }

  dimension: Policy_Number {
    type: string
    sql: ${TABLE}.policy_reference_number ;;
  }

  dimension: term_inception_date {
    type: date
    sql: ${TABLE}.term_inception_date ;;
  }

  dimension: renewal_date {
    type: date
    sql: ${TABLE}.renewal_date ;;
  }

  dimension: membership_no {
    type: string
    sql: ${TABLE}.membership_no ;;
  }

  dimension: reg_no {
    type: string
    sql: ${TABLE}.reg_no ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: risk_postcode {
    type: string
    sql: ${TABLE}.risk_postcode ;;
  }

  dimension: declared_avg_miles_per_day {
    type: number
    sql: ${TABLE}.declared_avg_miles_per_day ;;
  }

  dimension: avg_miles_per_day {
    type: number
    sql: ${TABLE}.avg_miles_per_day ;;
  }

  dimension: rating {
    type: string
    sql: CASE WHEN Avg_miles_per_day <= declared_avg_miles_per_day then 'DISCOUNT' ELSE 'NO ACTION' end ;;
  }





}
