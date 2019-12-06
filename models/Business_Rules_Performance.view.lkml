view: business_rules_performance {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT quote_date,
       channel,
       quote_type,
       rct_modelnumber,
       age_ncd_acceptable,
       quotes,
       no_quotes,
       refer_count,
       rct_br001_covertype,
       rct_br002_piratedarea,
       rct_br003_postalsector,
       rct_br004_postalarea,
       rct_br005_quotelag,
       rct_br006_insuredprevdeclinedcancelled,
       rct_br007_ncdgreaterthanresidencyyears,
       rct_br008_ncdgreaterthanlicenceyears,
       rct_br009_nonmotoringconvictions,
       rct_br010_ncdwayearned,
       rct_br011_ncdpdeclined,
       rct_br012_driverage,
       rct_br013_driverlicencetype,
       rct_br014_driverlicenceyears,
       rct_br015_driverresidency,
       rct_br016_driversnb,
       rct_br017_maindriver,
       rct_br018_relationshiptoph,
       rct_br019_anydriver,
       rct_br020_classofuse,
       rct_br021_carowner,
       rct_br022_registeredkeeper,
       rct_br023_vehicleage,
       rct_br024_lhd,
       rct_br025_modifications,
       rct_br026_minvehiclevalue,
       rct_br027_maxvehiclevalue,
       rct_br028_vehiclesecurity,
       rct_br029_overnightaddress,
       rct_br030_carregunavilable,
       rct_br031_vehiclenotyetpurchased,
       rct_br032_mileage,
       rct_br033_drivernonminorconvictions,
       rct_br034_policyconvictions,
       rct_br035_policywsclaims,
       rct_br036_policynonwsclaims,
       rct_br037_policyclaimsandconvictions,
       rct_br039_vehicledecline,
       rct_br040_fueltype,
       rct_br041_excess,
       rct_br042_insufficientdata,
       rct_br043_noofmtas,
       rct_br044_occupation,
       rct_br045_businesstype,
       rct_br046_classofuse_occbustype,
       rct_br047_strategic,
       rct_br048_vehicleimported,
       rct_br049_vehiclescrapped,
       rct_br050_vehicleexported,
       rct_br051_vehicleimportednoneu,
       rct_br052_vehiclefinancepresent,
       rct_br053_vehiclelosstype,
       rct_br054_vehicletheftindicator,
       rct_br055_vehiclemileagedata,
       rct_br056_vehiclestolen,
       rct_br057_noofpreviouskeepers,
       rct_br058_vicresult,
       rct_br059_cueclaimscount,
       rct_br060_cuepiclaimscount,
       rct_br061_delphinoaddresstrace,
       rct_br062_electoralrollnameandaddressmatch,
       rct_br63_ccjorbankruptcy,
       rct_br64_caisaccounts,
       rct_br65_capssearches,
       rct_br66_creditscore,
       rct_br67_throttle,
       rct_br68_phdrivingstatus,
       rct_br69_parentfronting,
       rct_br70_vehicleperformance,
       rct_br71_time_of_day,
       rct_br72_ncd_years,
       rct_br73_sira,
       rct_br74_ncd_invalid,
       rct_br75_vehicle_compatible_smart,
       rct_br76_risk_attitude,
       rct_br77_tp_freq
FROM actian.v_rpt_daily_br_173;;
  }

  # Define your dimensions and measures here, like this:
  dimension: quote_type {
    description: "Business type of quote"
    type: string
    sql: ${TABLE}.quote_type ;;
  }

  dimension_group: quote_date {
    description: "Date of quotes"
    type: time
    timeframes: [date]
    sql: CAST(${TABLE}.quote_date AS TIMESTAMP WITHOUT TIME ZONE) ;;
  }

  dimension: channel {
    description: "Channel through which the quote came"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: Model_number {
    description: "Model the quote came through"
    type: string
    sql: ${TABLE}.rct_modelnumber ;;
  }

  dimension: age_ncd_accpetable {
    description: "Driver age > 20 and ncd > 0"
    type: string
    sql: ${TABLE}.age_ncd_acceptable ;;
  }

  dimension: quotes {
    description: "Number of quotes"
    type: number
    sql: ${TABLE}.quotes ;;
  }

  dimension: declined_quotes{
    description: "Number of quotes declined"
    type: number
    sql: ${TABLE}.no_quotes ;;
  }

  dimension: referred_quotes {
    description: "Business type of quote"
    type: number
    sql: ${TABLE}.quote_type ;;
  }


  dimension: dummy_br {

    case: {
      when: {
        label: "br001_cover_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br002_pirated_area"
        sql: 1=1 ;;
      }
      when: {
        label: "br003_postal_sector"
        sql: 1=1 ;;
      }
      when: {
        label: "br004_postal_area"
        sql: 1=1 ;;
      }
      when: {
        label: "br005_quote_lag"
        sql: 1=1 ;;
      }
      when: {
        label: "br006_insured_prev_declined_cancelled"
        sql: 1=1 ;;
      }
      when: {
        label: "br007_ncd_greater_than_residency_years"
        sql: 1=1 ;;
      }
      when: {
        label: "br008_ncd_greater_than_licence_years"
        sql: 1=1 ;;
      }
      when: {
        label: "br009_non_motoring_conivctions"
        sql: 1=1 ;;
      }
      when: {
        label: "br010_ncd_way_earned"
        sql: 1=1 ;;
      }
      when: {
        label: "br011_ncd_p_declined"
        sql: 1=1 ;;
      }
      when: {
        label: "br012_driver_age"
        sql: 1=1 ;;
      }
      when: {
        label: "br013_driver_licence_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br014_driver_licence_years"
        sql: 1=1 ;;
      }
      when: {
        label: "br015_driver_residency"
        sql: 1=1 ;;
      }
      when: {
        label: "br016_drivers_nb"
        sql: 1=1 ;;
      }
      when: {
        label: "br017_main_driver"
        sql: 1=1 ;;
      }
      when: {
        label: "br018_relationship_to_ph"
        sql: 1=1 ;;
      }
      when: {
        label: "br019_any_driver"
        sql: 1=1 ;;
      }
      when: {
        label: "br020_class_of_use"
        sql: 1=1 ;;
      }
      when: {
        label: "br021_car_owner"
        sql: 1=1 ;;
      }
      when: {
        label: "br022_registered_keeper"
        sql: 1=1 ;;
      }
      when: {
        label: "br023_vehicle_age"
        sql: 1=1 ;;
      }
      when: {
        label: "br024_lhd"
        sql: 1=1 ;;
      }
      when: {
        label: "br025_modifications"
        sql: 1=1 ;;
      }
      when: {
        label: "br026_min_vehicle_value"
        sql: 1=1 ;;
      }
      when: {
        label: "br027_max_vehicle_value"
        sql: 1=1 ;;
      }
      when: {
        label: "br028_vehicle_security"
        sql: 1=1 ;;
      }
      when: {
        label: "br029_overnight_address"
        sql: 1=1 ;;
      }
      when: {
        label: "br030_car_reg_unavailable"
        sql: 1=1 ;;
      }
      when: {
        label: "br031_vehicle_not_yet_purchased"
        sql: 1=1 ;;
      }
      when: {
        label: "br032_mileage"
        sql: 1=1 ;;
      }
      when: {
        label: "br033_driver_non_minor_convictions"
        sql: 1=1 ;;
      }
      when: {
        label: "br034_policy_convictions"
        sql: 1=1 ;;
      }
      when: {
        label: "br035_policy_ws_claims"
        sql: 1=1 ;;
      }
      when: {
        label: "br036_policy_non_windscreen_claims"
        sql: 1=1 ;;
      }
      when: {
        label: "br037_policy_claims_and_convictions"
        sql: 1=1 ;;
      }
      when: {
        label: "br039_vehicle_decline"
        sql: 1=1 ;;
      }
      when: {
        label: "br040_fuel_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br041_excess"
        sql: 1=1 ;;
      }
      when: {
        label: "br042_insufficient_data"
        sql: 1=1 ;;
      }
      when: {
        label: "br043_no_of_mtas"
        sql: 1=1 ;;
      }
      when: {
        label: "br044_occupation"
        sql: 1=1 ;;
      }
      when: {
        label: "br045_business_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br046_class_of_use_occ_bus_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br047_stategic"
        sql: 1=1 ;;
      }
      when: {
        label: "br048_vehicle_imported"
        sql: 1=1 ;;
      }
      when: {
        label: "br049_vehicle_scrapped"
        sql: 1=1 ;;
      }
      when: {
        label: "br050_vehicle_exported"
        sql: 1=1 ;;
      }
      when: {
        label: "br051_vehicle_imported_non_eu"
        sql: 1=1 ;;
      }
      when: {
        label: "br052_vehicle_finance_present"
        sql: 1=1 ;;
      }
      when: {
        label: "br053_vehicle_loss_type"
        sql: 1=1 ;;
      }
      when: {
        label: "br054_vehicle_theft_indicator"
        sql: 1=1 ;;
      }
      when: {
        label: "br055_vehicle_mileage_data"
        sql: 1=1 ;;
      }
      when: {
        label: "br056_vehicle_stolen"
        sql: 1=1 ;;
      }
      when: {
        label: "br057_no_of_previous_keepers"
        sql: 1=1 ;;
      }
      when: {
        label: "br058_vic_result"
        sql: 1=1 ;;
      }
      when: {
        label: "br059_cue_claims_count"
        sql: 1=1 ;;
      }
      when: {
        label: "br060_cuepiclaimscount"
        sql: 1=1 ;;
      }
      when: {
        label: "br061_delphi_no_address_trace"
        sql: 1=1 ;;
      }
      when: {
        label: "br062_electoral_roll_name_and_address_match"
        sql: 1=1 ;;
      }
      when: {
        label: "br063_ccj_or_bankruptcy"
        sql: 1=1 ;;
      }
      when: {
        label: "br064_cais_accounts"
        sql: 1=1 ;;
      }
      when: {
        label: "br065_caps_searches"
        sql: 1=1 ;;
      }
      when: {
        label: "br066_credit_score"
        sql: 1=1 ;;
      }
      when: {
        label: "br067_throttle"
        sql: 1=1 ;;
      }
      when: {
        label: "br068_ph_driving_status"
        sql: 1=1 ;;
      }
      when: {
        label: "br069_parental_fronting"
        sql: 1=1 ;;
      }
      when: {
        label: "br070_vehicle_performance"
        sql: 1=1 ;;
      }
      when: {
        label: "br071_time_of_day"
        sql: 1=1 ;;
      }
      when: {
        label: "br072_ncd_years"
        sql: 1=1 ;;
      }
      when: {
        label: "br073_sira"
        sql: 1=1 ;;
      }
      when: {
        label: "br074_ncd_invalid"
        sql: 1=1 ;;
      }
      when: {
        label: "br075_vehicle_compatible_smart"
        sql: 1=1 ;;
      }
      when: {
        label: "br076_risk_attitude"
        sql: 1=1 ;;
      }
      when: {
        label: "br077_tp_freq"
        sql: 1=1 ;;
      }
    }
  }
  measure: Number_of_quotes_01 {
    type: sum
    sql:${TABLE}.rct_br001_covertype ;;
  }
  measure: Number_of_quotes_02 {
    type: sum
    sql:${TABLE}.rct_br002_piratedarea ;;
  }
  measure: Number_of_quotes_03 {
    type: sum
    sql:${TABLE}.rct_br003_postalsector ;;
  }
  measure: Number_of_quotes_04 {
    type: sum
    sql:${TABLE}.rct_br004_postalarea ;;
  }
  measure: Number_of_quotes_05 {
    type: sum
    sql:${TABLE}.rct_br005_quotelag ;;
  }
  measure: Number_of_quotes_06 {
    type: sum
    sql:${TABLE}.rct_br006_insuredprevdeclinedcancelled ;;
  }
  measure: Number_of_quotes_07 {
    type: sum
    sql:${TABLE}.rct_br007_ncdgreaterthanresidencyyears ;;
  }
  measure: Number_of_quotes_08 {
    type: sum
    sql:${TABLE}.rct_br008_ncdgreaterthanlicenceyears ;;
  }
  measure: Number_of_quotes_09 {
    type: sum
    sql:${TABLE}.rct_br009_nonmotoringconvictions ;;
  }
  measure: Number_of_quotes_10 {
    type: sum
    sql:${TABLE}.rct_br010_ncdwayearned ;;
  }
  measure: Number_of_quotes_11 {
    type: sum
    sql:${TABLE}.rct_br011_ncdpdeclined ;;
  }
  measure: Number_of_quotes_12 {
    type: sum
    sql:${TABLE}.rct_br012_driverage ;;
  }
  measure: Number_of_quotes_13 {
    type: sum
    sql:${TABLE}.rct_br013_driverlicencetype ;;
  }
  measure: Number_of_quotes_14 {
    type: sum
    sql:${TABLE}.rct_br014_driverlicenceyears ;;
  }
  measure: Number_of_quotes_15 {
    type: sum
    sql:${TABLE}.rct_br015_driverresidency ;;
  }
  measure: Number_of_quotes_16 {
    type: sum
    sql:${TABLE}.rct_br016_driversnb ;;
  }
  measure: Number_of_quotes_17 {
    type: sum
    sql:${TABLE}.rct_br017_maindriver ;;
  }
  measure: Number_of_quotes_18 {
    type: sum
    sql:${TABLE}.rct_br018_relationshiptoph ;;
  }
  measure: Number_of_quotes_19 {
    type: sum
    sql:${TABLE}.rct_br019_anydriver ;;
  }
  measure: Number_of_quotes_20 {
    type: sum
    sql:${TABLE}.rct_br020_classofuse ;;
  }
  measure: Number_of_quotes_21 {
    type: sum
    sql:${TABLE}.rct_br021_carowner ;;
  }
  measure: Number_of_quotes_22 {
    type: sum
    sql:${TABLE}.rct_br022_registeredkeeper ;;
  }
  measure: Number_of_quotes_23 {
    type: sum
    sql:${TABLE}.rct_br023_vehicleage ;;
  }
  measure: Number_of_quotes_24 {
    type: sum
    sql:${TABLE}.rct_br024_lhd ;;
  }
  measure: Number_of_quotes_25 {
    type: sum
    sql:${TABLE}.rct_br025_modifications ;;
  }
  measure: Number_of_quotes_26 {
    type: sum
    sql:${TABLE}.rct_br026_minvehiclevalue ;;
  }
  measure: Number_of_quotes_27 {
    type: sum
    sql:${TABLE}.rct_br027_maxvehiclevalue ;;
  }
  measure: Number_of_quotes_28 {
    type: sum
    sql:${TABLE}.rct_br028_vehiclesecurity ;;
  }
  measure: Number_of_quotes_29 {
    type: sum
    sql:${TABLE}.rct_br029_overnightaddress ;;
  }
  measure: Number_of_quotes_30 {
    type: sum
    sql:${TABLE}.rct_br030_carregunavilable ;;
  }
  measure: Number_of_quotes_31 {
    type: sum
    sql:${TABLE}.rct_br031_vehiclenotyetpurchased ;;
  }
  measure: Number_of_quotes_32 {
    type: sum
    sql:${TABLE}.rct_br032_mileage ;;
  }
  measure: Number_of_quotes_33 {
    type: sum
    sql:${TABLE}.rct_br033_drivernonminorconvictions ;;
  }
  measure: Number_of_quotes_34 {
    type: sum
    sql:${TABLE}.rct_br034_policyconvictions ;;
  }
  measure: Number_of_quotes_35 {
    type: sum
    sql:${TABLE}.rct_br035_policywsclaims ;;
  }
  measure: Number_of_quotes_36 {
    type: sum
    sql:${TABLE}.rct_br036_policynonwsclaims ;;
  }
  measure: Number_of_quotes_37 {
    type: sum
    sql:${TABLE}.rct_br037_policyclaimsandconvictions ;;
  }
  measure: Number_of_quotes_39 {
    type: sum
    sql:${TABLE}.rct_br039_vehicledecline ;;
  }
  measure: Number_of_quotes_40 {
    type: sum
    sql:${TABLE}.rct_br040_fueltype ;;
  }
  measure: Number_of_quotes_41 {
    type: sum
    sql:${TABLE}.rct_br041_excess ;;
  }
  measure: Number_of_quotes_42 {
    type: sum
    sql:${TABLE}.rct_br042_insufficientdata ;;
  }
  measure: Number_of_quotes_43 {
    type: sum
    sql:${TABLE}.rct_br043_noofmtas ;;
  }
  measure: Number_of_quotes_44 {
    type: sum
    sql:${TABLE}.rct_br044_occupation ;;
  }
  measure: Number_of_quotes_45 {
    type: sum
    sql:${TABLE}.rct_br045_businesstype ;;
  }
  measure: Number_of_quotes_46 {
    type: sum
    sql:${TABLE}.rct_br046_classofuse_occbustype ;;
  }
  measure: Number_of_quotes_47 {
    type: sum
    sql:${TABLE}.rct_br047_strategic ;;
  }
  measure: Number_of_quotes_48 {
    type: sum
    sql:${TABLE}.rct_br048_vehicleimported ;;
  }
  measure: Number_of_quotes_49 {
    type: sum
    sql:${TABLE}.rct_br049_vehiclescrapped ;;
  }
  measure: Number_of_quotes_50 {
    type: sum
    sql:${TABLE}.rct_br050_vehicleexported ;;
  }
  measure: Number_of_quotes_51 {
    type: sum
    sql:${TABLE}.rct_br051_vehicleimportednoneu ;;
  }
  measure: Number_of_quotes_52 {
    type: sum
    sql:${TABLE}.rct_br052_vehiclefinancepresent ;;
  }
  measure: Number_of_quotes_53 {
    type: sum
    sql:${TABLE}.rct_br053_vehiclelosstype ;;
  }
  measure: Number_of_quotes_54 {
    type: sum
    sql:${TABLE}.rct_br054_vehicletheftindicator ;;
  }
  measure: Number_of_quotes_55 {
    type: sum
    sql:${TABLE}.rct_br055_vehiclemileagedata ;;
  }
  measure: Number_of_quotes_56 {
    type: sum
    sql:${TABLE}.rct_br056_vehiclestolen ;;
  }
  measure: Number_of_quotes_57 {
    type: sum
    sql:${TABLE}.rct_br057_noofpreviouskeepers ;;
  }
  measure: Number_of_quotes_58 {
    type: sum
    sql:${TABLE}.rct_br058_vicresult ;;
  }
  measure: Number_of_quotes_59 {
    type: sum
    sql:${TABLE}.rct_br059_cueclaimscount ;;
  }
  measure: Number_of_quotes_60 {
    type: sum
    sql:${TABLE}.rct_br060_cuepiclaimscount ;;
  }
  measure: Number_of_quotes_61 {
    type: sum
    sql:${TABLE}.rct_br061_delphinoaddresstrace ;;
  }
  measure: Number_of_quotes_62 {
    type: sum
    sql:${TABLE}.rct_br062_electoralrollnameandaddressmatch ;;
  }
  measure: Number_of_quotes_63 {
    type: sum
    sql:${TABLE}.rct_br63_ccjorbankruptcy ;;
  }
  measure: Number_of_quotes_64 {
    type: sum
    sql:${TABLE}.rct_br64_caisaccounts ;;
  }
  measure: Number_of_quotes_65 {
    type: sum
    sql:${TABLE}.rct_br65_capssearches ;;
  }
  measure: Number_of_quotes_66 {
    type: sum
    sql:${TABLE}.rct_br66_creditscore ;;
  }
  measure: Number_of_quotes_67 {
    type: sum
    sql:${TABLE}.rct_br67_throttle ;;
  }
  measure: Number_of_quotes_68 {
    type: sum
    sql:${TABLE}.rct_br68_phdrivingstatus ;;
  }
  measure: Number_of_quotes_69 {
    type: sum
    sql:${TABLE}.rct_br69_parentfronting ;;
  }
  measure: Number_of_quotes_70 {
    type: sum
    sql:${TABLE}.rct_br70_vehicleperformance ;;
  }
  measure: Number_of_quotes_71 {
    type: sum
    sql:${TABLE}.rct_br71_time_of_day ;;
  }
  measure: Number_of_quotes_72 {
    type: sum
    sql:${TABLE}.rct_br72_ncd_years ;;
  }
  measure: Number_of_quotes_73 {
    type: sum
    sql:${TABLE}.rct_br73_sira ;;
  }
  measure: Number_of_quotes_74 {
    type: sum
    sql:${TABLE}.rct_br74_ncd_invalid ;;
  }
  measure: Number_of_quotes_75 {
    type: sum
    sql:${TABLE}.rct_br75_vehicle_compatible_smart ;;
  }
  measure: Number_of_quotes_76 {
    type: sum
    sql:${TABLE}.rct_br76_risk_attitude ;;
  }
  measure: Number_of_quotes_77 {
    type: sum
    sql:${TABLE}.rct_br77_tp_freq ;;
  }
  measure: total_quotes {
    type: sum
    sql:${TABLE}.no_quotes ;;
  }
}
