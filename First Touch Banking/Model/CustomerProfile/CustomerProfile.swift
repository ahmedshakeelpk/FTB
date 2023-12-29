//
//  CustomerProfile.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 26/01/2022.
//  Copyright © 2022 irum Zubair. All rights reserved.
//

import Foundation
import ObjectMapper

struct Customerprofile: Mappable {
    var response : Int?
    var message : String?
    var data : Customer?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response <- map["response"]
        message <- map["message"]
        data <- map["data"]
    }

}



struct Customer : Mappable {
    var response_code : Int?
    var customer_no : String?
    var customer_type : String?
    var customer_name1 : String?
    var current_add_line1 : String?
    var current_add_line2 : String?
    var current_add_line3 : String?
    var current_add_line4 : String?
    var country : String?
    var short_name : String?
    var nationality : String?
    var language : String?
    var exposure_country : String?
    var local_branch : String?
    var liability_no : String?
    var unique_id_name : String?
    var unique_id_value : String?
    var frozen : String?
    var deceased : String?
    var whereabouts_unknown : String?
    var customer_category : String?
    var record_stat : String?
    var auth_stat : String?
    var mod_no : Int?
    var maker_id : String?
    var maker_dt_stamp : String?
    var checker_id : String?
    var checker_dt_stamp : String?
    var once_auth : String?
    var fx_cust_clean_risk_limit : Int?
    var overall_limit : Int?
    var fx_clean_risk_limit : Int?
    var revision_date : String?
    var limit_ccy : String?
    var sec_cust_clean_risk_limit : Int?
    var sec_clean_risk_limit : Int?
    var sec_cust_pstl_risk_limit : Int?
    var sec_pstl_risk_limit : Int?
    var default_media : String?
    var utility_provider : String?
    var full_name : String?
    var aml_required : String?
    var mailers_required : String?
    var cif_status_since : String?
    var chk_digit_valid_reqd : String?
    var ft_accting_as_of : String?
    var unadvised : String?
    var tax_group : String?
    var consol_tax_cert_reqd : String?
    var individual_tax_cert_reqd : String?
    var cls_ccy_allowed : String?
    var cls_participant : String?
    var fx_netting_customer : String?
    var crm_customer : String?
    var issuer_customer : String?
    var treasury_customer : String?
    var cif_creation_date : String?
    var wht_pct : Int?
    var rp_customer : String?
    var generate_mt920 : String?
    var kyc_details : String?
    var staff : String?
    var private_customer : String?
    var lc_collateral_pct : Int?
    var elcm_customer : String?
    var auto_create_account : String?
    var track_limits : String?
    var ar_ap_tracking : String?
    var autogen_stmtplan : String?
    var mfi_customer : String?
    var invest_cust : String?
    var allow_vrtl_accnts : String?
    var accounts : [AccountsCustomer]?
    var mobile_number : String?
    var email : String?
    var perm_add_line1 : String?
    var perm_add_line2 : String?
    var perm_add_line3 : String?
    var corres_add_line1 : String?
    var corres_add_line2 : String?
    var corres_add_line3 : String?
    var marital_status : String?
    var mobile_number_for_OTP : String?
    var verificationStatus : String?
    var gender : String?
    var dateOfBirth : String?
    var city : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        response_code <- map["response_code"]
        customer_no <- map["customer_no"]
        customer_type <- map["customer_type"]
        customer_name1 <- map["customer_name1"]
        current_add_line1 <- map["current_add_line1"]
        current_add_line2 <- map["current_add_line2"]
        current_add_line3 <- map["current_add_line3"]
        current_add_line4 <- map["current_add_line4"]
        country <- map["country"]
        short_name <- map["short_name"]
        nationality <- map["nationality"]
        language <- map["language"]
        exposure_country <- map["exposure_country"]
        local_branch <- map["local_branch"]
        liability_no <- map["liability_no"]
        unique_id_name <- map["unique_id_name"]
        unique_id_value <- map["unique_id_value"]
        frozen <- map["frozen"]
        deceased <- map["deceased"]
        whereabouts_unknown <- map["whereabouts_unknown"]
        customer_category <- map["customer_category"]
        record_stat <- map["record_stat"]
        auth_stat <- map["auth_stat"]
        mod_no <- map["mod_no"]
        maker_id <- map["maker_id"]
        maker_dt_stamp <- map["maker_dt_stamp"]
        checker_id <- map["checker_id"]
        checker_dt_stamp <- map["checker_dt_stamp"]
        once_auth <- map["once_auth"]
        fx_cust_clean_risk_limit <- map["fx_cust_clean_risk_limit"]
        overall_limit <- map["overall_limit"]
        fx_clean_risk_limit <- map["fx_clean_risk_limit"]
        revision_date <- map["revision_date"]
        limit_ccy <- map["limit_ccy"]
        sec_cust_clean_risk_limit <- map["sec_cust_clean_risk_limit"]
        sec_clean_risk_limit <- map["sec_clean_risk_limit"]
        sec_cust_pstl_risk_limit <- map["sec_cust_pstl_risk_limit"]
        sec_pstl_risk_limit <- map["sec_pstl_risk_limit"]
        default_media <- map["default_media"]
        utility_provider <- map["utility_provider"]
        full_name <- map["full_name"]
        aml_required <- map["aml_required"]
        mailers_required <- map["mailers_required"]
        cif_status_since <- map["cif_status_since"]
        chk_digit_valid_reqd <- map["chk_digit_valid_reqd"]
        ft_accting_as_of <- map["ft_accting_as_of"]
        unadvised <- map["unadvised"]
        tax_group <- map["tax_group"]
        consol_tax_cert_reqd <- map["consol_tax_cert_reqd"]
        individual_tax_cert_reqd <- map["individual_tax_cert_reqd"]
        cls_ccy_allowed <- map["cls_ccy_allowed"]
        cls_participant <- map["cls_participant"]
        fx_netting_customer <- map["fx_netting_customer"]
        crm_customer <- map["crm_customer"]
        issuer_customer <- map["issuer_customer"]
        treasury_customer <- map["treasury_customer"]
        cif_creation_date <- map["cif_creation_date"]
        wht_pct <- map["wht_pct"]
        rp_customer <- map["rp_customer"]
        generate_mt920 <- map["generate_mt920"]
        kyc_details <- map["kyc_details"]
        staff <- map["staff"]
        private_customer <- map["private_customer"]
        lc_collateral_pct <- map["lc_collateral_pct"]
        elcm_customer <- map["elcm_customer"]
        auto_create_account <- map["auto_create_account"]
        track_limits <- map["track_limits"]
        ar_ap_tracking <- map["ar_ap_tracking"]
        autogen_stmtplan <- map["autogen_stmtplan"]
        mfi_customer <- map["mfi_customer"]
        invest_cust <- map["invest_cust"]
        allow_vrtl_accnts <- map["allow_vrtl_accnts"]
        accounts <- map["accounts"]
        mobile_number <- map["mobile_number"]
        email <- map["email"]
        perm_add_line1 <- map["perm_add_line1"]
        perm_add_line2 <- map["perm_add_line2"]
        perm_add_line3 <- map["perm_add_line3"]
        corres_add_line1 <- map["corres_add_line1"]
        corres_add_line2 <- map["corres_add_line2"]
        corres_add_line3 <- map["corres_add_line3"]
        marital_status <- map["marital_status"]
        mobile_number_for_OTP <- map["mobile_number_for_OTP"]
        verificationStatus <- map["verificationStatus"]
        gender <- map["gender"]
        dateOfBirth <- map["dateOfBirth"]
        city <- map["city"]
    }

}
struct AccountsCustomer : Mappable {
    var account_class : String?
    var account_number : String?
    var branch_code : String?
    var user_id : String?
    var source_of_funds : String?
    var purpose_of_funds : String?
    var iban : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        account_class <- map["account_class"]
        account_number <- map["account_number"]
        branch_code <- map["branch_code"]
        user_id <- map["user_id"]
        source_of_funds <- map["source_of_funds"]
        purpose_of_funds <- map["purpose_of_funds"]
        iban <- map["iban"]
    }

}
