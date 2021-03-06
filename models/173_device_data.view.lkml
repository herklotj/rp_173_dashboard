view: 173_device_data  {

   derived_table: {
     sql:
      select
          *

          ,annual_mileage / 365.25 as declared_avg_miles_per_day
          ,case when cancellation_date >= inception_date then 'Cancelled'
                when inception_date <= to_date(sysdate)  then 'Live'
                 end as Live
        from

          (
            select
              policy_reference_number
              ,max(case when policy_transaction_type ='NEW_BUSINESS' then inception_date end) as inception_date
              ,max(case when policy_transaction_type ='CANCELLATION' then transaction_period_start_date end) as cancellation_date
              ,max(case when policy_transaction_type ='NEW_BUSINESS' then insurerquoteref end) as nb_quote_ref
            from
            ice_aa_policy_summary
            where scheme = 173
            group by policy_reference_number
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
          ;;
    }

    dimension: Policy_Number {
      type: string
      sql: ${TABLE}.policy_reference_number ;;
    }

  dimension: Live_Policy {
    type: string
    sql: ${TABLE}.Live ;;
  }

    dimension: Inception_date {
      type:  date
      sql: ${TABLE}.inception_date ;;
    }

  dimension: Device_Posted_Date {
    type:  date
    sql: ${TABLE}.date_posted ;;
  }

  dimension: First_Journey_Date{
    type:  date
    sql: ${TABLE}.first_journey ;;
  }

  dimension: Most_Recent_Journey_Date{
    type:  date
    sql: ${TABLE}.most_recent_journey ;;
  }

  measure: Device_Installed {
    type: number
    sql: sum(case when Live = 'Live' and device_days > 0 then 1 when Live = 'Live' and ifNull(device_days,-1) =-1 then 0 end) ;;
  }


  measure: Days_since_posted {
    type: number
    sql: min(case when Live = 'Live' and ifNull(device_days,-1) =-1 then TIMESTAMPDIFF(day,date_posted,sysdate)end) ;;

  }

  measure: Total_Miles_Driven_Can {
    type: number
    sql:sum( ${TABLE}.can_km_driven/1.6 )    ;;
    value_format_name: decimal_0
  }

  measure: Max_MPH_Can {
    type: number
    sql:max( ${TABLE}.can_max_speed/1.6 );;
    value_format_name: decimal_0
  }

  measure: Avg_miles_per_day_can  {
    type: number
    sql: sum(can_km_driven/1.6) / sum(device_days) ;;
    value_format_name: decimal_0
  }

  measure: Avg_miles_per_day_declared  {
    type: number
    sql: sum(annual_mileage / 365.25)/count(*);;
    value_format_name: decimal_0
  }

  measure: Actual_vs_Declared_miles {
    type: number
    sql: ${Avg_miles_per_day_can}/${Avg_miles_per_day_declared}-1 ;;
    value_format_name: percent_0

  }

  measure: Journeys_Count {
    type: number
    sql: sum(${TABLE}.journeys) ;;
    value_format_name: decimal_0
  }

  measure: Harsh_accs_Count {
    type: number
    sql: sum(${TABLE}.harsh_accs) ;;
    value_format_name: decimal_0
  }

  measure: Harsh_decs_Count {
    type: number
    sql: sum(${TABLE}.harsh_decs) ;;
    value_format_name: decimal_0
  }

  measure: Overspeeds_Count {
    type: number
    sql: sum(${TABLE}.overspeeds) ;;
    value_format_name: decimal_0
  }

    }
